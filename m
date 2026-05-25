Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971CA28E0
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 22:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779749149; cv=pass; b=hbESlZxoune4iQwM2XcqTegGolfAVht50OyYISCfk7lEj2X9u2+fvYCZyOvK8ZqThO3I2OVXiAhIv59bwCVHyHzp4vnK0OcbYdB0J4iBuichlMXxmK1d3Tdcg+h6OH4UXtaTho/vHGX/lojDS9tGzVQi30EyOMEpVNts9pHr+CE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779749149; c=relaxed/simple;
	bh=lAXXpjLJ3yqnTCtGrAyAc+cz+ob6PB5izKhDA1Si5GE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=G57WSiSA2YXk+fsmLTCZAr3wRdM5IOekgIHtHp3H8mRvg9ga6rUu1IdiWNaxYpuI+W6nnIq6vFvXgQvA7Ua1mIGNP4QPw1Q2EZCF/rtbi8uRCsrtbIWwnAoz3SeidXxDRcCam2bnjdfwSN6XmMLdYrUXlmC8THJuXgrvkYtourI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCF6fMgX; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCF6fMgX"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7d764f57022so11694747b3.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 15:45:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779749146; cv=none;
        d=google.com; s=arc-20240605;
        b=CkqUBDocqcXY0VhbV0cf5Os/f7mLeM0Ku0dM2nN1rnrdT3EMFZqZnLK960mczPrrIp
         ZKrcdPseua3tpmhbmxDIspPi4tQ/rPUt+i5+E+ss1hO3hl2WbHigE46tcpCC81u0l+kO
         mDuruvMc/XdgwJpxQ94J2qNL0sVqbwk+iBbeBpHo4eG3ggx0JTbCiKxr4IBdAzQQMZAL
         XjyXMpVyFXb3Pa4B+qRmgm9O9EOvWQSJJ6tHpgvc+6W4dpy1z63xGYn2u5WNbnVVO0ip
         LLFeMa270yOmoG3QNaoYKFpmhg72tpznKVtvUkSnU0WJHPX5rysqE8aV46SICcH6zc1o
         4lpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=4vT1YqjAa6rh4wxkOkmZ6Hem7ouQvjF/NbBLHmmE5CE=;
        fh=vyMSR/IIVLdL7fV3AnXjSQ9QWW5zciCkaSnVMFFIUcs=;
        b=IUPbH1TI7IxHIAgoVTDsdSxYQ+wkSbtULXnfkgeEcC0naOwdjt2dqa10biagtTemG+
         wjXKKufUWRGKqZtexntRWz62+kzxUoYfjL6vHEqN3gcG6Tse6/GL+w6zzT9DQv4lmXsU
         PNeKTfKLJrCgj7kcvhthr/QUA0bv0teR+F6ZanucSwq6FgYv5rdD8+MXd6vvYM/jEAEa
         rZh+0t8DH3PnJJOSR6LqL/WLVJymEbSlplgjSbVQUgpvQFTi1Mobq8IBpfpz82C8Ujgh
         hr0XknEFJ04Lqy76kvWCDXMxrOH8fTDVtw6PX/DYVAGJoDT2hWG/37Z2NeS5v4VNqNvP
         oMTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779749146; x=1780353946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4vT1YqjAa6rh4wxkOkmZ6Hem7ouQvjF/NbBLHmmE5CE=;
        b=DCF6fMgXapQLgNOe497tTJ3EBtCD3TmzwsyE3HKERYWOneEeoC8SxXhzpsOXn8/i4e
         /VpeMDqgF5acFlUOD0rp6fH2QpPcllTOeNN1B5zbIhjg+hPMyd7xSr9oSm6EIBbWGWsx
         dGkK8WrSVBdWLglg5UWLTVwPvY70FBejgBCbPCUoUsw13n3sXk5yTg3DvyhtlSkWQ+Xl
         1rsY8b/NohtspupQ/Sybwtn3UAW7RHkLqztScuv5dD4WOeggH/TlMNF53CLzAtKN4h+4
         hETQGV6xK3+fODCuOAQkB2MYo3TpGGvhOA3flZRul1CxXv2xsqWXH3A0jQqoUtvGLeMC
         NEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779749146; x=1780353946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vT1YqjAa6rh4wxkOkmZ6Hem7ouQvjF/NbBLHmmE5CE=;
        b=VzmmmmQy83emIuV4VF7csgPWqYYAYiCi2xAk175orvc/8esEG75DwG/VCNhd50aGsE
         aEGgqmh8isbZiXDsDr6zNq5I53dlxKNM4MzdaHpmDx4dHjSTqc/dYNP950MPmhgOFeae
         TMLjk/4c/2TkPf/nBGEraZ2NY9lL2fhXmNF3weamFx1Dx+qnOWv8p1Z7LV+7lds/mENo
         iEfJWbjs7aj4OJ6YaphYOT0UMtQRtggIkJiIve1vPqUp2qfomOrXAao3CdhFr8TRzVru
         AalivNd+WKtniAdtcsNN6YSsA5jX9r3w8OlEo0DHmHrW65KEuAcu53GbSweO46V9WUMp
         wtAg==
