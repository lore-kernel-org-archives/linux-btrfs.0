Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724CEC65C31
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0336A2088F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGJZJqUD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0336A2088F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbeJGNRC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 09:17:02 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:35320 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbeJGNRB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 09:17:01 -0400
Received: by mail-qt1-f178.google.com with SMTP id v19-v6so18008321qtg.2
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Oct 2018 23:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wvvAS32Gj6uPgSo/UnwmENLtTLjA4NhhEHCKpYo78Ug=;
        b=lGJZJqUDfVXKGxweolYSE41HhFbtgGO09GkMrimurJC+/kdOPhQwBKITsMjgyWrRlZ
         UbZDXE9qgPeKJPOp9X2X7ud9dH05MKAhfuJg5GGpLQqrTnfUQqGN0Z+ebHakulcyyCgu
         CELJknN8Sv0zQvXfQrMWTwGNv2I5aMubKQJFzaaIQw1CNjqdSX1DcSBXOFaN+NosUvuy
         p4zGXa9IS69CcX+Rcou3MMAeJ1K2JnBpANXDqlySjplNpFjys3twb0W4ZXLyGgtKsl7q
         BUOYilaIIXiBr6eaH2paD9DUPvNDrpzoYU4hYkJKWgR21b1oZM+iChDFanyKCiCYmhkE
         HB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvvAS32Gj6uPgSo/UnwmENLtTLjA4NhhEHCKpYo78Ug=;
        b=ZQmJxLhJuSHVFoUeqSreazyWljLrTIeNBhjOrcw3miM0YBAV9e3vOENSHvog906NKN
         Bf/gGvm8h811YPMIpL6lMK6ghrzfucSaC6TGl2GUaDv4ASKtQTuo6Mkqk6OGGxsz0GGh
         YKiykSTbSQixDxpBoOvTq6Qbwr+jhg3ciaF929n3BrKrXlDiHOjGtT5+M685kDgHXv6A
         wqgMZH5wc2YOto5Fr+SKIHQw28ouUeKJxUqwQIZuKAZ+IaVAjNPxUp/Mqq+jwdTOtoCr
         LruFIRFXhe2K1dly+WbvC2HfkOeMJhxFBEyTBc8nni5uu6CsBVJiXpmRgtxtZW/cruSp
         KIzA==
X-Gm-Message-State: ABuFfohlOI+51hebQ7yGCoYMiotJMlaMqGI7c3MnkKJsSb2V81Kz40oe
        WbtoBkzaCKlAsidVe/5tssam+XikfaTzu1Z24GaYH8ZV
X-Google-Smtp-Source: ACcGV63gs7jt1szLp8IIp1ZqqYu/LmdFDNS+HdWyz/BXYFHniL/l5pq6ICFz+AeMgNRr7YcDTXBTlcmANpi5jZDqRpA=
X-Received: by 2002:a0c:87ba:: with SMTP id 55-v6mr14857346qvj.202.1538892649371;
 Sat, 06 Oct 2018 23:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
In-Reply-To: <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 08:10:38 +0200
Message-ID: <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Please try "btrfs ins dump-super -fFa" on these two disks.
>
> If it's only the primary superblock corrupted, the backup should be good.
>
> If backup is also corrupted, either it has some offset or the whole data
> is corrupted.

