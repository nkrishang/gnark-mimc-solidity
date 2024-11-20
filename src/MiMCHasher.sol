// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract MiMCHasher {
    uint256 private constant MIMC_ROUNDS = 110;
    uint256 private constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    
    // Round constants. Matches gnark: rounds=110 seed="seed"
    uint256 private constant ROUND_CONSTANT_1 = 0x00808370c37267481fb91b077899955706f209e5e0762dac2c79ba1e7a91b018;
    uint256 private constant ROUND_CONSTANT_2 = 0x1f6e7f6a521c0af287b4d065a78dcd43b959592d734118f9d32767fad2dd3449;
    uint256 private constant ROUND_CONSTANT_3 = 0x1cf181571ab5e33e734617eb8fefff7fb25ef2af75079b6a084ff63f7075f091;
    uint256 private constant ROUND_CONSTANT_4 = 0x296c369bf999f895bd69945f2f44102f8369e8096b23bcb1c9c76cd2ef26dde0;
    uint256 private constant ROUND_CONSTANT_5 = 0x01c2e148c40ea201b748bee72845b349bfa4a4497837af0d569ae47afc6e4243;
    uint256 private constant ROUND_CONSTANT_6 = 0x0f960a7c9a597587843350f0002036f95d5661918a5241117b9496189825dbad;
    uint256 private constant ROUND_CONSTANT_7 = 0x2597fa0df0380dbe040a71ef993e0a0a517f634063bef8b707898521abdec1e9;
    uint256 private constant ROUND_CONSTANT_8 = 0x1f32210825398d59d2aa72031584599ec4cb98568e82780efabfb0c2ce14d729;
    uint256 private constant ROUND_CONSTANT_9 = 0x283392b9145c98fc9680ee035816761cb79155557f0b302511a928c221b04c03;
    uint256 private constant ROUND_CONSTANT_10 = 0x25cb039f97160bafe45185c7ae37f06d561d8d46fc40c1991b28611280aeeff2;
    uint256 private constant ROUND_CONSTANT_11 = 0x2fc4c99ac25032a97c43f57abaf1ca5bba501159bf43415ed934f987163840ee;
    uint256 private constant ROUND_CONSTANT_12 = 0x1963085e7a8de0f59ad7cc25201e077d75c290746386a6710b12e54ae412af7c;
    uint256 private constant ROUND_CONSTANT_13 = 0x0d0915304efc5917df424d2e3d192d9c812c81446fe97542ec6049b6ef7a9bb7;
    uint256 private constant ROUND_CONSTANT_14 = 0x11c89b296c0f060ffcc03768ffbe0ff6484936c732e6f033b46dfd5e31792b07;
    uint256 private constant ROUND_CONSTANT_15 = 0x1596ec4e14505c1a93b11de9fcbe5b9f8d8a4fb12f58e5469986ed9398bdb5a8;
    uint256 private constant ROUND_CONSTANT_16 = 0x16109597bcce3ae43a1084d249d86b69147cd8658583477da57d5baa2a005b95;
    uint256 private constant ROUND_CONSTANT_17 = 0x123313cced613293c40586b110f8e4244cd67cc4380c8f5df4ec60f42216ce28;
    uint256 private constant ROUND_CONSTANT_18 = 0x126d7b2aeb81bf7141c6c92bcd2fee330fe52dc10c38d57c33a3b6af91ca037b;
    uint256 private constant ROUND_CONSTANT_19 = 0x17f818f464c4886e7457e00cf1857079ad3318e9bb0a85db8f90e180fe8c4924;
    uint256 private constant ROUND_CONSTANT_20 = 0x071df6c832aacdc389634a8c451ac132befc1cb4346d9f719557b51f5c18bcc1;
    uint256 private constant ROUND_CONSTANT_21 = 0x0020267d7ca27c578a48624415224016c5f97d5fc89b34937e5947abcb6c7256;
    uint256 private constant ROUND_CONSTANT_22 = 0x06c5eed206090e6a8b7a2252d53b79e095a20f48670c5f13162dda25fe920143;
    uint256 private constant ROUND_CONSTANT_23 = 0x02428faa477723c4259e01d8ab9034d8d20c9dc36a920f037886444ee12422f3;
    uint256 private constant ROUND_CONSTANT_24 = 0x02c2504a6bdd69febc51d1d3199048d6399e7a79448f82132a891d9b997a5ac3;
    uint256 private constant ROUND_CONSTANT_25 = 0x1c0e4ff08c1e78218d6ec96962af3c612b94b681499f344ba73395587d8a3ee8;
    uint256 private constant ROUND_CONSTANT_26 = 0x14e83ce42e31effc8be6e0119ecc4157c1c44206e159aff0761e92a945aa0591;
    uint256 private constant ROUND_CONSTANT_27 = 0x17564d9831eb401b643834fc87cc28870af99ecada5841d5fe5041fc37c6da53;
    uint256 private constant ROUND_CONSTANT_28 = 0x10e54d1b3b9c236ee9b8ceac1c0218a80fe252338ae0f566fa053db07238df3e;
    uint256 private constant ROUND_CONSTANT_29 = 0x1c4a70dbf1425a706204c1885e5cb58c5691f4497de68690f7e7df31665c4018;
    uint256 private constant ROUND_CONSTANT_30 = 0x15ef0a5a78ee6e7ab542f6399e527fee46c4f11bfe2d3fdf42cb7f9d8ebb5f54;
    uint256 private constant ROUND_CONSTANT_31 = 0x03fe98be06edf0b4416aca902a2b51273d354a78c3659032433626a8aaa43575;
    uint256 private constant ROUND_CONSTANT_32 = 0x04f2341c37c35d02747b33fc4c5290680dbec7d25d41353c569692ea52355a67;
    uint256 private constant ROUND_CONSTANT_33 = 0x0d9e4f1c56b68d93228cafa04929b24d1ea5d75247c81406ccbf18e18d127500;
    uint256 private constant ROUND_CONSTANT_34 = 0x04c609941ec5da50d43b8d6d7d45fdd4faa8bb69929fc3337ddfc1bee29f7b94;
    uint256 private constant ROUND_CONSTANT_35 = 0x0864d86dfbf47dd6baef83cbdf4aff82f262d6cca98c54f8a71801027a59e43a;
    uint256 private constant ROUND_CONSTANT_36 = 0x214982740a6e74e652bc133094f0c8bdfa532bf74b84d80b1c34271409c2a398;
    uint256 private constant ROUND_CONSTANT_37 = 0x29ab6b25bf9163f282f6490fca9195ab67e111b9cf456be56dd84da9f12d5b79;
    uint256 private constant ROUND_CONSTANT_38 = 0x0d49f6a66aca120408b616d05af5f82b1d26a9caec59bbb0ab444aa1c8656089;
    uint256 private constant ROUND_CONSTANT_39 = 0x2910726a98b57f1bb854e9837271775c6fccde2c377f64de5cb2f946f8888edb;
    uint256 private constant ROUND_CONSTANT_40 = 0x04350ded3f38a23b702246e6cb96a9acf047d360e7f4ac88dd7281990f7514fa;
    uint256 private constant ROUND_CONSTANT_41 = 0x0b2dddc8994767c7d3632cc7bc089becf8ef3b65540fb4709b8cc78ba12b044b;
    uint256 private constant ROUND_CONSTANT_42 = 0x22ccc3fac120b52ece7d1d2faa77a2c898d01c2842c906a3b134cd5cd90fff3e;
    uint256 private constant ROUND_CONSTANT_43 = 0x011609a97f5ff4f5509812545ac26952fef5a7c4b111bd513a2d756f5b7d8c55;
    uint256 private constant ROUND_CONSTANT_44 = 0x0b9ea4b37c4e9569204d4d3f636d86cc0e3c192f851a5b0f0f75bd94e0893ba7;
    uint256 private constant ROUND_CONSTANT_45 = 0x069e790c2ed17de7147281661acdd1c26f2747341fd71902ed32c3f609f4f3af;
    uint256 private constant ROUND_CONSTANT_46 = 0x031a967141bafc0f72c5b1ce7b3c19e95c3de3c3367ceaaba96a693b021dd604;
    uint256 private constant ROUND_CONSTANT_47 = 0x1c8d18ccd39ffabfc8c003d93788cdd5380102085172a3e59ce8cb17ad57356d;
    uint256 private constant ROUND_CONSTANT_48 = 0x0673313e239f124bc67ab1789f2a347427666f8fc0ec8a743b111cd62fec029e;
    uint256 private constant ROUND_CONSTANT_49 = 0x2df362baa3fd9ac1fd15429171277ef6a7e7ae8dde3b1de777a0c32a8fab3f49;
    uint256 private constant ROUND_CONSTANT_50 = 0x02e91572a13a6baf97560b43b5b862aebd8b7d95c0fda9c097d823cc9ef0599e;
    uint256 private constant ROUND_CONSTANT_51 = 0x2bf9ecd92319e4025986d5cd2ed3effcd6c00eaf43ca16c447e19d7fd5c0287a;
    uint256 private constant ROUND_CONSTANT_52 = 0x0cdb3319efde2f036799a95bdc7a88b5bff5a6821d3c1a7a43123074c976d164;
    uint256 private constant ROUND_CONSTANT_53 = 0x14a7c33e18320dfc10c3e257084be8afbd93be3c5823e23028656362c42da24d;
    uint256 private constant ROUND_CONSTANT_54 = 0x071e9b286b28ce0c178a78cafa97746d5388a66474dc4f712c7f251380a8627f;
    uint256 private constant ROUND_CONSTANT_55 = 0x0b572fc5b1f7aff1772cfdfc23801a1c135f0fcdf1c8cdc0eef3ad8319286a34;
    uint256 private constant ROUND_CONSTANT_56 = 0x16eaaa27739d4e88d610264b2eab5a322a26448c7fd514659f433942c7b2bd31;
    uint256 private constant ROUND_CONSTANT_57 = 0x0a31c6ca07f6f5cbdc17a274ac22423a2f4dddebcadb176344b8d5bd8294caae;
    uint256 private constant ROUND_CONSTANT_58 = 0x1b2316dd0dcdea06516b84318b73d6fdba124bcde021332d083f051c3515cbac;
    uint256 private constant ROUND_CONSTANT_59 = 0x0567446d1a11219fe0001d5c256cf31be597300229c7484badbf5a317f72ed3a;
    uint256 private constant ROUND_CONSTANT_60 = 0x217b043aadd7058a7e9270dc0a2f571a8d1ccd116297b85823de86d173e54321;
    uint256 private constant ROUND_CONSTANT_61 = 0x1b309dc61b68e045cb56749ca700a989a3f5571a02c9928bebd1c38f14974d35;
    uint256 private constant ROUND_CONSTANT_62 = 0x00e6cd592bed61bb710147ec52ad3ebc32b4c2a76d02644cad6474371234d20e;
    uint256 private constant ROUND_CONSTANT_63 = 0x20784308ccc7096dcbbc21c6474e240690f32ad337128489d312de74a3a67750;
    uint256 private constant ROUND_CONSTANT_64 = 0x29e65ec685cbd4e7672031a51e24d20ff3e487e2ad44e7c0845d049720954c91;
    uint256 private constant ROUND_CONSTANT_65 = 0x241cc78290ec305ffea5e59e1b4f1010b37d10748c88c9d8d2b839c83c2aa7d7;
    uint256 private constant ROUND_CONSTANT_66 = 0x2b625e82f540d4603233baec3d48d81d9d855962b50771c6d5df82012044e896;
    uint256 private constant ROUND_CONSTANT_67 = 0x2aa2e7625f2a69e1312b69e3c1916b5241b8d15d01ecf836c9e23ba5e5112689;
    uint256 private constant ROUND_CONSTANT_68 = 0x0b25c5b3f1434174db4aac2308cf814db898c76592d736dc5b123f504449834c;
    uint256 private constant ROUND_CONSTANT_69 = 0x2a2c6d99e766d70342e7b42fbe06750440e27491c1518991b7674060e2616133;
    uint256 private constant ROUND_CONSTANT_70 = 0x06d8541da9b2e89a114783b790d91455bb0b97b2c7c72c146eb94005ee99a190;
    uint256 private constant ROUND_CONSTANT_71 = 0x2fa103b79cb395a311f6f370e5c9072ae45f9ecb8eb8114f071120eac381e07a;
    uint256 private constant ROUND_CONSTANT_72 = 0x1610f29cb8529fe921f804b7991fc8612ed5f42000311707497afa34a37ee7bc;
    uint256 private constant ROUND_CONSTANT_73 = 0x22b41463e67696e365cab4a5cb7d915680166d20e834b6f5190e8b43d77ec6c0;
    uint256 private constant ROUND_CONSTANT_74 = 0x24f1c646aa94730457d6ace633b53d35dc04afd438efaa3fad998f009bccaa83;
    uint256 private constant ROUND_CONSTANT_75 = 0x251b7fc58abd49fa61db45fe7a33248edd4a3b142d7a8c153553808a240c61b2;
    uint256 private constant ROUND_CONSTANT_76 = 0x2e3fc44847ad8cdde9c2bfeef503aa45bf6cf2e4544060b6c30a75f380df0f43;
    uint256 private constant ROUND_CONSTANT_77 = 0x176f35f05f9195318e6986e924057e359fac6a55a7386ddabc5a44de7f2af2f9;
    uint256 private constant ROUND_CONSTANT_78 = 0x27fffd50aeb4aeac31469860bb68f2673d176f334f084440b8d806534f1d4698;
    uint256 private constant ROUND_CONSTANT_79 = 0x0834cde6ce894997a0be7195401d5c70ff57706af3870d6fafca067b41ead81c;
    uint256 private constant ROUND_CONSTANT_80 = 0x0893359d7e7e1415d51d41fe73a19ac28beb829c5f8e37e6a6b2f03a813e359c;
    uint256 private constant ROUND_CONSTANT_81 = 0x0b8b5ec72a5dadc23809f1b651ffd183a04992fbea89f0810e44a64300206d9f;
    uint256 private constant ROUND_CONSTANT_82 = 0x12f3b4a9858f78ff154cca259573fad0a1c5f91deeaff4200f4ea58ffffd343a;
    uint256 private constant ROUND_CONSTANT_83 = 0x1d4bba151e87f7f4020d5a7ac14fab7458628acdbe04db4dd44faccdfb4abc1b;
    uint256 private constant ROUND_CONSTANT_84 = 0x03e57bdb6308a6978ec98fc09b8417be9390f30ea08406dee02a46352c020dca;
    uint256 private constant ROUND_CONSTANT_85 = 0x2407f1775e79704321acbff18234fd2ef12553f16dc3a1c6e95c1923a444556e;
    uint256 private constant ROUND_CONSTANT_86 = 0x18fc7233d851059576223ee5cde139640f3afd9b68d248bc8139cd2abee58a48;
    uint256 private constant ROUND_CONSTANT_87 = 0x07221d107bfedee39d35d32c22bf8572a1d710e5b011fe17c9cc97a6d2bc035b;
    uint256 private constant ROUND_CONSTANT_88 = 0x283dac184f689fb8c3357d7f3de0c1b7a49d04a8e41bb8e7d0fee67c3a6dc310;
    uint256 private constant ROUND_CONSTANT_89 = 0x0324b278afbdd2b4bd1083c8fc0d0c4958e101a5efb290b0b7889c99c16353df;
    uint256 private constant ROUND_CONSTANT_90 = 0x2ef035db5d4305163293830511cb03619565055e95b44737ab698fad03387fbf;
    uint256 private constant ROUND_CONSTANT_91 = 0x0ad024352c40ea93df089e7950a8ef31949ca31185ea5554e507f1f5b71a82a8;
    uint256 private constant ROUND_CONSTANT_92 = 0x0c5e0f2d7b20a482239232a434fb08bb7dd8d3d06ba100e1e15da83e6cfc180f;
    uint256 private constant ROUND_CONSTANT_93 = 0x2be76db496d8cc23e8c8b6f234d299826511059ee88d96092ced4b87d74db77c;
    uint256 private constant ROUND_CONSTANT_94 = 0x2d79aa7b5dc87a7387c7af51230172566ca6d68fa4ae9080e480638c7347b668;
    uint256 private constant ROUND_CONSTANT_95 = 0x1648f1ad57cc4501ffd57f070a1aed96f71b28ad010cef238d98c1685ee16231;
    uint256 private constant ROUND_CONSTANT_96 = 0x1ab2aa1ea50481246c3377b58b2b24844d24a97f8a91f9c9146702705382c9b3;
    uint256 private constant ROUND_CONSTANT_97 = 0x2575cd0ba00fc35d0b1d93a4f3aabcb702de3d7b25cf61d888c5d54f91acabd7;
    uint256 private constant ROUND_CONSTANT_98 = 0x03a5825985849b38f5094a1a64e87c6716786e23e9fa473e18d9dcca7b64eb13;
    uint256 private constant ROUND_CONSTANT_99 = 0x1a6fdd13f90e07d9eb965e5a953bd2cfde827d76db5de930bfde29dff65b5308;
    uint256 private constant ROUND_CONSTANT_100 = 0x033e80d52a890b969a4b8ce4dd2c00d537c303063fe21367a10335f7ed8d8cea;
    uint256 private constant ROUND_CONSTANT_101 = 0x24235b853d7f96de60d5159f4790f81382379f39ddd83a2ec502f73374291fca;
    uint256 private constant ROUND_CONSTANT_102 = 0x1077e4600b46ca1f09e8139232843fbb0d0edb67ede4cbe57355b1c9644cee47;
    uint256 private constant ROUND_CONSTANT_103 = 0x1320148c9943b3b3701622b1c1c73e278074d50bdfb92ef19bf7733e7d421ddf;
    uint256 private constant ROUND_CONSTANT_104 = 0x1a537e44312b40dbc7e06be6f227938532898e8e801ef318da21591743538f4b;
    uint256 private constant ROUND_CONSTANT_105 = 0x06618d39331c7490481e53ce344a645cc4a02dbf3dbbc830e937929ed6039c1f;
    uint256 private constant ROUND_CONSTANT_106 = 0x18234d7da8d9e5307c764d036b3c012a14aac97e29a51c31181171e4a3d0f522;
    uint256 private constant ROUND_CONSTANT_107 = 0x2c27a903142f943d127931af9e95285ad9f651d402f3f8ead8afc099bb9cc8ec;
    uint256 private constant ROUND_CONSTANT_108 = 0x2861fa55a4748fb329f5eb88472f710520be56f1db37b85c37e7054bae337189;
    uint256 private constant ROUND_CONSTANT_109 = 0x198472349c2119fccdaddd724f63f19fc713db81758a845fbcd972b9adadad1b;
    uint256 private constant ROUND_CONSTANT_110 = 0x2075888a58fb95ac51d3db00013c2b4cccb4ece51ac65594e7d31d81ae3a2262;

    // Matches gnark's encrypt function exactly
    function encrypt(uint256 m, uint256 h) internal pure returns (uint256) {
        uint256 tmp;
        uint256[] memory roundConstants = getRoundConstants();
        
        for(uint256 i = 0; i < MIMC_ROUNDS; i++) {
            // tmp = m + h + c
            tmp = addmod(addmod(m, h, FIELD_SIZE), roundConstants[i], FIELD_SIZE);
            
            // m = tmp^5
            m = mulmod(tmp, tmp, FIELD_SIZE);  // tmp^2
            m = mulmod(m, m, FIELD_SIZE);      // tmp^4
            m = mulmod(m, tmp, FIELD_SIZE);    // tmp^5
        }
        
        return addmod(m, h, FIELD_SIZE);
    }

    // Implements gnark's Miyaguchi-Preneel construction exactly
    function hash(uint256[] calldata data) public pure returns (uint256) {
        uint256 h = 0;
        
        // Match gnark's checksum implementation
        for (uint256 i = 0; i < data.length; i++) {
            uint256 r = encrypt(data[i], h);
            // h = encrypt(m, h) + h + m
            h = addmod(addmod(r, h, FIELD_SIZE), data[i], FIELD_SIZE);
        }
        
        return h;
    }

    // Getter function for round constants
    function getRoundConstants() internal pure returns (uint256[] memory const) {
        const = new uint256[](110);

        const[0] = ROUND_CONSTANT_1;
        const[1] = ROUND_CONSTANT_2;
        const[2] = ROUND_CONSTANT_3;
        const[3] = ROUND_CONSTANT_4;
        const[4] = ROUND_CONSTANT_5;
        const[5] = ROUND_CONSTANT_6;
        const[6] = ROUND_CONSTANT_7;
        const[7] = ROUND_CONSTANT_8;
        const[8] = ROUND_CONSTANT_9;
        const[9] = ROUND_CONSTANT_10;
        const[10] = ROUND_CONSTANT_11;
        const[11] = ROUND_CONSTANT_12;
        const[12] = ROUND_CONSTANT_13;
        const[13] = ROUND_CONSTANT_14;
        const[14] = ROUND_CONSTANT_15;
        const[15] = ROUND_CONSTANT_16;
        const[16] = ROUND_CONSTANT_17;
        const[17] = ROUND_CONSTANT_18;
        const[18] = ROUND_CONSTANT_19;
        const[19] = ROUND_CONSTANT_20;
        const[20] = ROUND_CONSTANT_21;
        const[21] = ROUND_CONSTANT_22;
        const[22] = ROUND_CONSTANT_23;
        const[23] = ROUND_CONSTANT_24;
        const[24] = ROUND_CONSTANT_25;
        const[25] = ROUND_CONSTANT_26;
        const[26] = ROUND_CONSTANT_27;
        const[27] = ROUND_CONSTANT_28;
        const[28] = ROUND_CONSTANT_29;
        const[29] = ROUND_CONSTANT_30;
        const[30] = ROUND_CONSTANT_31;
        const[31] = ROUND_CONSTANT_32;
        const[32] = ROUND_CONSTANT_33;
        const[33] = ROUND_CONSTANT_34;
        const[34] = ROUND_CONSTANT_35;
        const[35] = ROUND_CONSTANT_36;
        const[36] = ROUND_CONSTANT_37;
        const[37] = ROUND_CONSTANT_38;
        const[38] = ROUND_CONSTANT_39;
        const[39] = ROUND_CONSTANT_40;
        const[40] = ROUND_CONSTANT_41;
        const[41] = ROUND_CONSTANT_42;
        const[42] = ROUND_CONSTANT_43;
        const[43] = ROUND_CONSTANT_44;
        const[44] = ROUND_CONSTANT_45;
        const[45] = ROUND_CONSTANT_46;
        const[46] = ROUND_CONSTANT_47;
        const[47] = ROUND_CONSTANT_48;
        const[48] = ROUND_CONSTANT_49;
        const[49] = ROUND_CONSTANT_50;
        const[50] = ROUND_CONSTANT_51;
        const[51] = ROUND_CONSTANT_52;
        const[52] = ROUND_CONSTANT_53;
        const[53] = ROUND_CONSTANT_54;
        const[54] = ROUND_CONSTANT_55;
        const[55] = ROUND_CONSTANT_56;
        const[56] = ROUND_CONSTANT_57;
        const[57] = ROUND_CONSTANT_58;
        const[58] = ROUND_CONSTANT_59;
        const[59] = ROUND_CONSTANT_60;
        const[60] = ROUND_CONSTANT_61;
        const[61] = ROUND_CONSTANT_62;
        const[62] = ROUND_CONSTANT_63;
        const[63] = ROUND_CONSTANT_64;
        const[64] = ROUND_CONSTANT_65;
        const[65] = ROUND_CONSTANT_66;
        const[66] = ROUND_CONSTANT_67;
        const[67] = ROUND_CONSTANT_68;
        const[68] = ROUND_CONSTANT_69;
        const[69] = ROUND_CONSTANT_70;
        const[70] = ROUND_CONSTANT_71;
        const[71] = ROUND_CONSTANT_72;
        const[72] = ROUND_CONSTANT_73;
        const[73] = ROUND_CONSTANT_74;
        const[74] = ROUND_CONSTANT_75;
        const[75] = ROUND_CONSTANT_76;
        const[76] = ROUND_CONSTANT_77;
        const[77] = ROUND_CONSTANT_78;
        const[78] = ROUND_CONSTANT_79;
        const[79] = ROUND_CONSTANT_80;
        const[80] = ROUND_CONSTANT_81;
        const[81] = ROUND_CONSTANT_82;
        const[82] = ROUND_CONSTANT_83;
        const[83] = ROUND_CONSTANT_84;
        const[84] = ROUND_CONSTANT_85;
        const[85] = ROUND_CONSTANT_86;
        const[86] = ROUND_CONSTANT_87;
        const[87] = ROUND_CONSTANT_88;
        const[88] = ROUND_CONSTANT_89;
        const[89] = ROUND_CONSTANT_90;
        const[90] = ROUND_CONSTANT_91;
        const[91] = ROUND_CONSTANT_92;
        const[92] = ROUND_CONSTANT_93;
        const[93] = ROUND_CONSTANT_94;
        const[94] = ROUND_CONSTANT_95;
        const[95] = ROUND_CONSTANT_96;
        const[96] = ROUND_CONSTANT_97;
        const[97] = ROUND_CONSTANT_98;
        const[98] = ROUND_CONSTANT_99;
        const[99] = ROUND_CONSTANT_100;
        const[100] = ROUND_CONSTANT_101;
        const[101] = ROUND_CONSTANT_102;
        const[102] = ROUND_CONSTANT_103;
        const[103] = ROUND_CONSTANT_104;
        const[104] = ROUND_CONSTANT_105;
        const[105] = ROUND_CONSTANT_106;
        const[106] = ROUND_CONSTANT_107;
        const[107] = ROUND_CONSTANT_108;
        const[108] = ROUND_CONSTANT_109;
        const[109] = ROUND_CONSTANT_110;

        return const;
    }
}