X-Forwarded-Encrypted: i=1; AFNElJ/zVGg1IMYBhMA413j7RLPP+mIWarRNmAtqGuD8dRhWWWwsKEVf1BiyltjJkUo74vUgmh3lMIFaFhs8CA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkRVTgUHCgujbqFSwZuI8G/eCma0P60Q87yBkTrjeUkDJsdSAw
	y1YJxP2fknSSNsPy5LuFxX4DQ6s6x5v/GT80UQHmn9ABmVZ8qch1Wju3avFn/JorLUAP02I0YSE
	BqrjE7v32zuo/0awpni2BtjZGm88knoJ/QF4ktbA6/w==
X-Gm-Gg: Acq92OELlgb/9C6Oh4cKv24mWDa/+Sj+mtPhgX0HdrkkusdVCaRLNpKcUqtPtUuV8Gu
	ebMyE2qtol0xmVqogX28leRN0L6jh9JUZS6s67fvFVcsa9P6s8cNgOqzniOiJGUDsyl+PsoeNiH
	l5wrYa7unCmm/+9nV7StCr8GQbvlgU9+0bL6lqMnFHw1/5RfeWsUidRUjO9oYf5D22vKvxqJssM
	uPV33vtcNPtMm0a5xTmrbDfaUGRlFZZw9q4cCRnkaw3SOd5KEic6oLJPSDOngGGsa0DvUUNnZ3V
	fDyM1x/sSaEj7Rxzw2JUf/daviy3jfSEXldj57O4
X-Received: by 2002:a05:690c:6104:b0:7ba:f0ed:c5eb with SMTP id
 00721157ae682-7d3349cbcf4mr173857207b3.3.1779749146508; Mon, 25 May 2026
 15:45:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Brian Thompson <brianbthompson@gmail.com>
Date: Mon, 25 May 2026 15:45:10 -0700
X-Gm-Features: AVHnY4Lw3KehBCQL69EYqaTjAoiUqjA_Oazlogng_ttlENj4_C45jNlaL-mBSV4
Message-ID: <CADcHvwfwQJRHEK1YWx_R9npK-eUwkVCHyPtt5f8BvvpR+UwEMQ@mail.gmail.com>
Subject: Re: I Need help. can't open btrfs drive after power outage while
 copying files
To: wqu@suse.com
Cc: Brian Thompson <brianbthompson@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, thanks for replying so fast. yes, some writes didn't reach the
disk. Again, I had paused the transfer of files and then i accidently
cut the power to the drive... Whoops...

Anyway here is the dump-super

superblock: bytenr=3D65536, device=3D/dev/sdc1
---------------------------------------------------------
csum_type               0 (crc32c)
csum_size               4
csum                    0xa7602cf4 [match]
bytenr                  65536
flags                   0x1
                       ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    170f86c7-972d-4493-b13b-1046a34b5281