# btrfs ins dump-super -fFa /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum_type 0 (crc32c)
csum_size 4
csum 0x00000000 [DON'T MATCH]
bytenr 0
flags 0x0
magic ........ [DON'T MATCH]
fsid 00000000-0000-0000-0000-000000000000
label
generation 0
root 0
sys_array_size 0
chunk_root_generation 0
root_level 0
chunk_root 0
chunk_root_level 0
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 0
bytes_used 0
sectorsize 0
nodesize 0
leafsize (deprecated) 0
stripesize 0
root_dir 0
num_devices 0
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x0
cache_generation 0
uuid_tree_generation 0
dev_item.uuid 00000000-0000-0000-0000-000000000000
dev_item.fsid 00000000-0000-0000-0000-000000000000 [match]
dev_item.type 0
dev_item.total_bytes 0
dev_item.bytes_used 0
dev_item.io_align 0
dev_item.io_width 0
dev_item.sector_size 0
dev_item.devid 0
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0
sys_chunk_array[2048]:
backup_roots[4]:

superblock: bytenr=67108864, device=/dev/sdb
---------------------------------------------------------
csum_type 29777 (INVALID)
csum_size 32
csum 0xdfa25558dc616d7f36b287aa0081da91b78ec4910ba082b8d807708dcf608c91
[UNKNOWN CSUM TYPE OR SIZE]
bytenr 18068171547813619898
flags 0xbaca4264c914fdc
( METADUMP |
  METADUMP_V2 |
  unknown flag: 0xbaca4204c914fdc )
magic Y...FE./ [DON'T MATCH]
fsid 870d0bb4-65de-453b-2592-88b2cda7c38b
label >.<...@...B%...<.N..S.*.>....^.p.x.v..o..<).u..B}./...B..3:8..&}-....k...o6..Y......R..'o..G.lG.-...$....'S!.....h.-...".*.S..xf..@d...W..*..w..V.)..q..|.....p....gt.L...z.....i...(..3Ar...;B.j.]:I.X...=x.(....u.<..2U......0
.n..^....}...^..Y.a#.X...G..d..
generation 2272432616352171010
root 6354703493070726827
sys_array_size 2955003080
chunk_root_generation 6888771666932949452
root_level 123
chunk_root 1494381076279922822
chunk_root_level 127
log_root 2134514170013133221
log_root_transid 9424889336279151653
log_root_level 153
total_bytes 2681859058010843869
bytes_used 16135710043447639801
sectorsize 1588161000
nodesize 3303803296
leafsize (deprecated) 1829755703
stripesize 606246139
root_dir 1342036912498050847
num_devices 17153780124435501376
compat_flags 0xf49b2c3a96602d1e
compat_ro_flags 0x8bec2f0d81d2ef13
( FREE_SPACE_TREE |
  FREE_SPACE_TREE_VALID |
  unknown flag: 0x8bec2f0d81d2ef10 )
incompat_flags 0x1af3f95d789a706e
( DEFAULT_SUBVOL |
  MIXED_GROUPS |
  COMPRESS_LZO |
  BIG_METADATA |
  EXTENDED_IREF |
  unknown flag: 0x1af3f95d789a7000 )
