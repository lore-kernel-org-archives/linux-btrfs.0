Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:46369 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeBYEHL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Feb 2018 23:07:11 -0500
Received: by mail-ot0-f175.google.com with SMTP id g97so4994003otg.13
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 20:07:11 -0800 (PST)
MIME-Version: 1.0
From: Adam Bahe <adambahe@gmail.com>
Date: Sat, 24 Feb 2018 22:06:30 -0600
Message-ID: <CACzgC9j7uNqDGc8W2cLRb-9kGmf=DCqS3_jLLZuFOwdmVPeuQg@mail.gmail.com>
Subject: csum failed error messages
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I am getting the below errors on a brand new array with drives
that are maybe 2 months old which have been absolutely fine up until
now, and report no errors in smartctl.

[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20578304 csum 0xe238f260 expected csum
0x1f75cdaf mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20643840 csum 0xd405b86c expected csum
0x8ae8e7a0 mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20709376 csum 0xb3b1b3d5 expected csum
0x49c03047 mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20774912 csum 0xbae45901 expected csum
0xcd407f6e mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20840448 csum 0x25efff37 expected csum
0x8b5a8f8e mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20905984 csum 0x00d4eca7 expected csum
0xee34ed56 mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20971520 csum 0x1f9dd8a0 expected csum
0xf1f28ff0 mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 21037056 csum 0xe02609dc expected csum
0xdb3403c7 mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20647936 csum 0xa96e82b9 expected csum
0x5d651271 mirror 2
[Sat Feb 24 06:04:37 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 20713472 csum 0xf0daf100 expected csum
0x2bc31300 mirror 2
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 21757952 (dev /dev/sdi sector 5332303360)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20635648 (dev /dev/sdi sector 5332301168)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20770816 (dev /dev/sdi sector 5332301432)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20832256 (dev /dev/sdi sector 5332301552)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20836352 (dev /dev/sdi sector 5332301560)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20873216 (dev /dev/sdi sector 5332301632)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20877312 (dev /dev/sdi sector 5332301640)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20881408 (dev /dev/sdi sector 5332301648)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20885504 (dev /dev/sdi sector 5332301656)
[Sat Feb 24 06:04:39 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 20889600 (dev /dev/sdi sector 5332301664)
[Sat Feb 24 06:04:42 2018] btrfs_print_data_csum_error: 10130
callbacks suppressed
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42274816 csum 0xc2ab8670 expected csum
0x12f27df1 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 43188224 csum 0x18d3b936 expected csum
0x771ec303 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42536960 csum 0x2f73cd85 expected csum
0x9bc43ad6 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42278912 csum 0xd2709b14 expected csum
0xf80c4a9c mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42602496 csum 0x8a3ae7f3 expected csum
0x5b744967 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42541056 csum 0x58f8bb67 expected csum
0xd2149363 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42283008 csum 0x0736b81d expected csum
0xd3fad033 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 43192320 csum 0xdf3d9837 expected csum
0x2801dfc3 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42606592 csum 0x0767fef3 expected csum
0xe5098e39 mirror 2
[Sat Feb 24 06:04:42 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 42545152 csum 0x479c55ea expected csum
0x2dc3cdfb mirror 2
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50724864 (dev /dev/sdi sector 5332359936)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50728960 (dev /dev/sdi sector 5332359944)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50733056 (dev /dev/sdi sector 5332359952)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50737152 (dev /dev/sdi sector 5332359960)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50790400 (dev /dev/sdi sector 5332360064)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50794496 (dev /dev/sdi sector 5332360072)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50798592 (dev /dev/sdi sector 5332360080)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50855936 (dev /dev/sdi sector 5332360192)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50860032 (dev /dev/sdi sector 5332360200)
[Sat Feb 24 06:04:44 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 50921472 (dev /dev/sdi sector 5332360320)
[Sat Feb 24 06:04:48 2018] btrfs_print_data_csum_error: 14733
callbacks suppressed
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75104256 csum 0x97cb1c55 expected csum
0x03c9ee07 mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75169792 csum 0x95608c36 expected csum
0x6def0424 mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75108352 csum 0xb6551ba1 expected csum
0xdc7fdece mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75235328 csum 0xb83a216c expected csum
0x69a7f5e8 mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75173888 csum 0x09bf9201 expected csum
0x3cd81fdf mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75239424 csum 0x6dc2fe0b expected csum
0xaa69a5f9 mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75300864 csum 0xe7c12c9f expected csum
0xce96efc9 mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75112448 csum 0xb034b2ef expected csum
0x7198bf3c mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75177984 csum 0x8136ff59 expected csum
0x3e285d95 mirror 2
[Sat Feb 24 06:04:48 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 75243520 csum 0x4c1b9a0e expected csum
0x8132c290 mirror 2
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79360000 (dev /dev/sdi sector 5332415864)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79425536 (dev /dev/sdi sector 5332415992)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79486976 (dev /dev/sdi sector 5332416112)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79491072 (dev /dev/sdi sector 5332416120)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79548416 (dev /dev/sdi sector 5332416232)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79618048 (dev /dev/sdi sector 5332416368)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79622144 (dev /dev/sdi sector 5332416376)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79675392 (dev /dev/sdi sector 5332416480)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79679488 (dev /dev/sdi sector 5332416488)
[Sat Feb 24 06:04:49 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 79740928 (dev /dev/sdi sector 5332416608)
[Sat Feb 24 06:04:53 2018] btrfs_print_data_csum_error: 17589
callbacks suppressed
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 111542272 csum 0xb14aef75 expected csum
0xeb89c512 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 111546368 csum 0x26a3b137 expected csum
0x8f79bc06 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112234496 csum 0xd75e00d3 expected csum
0x9cde2254 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112238592 csum 0xa63ef36c expected csum
0xf6f258d6 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112242688 csum 0x86bf1e9e expected csum
0x0ef304c6 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112246784 csum 0xe1226b2b expected csum
0xee552a84 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112250880 csum 0xaddb2ec2 expected csum
0x53de1842 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112254976 csum 0x3c7fa11f expected csum
0x9e25a99a mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112295936 csum 0xc71bf658 expected csum
0x38ea8e98 mirror 2
[Sat Feb 24 06:04:53 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 112300032 csum 0xc1973a8f expected csum
0x00089845 mirror 2
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114257920 (dev /dev/sdi sector 5332484024)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114262016 (dev /dev/sdi sector 5332484032)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114266112 (dev /dev/sdi sector 5332484040)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114270208 (dev /dev/sdi sector 5332484048)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114274304 (dev /dev/sdi sector 5332484056)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114278400 (dev /dev/sdi sector 5332484064)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114282496 (dev /dev/sdi sector 5332484072)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114286592 (dev /dev/sdi sector 5332484080)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114290688 (dev /dev/sdi sector 5332484088)
[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114294784 (dev /dev/sdi sector 5332484096)
[Sat Feb 24 06:04:58 2018] btrfs_print_data_csum_error: 14394
callbacks suppressed
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142213120 csum 0x574c45e0 expected csum
0x6ea0c4ac mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142278656 csum 0xfeb24099 expected csum
0xa6ed509c mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142344192 csum 0x1fbaf380 expected csum
0x4584221f mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142409728 csum 0xf7bf00fe expected csum
0xeed4c5ba mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142475264 csum 0xeba8456c expected csum
0xe76df4bf mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142540800 csum 0x046c189c expected csum
0xe45605c1 mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142282752 csum 0xe8716ac0 expected csum
0xc4fa2bf3 mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142606336 csum 0x397d850f expected csum
0x0c47aaee mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142671872 csum 0xf6814168 expected csum
0x9d315b10 mirror 2
[Sat Feb 24 06:04:58 2018] BTRFS warning (device sde): csum failed
root 257 ino 181466 off 142217216 csum 0xf7ff5351 expected csum
0xaff6e688 mirror 2


[root@nas TV]# btrfs-debug-tree /dev/sde |grep "(257 " -A 3 -B 1
                otime 0.0 (1969-12-31 18:00:00)
        item 13 key (257 ROOT_ITEM 0) itemoff 12364 itemsize 439
                generation 2807 root_dirid 256 bytenr 25003902058496
level 2 refs 1
                lastsnap 0 byte_limit 0 bytes_used 382517248 flags 0x0(none)
                uuid 4160a321-f82f-704c-9969-1373a20ef1ec
--
                drop key (0 UNKNOWN.0 0) level 0
        item 14 key (257 ROOT_BACKREF 5) itemoff 12343 itemsize 21
                root backref key dirid 256 sequence 2 name nas
        item 15 key (258 INODE_ITEM 0) itemoff 12183 itemsize 160
                inode generation 0 transid 1531 size 0 nbytes 0
--
        item 2 key (256 DIR_ITEM 82667372) itemoff 16078 itemsize 33
                location key (257 ROOT_ITEM -1) type DIR
                transid 10 data_len 0 name_len 3
                name: nas
        item 3 key (256 DIR_INDEX 2) itemoff 16045 itemsize 33
                location key (257 ROOT_ITEM -1) type DIR
                transid 10 data_len 0 name_len 3
                name: nas
checksum tree key (CSUM_TREE ROOT_ITEM 0)


[root@nas TV]# btrfs fi show /mnt2/nas
Label: 'pool1'  uuid: 3e73100b-889e-4eac-8a40-02bcff1d4bf7
        Total devices 10 FS bytes used 22.98TiB
        devid    1 size 9.10TiB used 3.52TiB path /dev/sdp
        devid    2 size 9.10TiB used 3.52TiB path /dev/sdm
        devid    3 size 9.03TiB used 3.46TiB path /dev/sdn
        devid    4 size 9.03TiB used 3.46TiB path /dev/sdi
        devid    5 size 10.91TiB used 5.34TiB path /dev/sde
        devid    6 size 10.91TiB used 5.34TiB path /dev/sdj
        devid    7 size 10.91TiB used 5.34TiB path /dev/sdf
        devid    8 size 10.91TiB used 5.34TiB path /dev/sdo
        devid    9 size 10.91TiB used 5.34TiB path /dev/sdk
        devid   10 size 10.91TiB used 5.34TiB path /dev/sdq


[root@nas TV]# btrfs fi df /mnt2/nas
Data, RAID1: total=22.96TiB, used=22.95TiB
System, RAID1: total=40.00MiB, used=3.14MiB
Metadata, RAID1: total=26.00GiB, used=25.03GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


[root@nas TV]# btrfs scrub status /mnt2/nas
scrub status for 3e73100b-889e-4eac-8a40-02bcff1d4bf7
        scrub started at Sat Feb 24 13:30:01 2018 and finished after 08:24:07
        total bytes scrubbed: 45.95TiB with 0 errors



I have just had to completely rebuild my array. These are all brand
new SAS enterprise drives. A mix of 10 and 12TB. I copied all my data
off of the old array to a bunch of individual ext4 drives, and am in
the process of copying all of the data back on to my new array.
However now I am getting these errors in dmesg. I did a scrub and zero
errors returned.

My question is this: Exactly what commands do I run to fix this?
Thanks! I have had so many repeated issues with btrfs :(