metadata_uuid           00000000-0000-0000-0000-000000000000
label                   12TB WD Desktop Hard Drive
generation              569
root                    1065746432
sys_array_size          129
chunk_root_generation   569
root_level              0
chunk_root              27394048
chunk_root_level        1
log_root                0
log_root_transid (deprecated)   0
log_root_level          0
total_bytes             12000136527872
bytes_used              633592479744
sectorsize              4096
nodesize                16384
leafsize (deprecated)   16384
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0xb
                       ( FREE_SPACE_TREE |
                         FREE_SPACE_TREE_VALID |
                         BLOCK_GROUP_TREE )
incompat_flags          0x361
                       ( MIXED_BACKREF |
                         BIG_METADATA |
                         EXTENDED_IREF |
                         SKINNY_METADATA |
                         NO_HOLES )
cache_generation        0
uuid_tree_generation    569
dev_item.uuid           2ed41ad3-7b25-4de5-8e37-1ba10381707b
dev_item.fsid           170f86c7-972d-4493-b13b-1046a34b5281 [match]
dev_item.type           0
dev_item.total_bytes    12000136527872
dev_item.bytes_used     638901551104
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
       item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096)
               length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
               io_align 65536 io_width 65536 sector_size 4096
               num_stripes 2 sub_stripes 1
                       stripe 0 devid 1 offset 22020096
                       dev_uuid 2ed41ad3-7b25-4de5-8e37-1ba10381707b
                       stripe 1 devid 1 offset 30408704
                       dev_uuid 2ed41ad3-7b25-4de5-8e37-1ba10381707b
backup_roots[4]:
       backup 0:
               backup_tree_root:       1065746432      gen: 569        leve=
l: 0
               backup_chunk_root:      27394048        gen: 569        leve=
l: 1
               backup_extent_root:     1065533440      gen: 569        leve=
l: 1
               backup_fs_root:         1065713664      gen: 569        leve=
l: 1
               backup_dev_root:        1064697856      gen: 569        leve=
l: 1
               csum_root:      1064796160      gen: 569        level: 2
               backup_total_bytes:     12000136527872
               backup_bytes_used:      633592479744
               backup_num_devices:     1

       backup 1:
               backup_tree_root:       1060421632      gen: 566        leve=
l: 0
               backup_chunk_root:      27246592        gen: 566        leve=
l: 1
               backup_extent_root:     1060274176      gen: 566        leve=
l: 1
               backup_fs_root:         1059667968      gen: 566        leve=
l: 1
               backup_dev_root:        1059930112      gen: 566        leve=
l: 1
               csum_root:      1059700736      gen: 566        level: 2
               backup_total_bytes:     12000136527872
               backup_bytes_used:      629965012992
               backup_num_devices:     1

       backup 2:
               backup_tree_root:       1062191104      gen: 567        leve=
l: 0
               backup_chunk_root:      27295744        gen: 567        leve=
l: 1
               backup_extent_root:     1062010880      gen: 567        leve=
l: 1
               backup_fs_root:         1061650432      gen: 567        leve=
l: 1
               backup_dev_root:        1061453824      gen: 567        leve=
l: 1
               csum_root:      1061683200      gen: 567        level: 2
               backup_total_bytes:     12000136527872
               backup_bytes_used:      631174152192
               backup_num_devices:     1

       backup 3:
               backup_tree_root:       1064026112      gen: 568        leve=
l: 0
               backup_chunk_root:      27344896        gen: 568        leve=
l: 1
               backup_extent_root:     1063796736      gen: 568        leve=
l: 1
               backup_fs_root:         1063567360      gen: 568        leve=
l: 1
               backup_dev_root:        1063108608      gen: 568        leve=
l: 1
               csum_root:      1063600128      gen: 568        level: 2
               backup_total_bytes:     12000136527872
               backup_bytes_used:      632383324160
               backup_num_devices:     1



Also, I tried running "btrfs check --readonly -r 1065746432 /dev/sdc1"
 It came back with