cache_generation 7331553946468888473
uuid_tree_generation 6538806993670512709
dev_item.uuid c1494bde-9546-5ef1-5d08-e259707d06d3
dev_item.fsid 584a42f5-4f79-58cc-3f5e-bdd9733b94d3 [DON'T MATCH]
dev_item.type 15668929679594826040
dev_item.total_bytes 1644623768791993611
dev_item.bytes_used 13437937382560806996
dev_item.io_align 449600477
dev_item.io_width 3390996026
dev_item.sector_size 2580293710
dev_item.devid 8727228223548828735
dev_item.dev_group 3143108434
dev_item.seek_speed 99
dev_item.bandwidth 34
dev_item.generation 15553054142077970558
sys_chunk_array[2048]:
ERROR: sys_array_size 2955003080 shouldn't exceed 2048 bytes
backup_roots[4]:
backup 0:
backup_tree_root: 15696464816120474628 gen: 16022257131800929882 level: 86
backup_chunk_root: 301766055038840723 gen: 16810756911197712753 level: 114
backup_extent_root: 6651488794176833875 gen: 10776594467847637718 level: 60
backup_fs_root: 1826104903792017114 gen: 3329223824114931446 level: 159
backup_dev_root: 11721506207622158585 gen: 10455859429120851009 level: 198
backup_csum_root: 5686172936498246011 gen: 5319088827707453088 level: 168
backup_total_bytes: 7660601670332883006
backup_bytes_used: 3723313713264611767
backup_num_devices: 1913069816786984281

backup 1:
backup_tree_root: 9129110729577497674 gen: 17870813394716935947 level: 45
backup_chunk_root: 3169491491968745044 gen: 17348548561480407615 level: 93
backup_extent_root: 5781159137873655776 gen: 3348348558872496210 level: 123
backup_fs_root: 66326293521237128 gen: 16098559310782853786 level: 157
backup_dev_root: 10010186234695580749 gen: 5427645709246451749 level: 214
backup_csum_root: 3481616510852897026 gen: 3557794445033232028 level: 233
backup_total_bytes: 14437518517144737363
backup_bytes_used: 17463569409584801738
backup_num_devices: 3997309709667846939

backup 2:
backup_tree_root: 10726132636215357139 gen: 12411364641008183307 level: 88
backup_chunk_root: 15701704192942804973 gen: 12075216484835399161 level: 115
backup_extent_root: 2480766121519302854 gen: 14058965640461957484 level: 149
backup_fs_root: 9763730962528489871 gen: 7584542795525942005 level: 178
backup_dev_root: 11165845436133270817 gen: 13967062440412348994 level: 236
backup_csum_root: 6171896748396285651 gen: 15789968436991761178 level: 134
backup_total_bytes: 852992822326609651
backup_bytes_used: 9456838616667273636
backup_num_devices: 258078273996705168

backup 3:
backup_tree_root: 8916407610526786835 gen: 544250966375700228 level: 247
backup_chunk_root: 1936178119870923695 gen: 13788929947546158339 level: 23
backup_extent_root: 13736240713036447135 gen: 9136609651832631643 level: 228
backup_fs_root: 9379639176768519619 gen: 6320915863532846421 level: 20
backup_dev_root: 12781643626490830997 gen: 15705869514480526772 level: 211
backup_csum_root: 17487652342378081351 gen: 12310100655386894381 level: 228
backup_total_bytes: 14178401375165794506
backup_bytes_used: 2960932618284081911
backup_num_devices: 732916398995047671


superblock: bytenr=274877906944, device=/dev/sdb
---------------------------------------------------------
csum_type 26294 (INVALID)
csum_size 32
csum 0x05401fa3a3e8cd64075ce9fdbb9e60a01d58061a3cff3bc0235d18912ab755a2
[UNKNOWN CSUM TYPE OR SIZE]
bytenr 7401042280310172376
flags 0x5a8a759265673a05
( WRITTEN |
  METADUMP |
  unknown flag: 0x5a8a759065673a04 )
magic .~...6.. [DON'T MATCH]
fsid 58ac9547-7cc1-0d72-72a4-d170183f5354
label ...o....+,s....2..p.%...M...b5.\...]r.W.{T..E>.v...-.Uo..=q......R...N`.T..Qg."ZX...<.=].....VI..........0F8X0a.O..wO.5...'.d.qx.;..!4\6$F.....L.].\.^j.a?.9N>.0.S......V....e.......u.d
generation 13633699985737464622
root 18288883272426202325
sys_array_size 537058648
chunk_root_generation 15502892951231246593
root_level 123
chunk_root 14862375894706771220
chunk_root_level 50
log_root 18217816676908993917
log_root_transid 13292731453533024088
log_root_level 182
total_bytes 604020162755692775
bytes_used 8671054025474794724
sectorsize 2343214981
nodesize 4080824269
leafsize (deprecated) 2589873276
stripesize 1608254910
root_dir 4175551868777471992
num_devices 11292521617443589330
compat_flags 0x51bd4965b8f8f378
compat_ro_flags 0xcd11a0d761bc8560
( unknown flag: 0xcd11a0d761bc8560 )
incompat_flags 0x31e963e57aa48fd3
( MIXED_BACKREF |
  DEFAULT_SUBVOL |
  COMPRESS_ZSTD |
  EXTENDED_IREF |
  RAID56 |
  SKINNY_METADATA |
  NO_HOLES |
  unknown flag: 0x31e963e57aa48c00 )
cache_generation 4395702763222870276
uuid_tree_generation 8934509307422929819
dev_item.uuid 13c82728-be37-9adf-aff7-b0fa7efd8231
dev_item.fsid 2dab55d1-d7ae-56d0-587c-b820f858bd05 [DON'T MATCH]
dev_item.type 18031144698251568983
dev_item.total_bytes 7751114143563703425
dev_item.bytes_used 13476199618973026775
dev_item.io_align 2057808323
dev_item.io_width 3149801420
dev_item.sector_size 247150945
dev_item.devid 15839663437645226588
dev_item.dev_group 2994832036
dev_item.seek_speed 117
dev_item.bandwidth 86
dev_item.generation 2645180553656112175
sys_chunk_array[2048]:
ERROR: sys_array_size 537058648 shouldn't exceed 2048 bytes
backup_roots[4]:
backup 0:
backup_tree_root: 16761898975961973385 gen: 10558433961112808482 level: 34
backup_chunk_root: 4634901786878154049 gen: 2789892382072352465 level: 103
backup_extent_root: 15990851370206767598 gen: 767691729182119747 level: 7
backup_fs_root: 13448936033627111692 gen: 5010096877512870199 level: 12
backup_dev_root: 10254427244969935892 gen: 6772364856024015332 level: 79
backup_csum_root: 18222708058546106396 gen: 617412657138877713 level: 181
backup_total_bytes: 6646051390792386687
backup_bytes_used: 15789948112634279402
backup_num_devices: 11160134415262687511

backup 1:
backup_tree_root: 14080884419227751044 gen: 11777694659597529284 level: 172
backup_chunk_root: 6689242937547775800 gen: 8904924292493474007 level: 204
backup_extent_root: 12919008629751267646 gen: 5418581814871164819 level: 71
backup_fs_root: 15023074867312729476 gen: 9546689845696271752 level: 218
backup_dev_root: 5975020661619990271 gen: 1677353861529605970 level: 37
backup_csum_root: 15240315213437574713 gen: 794688816849715247 level: 120
backup_total_bytes: 6404601066589802996
backup_bytes_used: 11600557070461724556
backup_num_devices: 3528258677900416801

backup 2:
backup_tree_root: 15902465410760765390 gen: 9244858492648458899 level: 60
backup_chunk_root: 10979555776380096061 gen: 13518427102757078280 level: 1
backup_extent_root: 8318515904263648530 gen: 14921468548345907606 level: 158
backup_fs_root: 8546016063523207409 gen: 7146170403198912805 level: 153
backup_dev_root: 14810109877232288932 gen: 13642291145924800733 level: 153
backup_csum_root: 3276675713516860969 gen: 9559198456908426058 level: 226
backup_total_bytes: 17624564276345165463
backup_bytes_used: 6823948331842432937
backup_num_devices: 12915309987769128006

backup 3:
backup_tree_root: 5901049822719343474 gen: 18243677952829216985 level: 53
backup_chunk_root: 8486075584643754953 gen: 6219983747191859076 level: 2
backup_extent_root: 11718012280502772822 gen: 3306912493466436244 level: 43
backup_fs_root: 1872193219652465606 gen: 11136298472660222066 level: 130
backup_dev_root: 5210015126355614920 gen: 8909004638207039403 level: 39
backup_csum_root: 1940581228003433780 gen: 2234522998189547626 level: 193
backup_total_bytes: 1106464655357172896
backup_bytes_used: 3823106945480009319
backup_num_devices: 16300100036548467022

-----------------------------------------------------------------------

# btrfs ins dump-super -fFa /dev/sdc
superblock: bytenr=65536, device=/dev/sdc
---------------------------------------------------------
csum_type 0 (crc32c)
csum_size 4
csum 0x00000000 [DON'T MATCH]
bytenr 0
flags 0x0
magic ........ [DON'T MATCH]
fsid 00000000-0000-0000-0000-000000000000
label
generation 0
root 0
sys_array_size 0
chunk_root_generation 0
root_level 0
chunk_root 0
chunk_root_level 0
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 0
bytes_used 0
sectorsize 0
nodesize 0
leafsize (deprecated) 0
stripesize 0
root_dir 0
num_devices 0
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x0
cache_generation 0
uuid_tree_generation 0
dev_item.uuid 00000000-0000-0000-0000-000000000000
dev_item.fsid 00000000-0000-0000-0000-000000000000 [match]
dev_item.type 0
dev_item.total_bytes 0
dev_item.bytes_used 0
dev_item.io_align 0
dev_item.io_width 0
dev_item.sector_size 0
dev_item.devid 0
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0
sys_chunk_array[2048]:
backup_roots[4]:

superblock: bytenr=67108864, device=/dev/sdc
---------------------------------------------------------
csum_type 34333 (INVALID)
csum_size 32
csum 0xab15f0feee48ecf28b8c99b755aa3a064df191c9a1be02600fac1ea9c381f14e
[UNKNOWN CSUM TYPE OR SIZE]
bytenr 8633413983586766992
flags 0x92e726a6c4c27c9f
( WRITTEN |
  RELOC |
  METADUMP |
  METADUMP_V2 |
  unknown flag: 0x92e726a0c4c27c9c )
magic Q....zkk [DON'T MATCH]
fsid 7cebdfa9-8c48-ff45-c055-0bc1e319b0a0
label ..uJ5(u.?.)...j..e.4I.k......
generation 1462467105366385225
root 12970296241716907486
sys_array_size 3683155114
chunk_root_generation 16887042483156010262
root_level 181
chunk_root 1494441143489202721
chunk_root_level 131
log_root 3198313967417660763
log_root_transid 17115557025995021404
log_root_level 71
total_bytes 14129002793310684784
bytes_used 15111364794877521867
sectorsize 511026926
nodesize 3028809837
leafsize (deprecated) 2996627562
stripesize 658285859
root_dir 3731764775969430043
num_devices 2973668267315632962
compat_flags 0x1f43bb525cca7df7
compat_ro_flags 0x4285bb33e58508e
( FREE_SPACE_TREE_VALID |
  unknown flag: 0x4285bb33e58508c )
incompat_flags 0xf1ed3d730769fa85
( MIXED_BACKREF |
  MIXED_GROUPS |
  RAID56 |
  NO_HOLES |
  unknown flag: 0xf1ed3d730769f800 )
cache_generation 6615652487388674653
uuid_tree_generation 10649045514159614267
dev_item.uuid dd816791-5475-407c-9b06-ac9d7dc2d8fc
dev_item.fsid 887c0052-9737-7c4d-9ae4-e1e8e0987e27 [DON'T MATCH]
dev_item.type 15695375930593417017
dev_item.total_bytes 13324569925537380461
dev_item.bytes_used 1507442960832394956
dev_item.io_align 427152731
dev_item.io_width 3502596089
dev_item.sector_size 3344717708
dev_item.devid 6595375788997338785
dev_item.dev_group 3555555424
dev_item.seek_speed 120
dev_item.bandwidth 48
dev_item.generation 3117391594456070532
sys_chunk_array[2048]:
ERROR: sys_array_size 3683155114 shouldn't exceed 2048 bytes
backup_roots[4]:
backup 0:
backup_tree_root: 17565078465776725312 gen: 15130251661058939744 level: 190
backup_chunk_root: 13679788444858559115 gen: 17736819807929381547 level: 226
backup_extent_root: 6756067347371838835 gen: 4553921493461228561 level: 8
backup_fs_root: 7866259983563917998 gen: 11868179349484141539 level: 92
backup_dev_root: 4545361592282121939 gen: 6352642615573440863 level: 230
backup_csum_root: 10114788038344030171 gen: 15384393779986101426 level: 156
backup_total_bytes: 11088048233267625740
backup_bytes_used: 9538203816043857436
backup_num_devices: 13380888746215600774

backup 1:
backup_tree_root: 10742171863500348064 gen: 9709686785972574248 level: 209
backup_chunk_root: 13845135692636155450 gen: 10619103856556655716 level: 191
backup_extent_root: 2237217864161787661 gen: 6243912137065072157 level: 204
backup_fs_root: 10179453249699741406 gen: 12296627743427106187 level: 18
backup_dev_root: 4039516741664845044 gen: 8940615886797811609 level: 254
backup_csum_root: 10961724823019101672 gen: 7389732407521693141 level: 61
backup_total_bytes: 3660405285821206758
backup_bytes_used: 14184963965334578332
backup_num_devices: 3331460568287782084

backup 2:
backup_tree_root: 770700760417716059 gen: 8388027914279808891 level: 113
backup_chunk_root: 13569584946352292025 gen: 5517304645941681846 level: 255
backup_extent_root: 2251138094170630310 gen: 14614996599541187233 level: 243
backup_fs_root: 9814387157933473114 gen: 15331439954464538751 level: 139
backup_dev_root: 10100339900687890625 gen: 4950417503146664170 level: 154
backup_csum_root: 6159399237355569051 gen: 4888943391696402664 level: 190
backup_total_bytes: 17989679569386256737
backup_bytes_used: 17603043069188619986
backup_num_devices: 11882194400011889826

backup 3:
backup_tree_root: 11909858444902455031 gen: 2055919935482364584 level: 218
backup_chunk_root: 764997422297817259 gen: 12047666587495465437 level: 152
backup_extent_root: 4302824747655729868 gen: 2000694038411056771 level: 130
backup_fs_root: 17376983502997538456 gen: 15795673477170452105 level: 8
backup_dev_root: 9498648306884603007 gen: 16335540667562306150 level: 55
backup_csum_root: 17559784773274850560 gen: 16446467839408725910 level: 19
backup_total_bytes: 5487649076532635489
backup_bytes_used: 1205365872171297006
backup_num_devices: 9128723400536577417


superblock: bytenr=274877906944, device=/dev/sdc
---------------------------------------------------------
csum_type 47554 (INVALID)
csum_size 32
csum 0x541052a55a1c2ddaf90aff444ce89571200e82fc49ad476bbaa75260a4a4d0ca
[UNKNOWN CSUM TYPE OR SIZE]
bytenr 725699426701493013
flags 0x214a46b2fa2f5218
( METADUMP |
  unknown flag: 0x214a46b0fa2f5218 )
magic .l.B.[.. [DON'T MATCH]
fsid 21ef660b-95da-ef3d-ee33-fab8db4a77da
label ...-.f.-.#.......\...U.%d..g..y....D.bI...!..........Q3.{...f...H1.[...gF.P.N.....tb....I....]...J.:.y?OC...j.........
a.2..R.;...~..}...I..ZkMUE.......[2.y....&.z.y\..wn%H..V.I-.rDL..FB.N.&......~.]..4U;..d.1........r{lc.M.u.g.....$.X..._....P*+.$..;d....
generation 7920913447830932522
root 2022721474399355307
sys_array_size 3372953409
chunk_root_generation 10097987123791087119
root_level 68
chunk_root 5468837660012789091
chunk_root_level 168
log_root 2583210597878745906
log_root_transid 9861947962494653893
log_root_level 227
total_bytes 14311427532890320964
bytes_used 5499248012605730795
sectorsize 3769334282
nodesize 731170869
leafsize (deprecated) 2849742608
stripesize 3909982636
root_dir 446564989666558392
num_devices 16326229407972446369
compat_flags 0xa9e31b82597f906d
compat_ro_flags 0x7eedf12888be221a
( FREE_SPACE_TREE_VALID |
  unknown flag: 0x7eedf12888be2218 )
incompat_flags 0xdaa5fb08891101a7
( MIXED_BACKREF |
  DEFAULT_SUBVOL |
  MIXED_GROUPS |
  BIG_METADATA |
  RAID56 |
  SKINNY_METADATA |
  unknown flag: 0xdaa5fb0889110000 )
cache_generation 9660688112699095389
uuid_tree_generation 6449937315995911103
dev_item.uuid 5fffab99-c830-9148-ae99-2f7a64f64b59
dev_item.fsid bd5258a4-4678-32f1-e0db-dfd3828daa64 [DON'T MATCH]
dev_item.type 11267346882775593463
dev_item.total_bytes 4212847697383062560
dev_item.bytes_used 18092958380183270961
dev_item.io_align 3365530434
dev_item.io_width 2190234727
dev_item.sector_size 2183880601
dev_item.devid 7585256997551989802
dev_item.dev_group 2191500937
dev_item.seek_speed 248
dev_item.bandwidth 207
dev_item.generation 11174405559490900438
sys_chunk_array[2048]:
ERROR: sys_array_size 3372953409 shouldn't exceed 2048 bytes
backup_roots[4]:
backup 0:
backup_tree_root: 12135334221305554845 gen: 15894342622290853588 level: 190
backup_chunk_root: 13493509588194091780 gen: 11545802536567785598 level: 118
backup_extent_root: 9062952190439147193 gen: 8846280736252228984 level: 21
backup_fs_root: 13921706823046697654 gen: 528499158515528040 level: 217
backup_dev_root: 1821003510795307538 gen: 17133119724523804236 level: 91
backup_csum_root: 14045906134499734139 gen: 16896692969681070977 level: 170
backup_total_bytes: 158682317374891585
backup_bytes_used: 12297171789990416523
backup_num_devices: 652764446323531711

backup 1:
backup_tree_root: 16833744060996233284 gen: 9900930740303553967 level: 242
backup_chunk_root: 6154841345198724630 gen: 13523671503832376565 level: 93
backup_extent_root: 459120287906601910 gen: 3704813002331499463 level: 254
backup_fs_root: 16420833026123586180 gen: 7721504441243943710 level: 163
backup_dev_root: 7941489184553068469 gen: 16600095204134340756 level: 117
backup_csum_root: 6579669820294033057 gen: 7830423395678916952 level: 99
backup_total_bytes: 2392077325755124274
backup_bytes_used: 15652090788221162985
backup_num_devices: 5503497027654595601

backup 2:
backup_tree_root: 4138489268924930038 gen: 2553937734946237298 level: 187
backup_chunk_root: 763605228638723084 gen: 10755231533435149440 level: 235
backup_extent_root: 10700753787304320373 gen: 11686363008677407621 level: 131
backup_fs_root: 2623068414736957584 gen: 5921250119645386332 level: 39
backup_dev_root: 8258423872719262597 gen: 15788746881630554774 level: 21
backup_csum_root: 14877725698862393787 gen: 14014163427231231829 level: 126
backup_total_bytes: 1604790320860766553
backup_bytes_used: 16375787117869992070
backup_num_devices: 13472568300188916317

backup 3:
backup_tree_root: 10881793116033863650 gen: 6194877904113531746 level: 114
backup_chunk_root: 5706748501273752509 gen: 2395078807671134967 level: 165
backup_extent_root: 16230028579539574650 gen: 12299255994704014216 level: 146
backup_fs_root: 15564012667129677409 gen: 13679497015882780830 level: 101
backup_dev_root: 14346962825574123849 gen: 10392679650475219476 level: 202
backup_csum_root: 9074164714682270895 gen: 15119687225321378499 level: 221
backup_total_bytes: 15613112091153675333
backup_bytes_used: 10922680836366561738
backup_num_devices: 9573610530134731857