Opening filesystem to check...
checksum verify failed on 1065746432 wanted 0x00000000 found 0xb6bde3e4
checksum verify failed on 1065746432 wanted 0x00000000 found 0xb6bde3e4
checksum verify failed on 1065746432 wanted 0x00000000 found 0xb6bde3e4
bad tree block 1065746432, bytenr mismatch, want=3D1065746432, have=3D0
Couldn't read tree root
ERROR: cannot open file system

however, with  1060421632 I got back

Opening filesystem to check...
parent transid verify failed on 1060421632 wanted 569 found 566
parent transid verify failed on 1060421632 wanted 569 found 566
parent transid verify failed on 1060421632 wanted 569 found 566
Ignoring transid failure
Checking filesystem on /dev/sdc1
UUID: 170f86c7-972d-4493-b13b-1046a34b5281
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
Chunk[256, 228, 635685568512]: length(1073741824),
offset(635685568512), type(1) is not found in block group
Chunk[256, 228, 635685568512] stripe[1, 635693957120] is not found in dev e=
xtent
Chunk[256, 228, 636759310336]: length(1073741824),
offset(636759310336), type(1) is not found in block group
Chunk[256, 228, 636759310336] stripe[1, 636767698944] is not found in dev e=
xtent
Chunk[256, 228, 637833052160]: length(1073741824),
offset(637833052160), type(1) is not found in block group
Chunk[256, 228, 637833052160] stripe[1, 637841440768] is not found in dev e=
xtent
metadata level mismatch on [27246592, 16384]
ref mismatch on [27246592 16384] extent item 1, found 0
tree extent[27246592, 16384] root 3 has no tree block found
incorrect global backref count on 27246592 found 1 wanted 0
backpointer mismatch on [27246592 16384]
owner ref check failed [27246592 16384]
ref mismatch on [27262976 16384] extent item 1, found 0
tree extent[27262976, 16384] root 3 has no tree block found
incorrect global backref count on 27262976 found 1 wanted 0
backpointer mismatch on [27262976 16384]
owner ref check failed [27262976 16384]
ref mismatch on [27279360 16384] extent item 1, found 0
tree extent[27279360, 16384] root 3 has no tree block found
incorrect global backref count on 27279360 found 1 wanted 0
backpointer mismatch on [27279360 16384]
owner ref check failed [27279360 16384]
metadata level mismatch on [27394048, 16384]
ref mismatch on [27394048 16384] extent item 0, found 1
tree extent[27394048, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27394048 16384]
ref mismatch on [27410432 16384] extent item 0, found 1
tree extent[27410432, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27410432 16384]
ref mismatch on [27426816 16384] extent item 0, found 1
tree extent[27426816, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27426816 16384]
ERROR: errors found in extent allocation tree or chunk allocation
[4/8] checking free space tree
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
ERROR: transid errors in file system
found 629965062144 bytes used, error(s) found
total csum bytes: 614577360
total tree bytes: 637796352
total fs tree bytes: 1736704
total extent tree bytes: 4194304
btree space waste bytes: 11419627
file data blocks allocated: 629327216640
referenced 629327179776


and running
=E2=9D=AF sudo btrfs check --readonly -r 1062191104 /dev/sdc1
Opening filesystem to check...
parent transid verify failed on 1062191104 wanted 569 found 567
parent transid verify failed on 1062191104 wanted 569 found 567
parent transid verify failed on 1062191104 wanted 569 found 567
Ignoring transid failure
Checking filesystem on /dev/sdc1
UUID: 170f86c7-972d-4493-b13b-1046a34b5281
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
Chunk[256, 228, 636759310336]: length(1073741824),
offset(636759310336), type(1) is not found in block group
Chunk[256, 228, 636759310336] stripe[1, 636767698944] is not found in dev e=
xtent
Chunk[256, 228, 637833052160]: length(1073741824),
offset(637833052160), type(1) is not found in block group
Chunk[256, 228, 637833052160] stripe[1, 637841440768] is not found in dev e=
xtent
metadata level mismatch on [27295744, 16384]
ref mismatch on [27295744 16384] extent item 1, found 0
tree extent[27295744, 16384] root 3 has no tree block found
incorrect global backref count on 27295744 found 1 wanted 0
backpointer mismatch on [27295744 16384]
owner ref check failed [27295744 16384]
ref mismatch on [27312128 16384] extent item 1, found 0
tree extent[27312128, 16384] root 3 has no tree block found
incorrect global backref count on 27312128 found 1 wanted 0
backpointer mismatch on [27312128 16384]
owner ref check failed [27312128 16384]
ref mismatch on [27328512 16384] extent item 1, found 0
tree extent[27328512, 16384] root 3 has no tree block found
incorrect global backref count on 27328512 found 1 wanted 0
backpointer mismatch on [27328512 16384]
owner ref check failed [27328512 16384]
metadata level mismatch on [27394048, 16384]
ref mismatch on [27394048 16384] extent item 0, found 1
tree extent[27394048, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27394048 16384]
ref mismatch on [27410432 16384] extent item 0, found 1
tree extent[27410432, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27410432 16384]
ref mismatch on [27426816 16384] extent item 0, found 1
tree extent[27426816, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27426816 16384]
ERROR: errors found in extent allocation tree or chunk allocation
[4/8] checking free space tree
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
ERROR: transid errors in file system
found 631174201344 bytes used, error(s) found
total csum bytes: 615757008
total tree bytes: 638976000
total fs tree bytes: 1736704
total extent tree bytes: 4194304
btree space waste bytes: 11402444
file data blocks allocated: 630535176192
referenced 630535139328


as well as

=E2=9D=AF sudo btrfs check --readonly -r 1064026112  /dev/sdc1
[sudo] password for brian:
Opening filesystem to check...
parent transid verify failed on 1064026112 wanted 569 found 568
parent transid verify failed on 1064026112 wanted 569 found 568
parent transid verify failed on 1064026112 wanted 569 found 568
Ignoring transid failure
Checking filesystem on /dev/sdc1
UUID: 170f86c7-972d-4493-b13b-1046a34b5281
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
Chunk[256, 228, 637833052160]: length(1073741824),
offset(637833052160), type(1) is not found in block group
Chunk[256, 228, 637833052160] stripe[1, 637841440768] is not found in dev e=
xtent
metadata level mismatch on [27344896, 16384]
ref mismatch on [27344896 16384] extent item 1, found 0
tree extent[27344896, 16384] root 3 has no tree block found
incorrect global backref count on 27344896 found 1 wanted 0
backpointer mismatch on [27344896 16384]
owner ref check failed [27344896 16384]
ref mismatch on [27361280 16384] extent item 1, found 0
tree extent[27361280, 16384] root 3 has no tree block found
incorrect global backref count on 27361280 found 1 wanted 0
backpointer mismatch on [27361280 16384]
owner ref check failed [27361280 16384]
ref mismatch on [27377664 16384] extent item 1, found 0
tree extent[27377664, 16384] root 3 has no tree block found
incorrect global backref count on 27377664 found 1 wanted 0
backpointer mismatch on [27377664 16384]
owner ref check failed [27377664 16384]
metadata level mismatch on [27394048, 16384]
ref mismatch on [27394048 16384] extent item 0, found 1
tree extent[27394048, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27394048 16384]
ref mismatch on [27410432 16384] extent item 0, found 1
tree extent[27410432, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27410432 16384]
ref mismatch on [27426816 16384] extent item 0, found 1
tree extent[27426816, 16384] root 3 has no backref item in extent tree
backpointer mismatch on [27426816 16384]
ERROR: errors found in extent allocation tree or chunk allocation
[4/8] checking free space tree
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
ERROR: transid errors in file system
found 632383373312 bytes used, error(s) found
total csum bytes: 616936656
total tree bytes: 640188416
total fs tree bytes: 1736704
total extent tree bytes: 4210688
btree space waste bytes: 11417620
file data blocks allocated: 631743135744
referenced 631743098880


Please let me know what I can try next. Thanks again
