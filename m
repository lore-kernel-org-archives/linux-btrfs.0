From: Rob Hall <rhall@wincommander.co.uk>
Subject: Stuck in loop mounting corrupt FS with 3.2-rc4 and 5
Date: Sat, 10 Dec 2011 13:31:21 +0000
Message-ID: <2003376.3zQqHt4Zy0@home-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying to recover some files off a corrupt fs. Everything I've read suggests that 3.2 has a lot of new code that can handle a lot of corruption issues so I thought I'd give it a whirl.. Tried rc4 and today rc5 and the issue I see remains the same. 

The primary FS is on an LVM2 LV so I snapshot this before I start working on it. When I attempt to mount the snapshot I get a number of errors reported and then the system seems to get stuck in a loop:-

Dec 10 13:14:24 ria kernel: [  110.452068] device fsid 2d2ba468-3f7f-4b48-ac5f-fe0497270a8a devid 1 transid 65665 /dev/mapper/bigdisk-backup
Dec 10 13:14:31 ria kernel: [  118.131903] btrfs read error corrected: ino 1 off 959056752640 (dev /dev/mapper/bigdisk-backup sector 1877630552)
Dec 10 13:14:36 ria kernel: [  122.890269] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  122.890287] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  122.890298] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  122.890308] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  122.890315] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  123.144716] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  123.144733] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  123.144743] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  123.144753] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:36 ria kernel: [  123.144760] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:41 ria kernel: [  127.748555] btrfs read error corrected: ino 1 off 959087030272 (dev /dev/mapper/bigdisk-backup sector 1877689688)
Dec 10 13:14:41 ria kernel: [  127.813828] btrfs read error corrected: ino 1 off 959087026176 (dev /dev/mapper/bigdisk-backup sector 1877689680)
Dec 10 13:14:41 ria kernel: [  127.888700] btrfs read error corrected: ino 1 off 959087022080 (dev /dev/mapper/bigdisk-backup sector 1877689672)
Dec 10 13:14:41 ria kernel: [  127.903082] verify_parent_transid: 75 callbacks suppressed
Dec 10 13:14:41 ria kernel: [  127.903088] parent transid verify failed on 959087001600 wanted 64595 found 64592
Dec 10 13:14:41 ria kernel: [  127.903102] parent transid verify failed on 959087001600 wanted 64595 found 64592
Dec 10 13:14:41 ria kernel: [  127.903113] parent transid verify failed on 959087001600 wanted 64595 found 64592
Dec 10 13:14:41 ria kernel: [  127.903123] parent transid verify failed on 959087001600 wanted 64595 found 64592
Dec 10 13:14:41 ria kernel: [  127.903131] parent transid verify failed on 959087001600 wanted 64595 found 64592
Dec 10 13:14:41 ria kernel: [  127.925401] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:41 ria kernel: [  127.925414] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:41 ria kernel: [  127.925425] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:41 ria kernel: [  127.925435] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:41 ria kernel: [  127.925442] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:49 ria kernel: [  135.835363] verify_parent_transid: 23 callbacks suppressed
Dec 10 13:14:49 ria kernel: [  135.835373] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:49 ria kernel: [  135.835385] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:49 ria kernel: [  135.835396] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:49 ria kernel: [  135.835405] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:49 ria kernel: [  135.835413] parent transid verify failed on 959075540992 wanted 64629 found 64577
Dec 10 13:14:49 ria kernel: [  136.340906] parent transid verify failed on 959105851392 wanted 64544 found 64545
Dec 10 13:14:49 ria kernel: [  136.340923] parent transid verify failed on 959105851392 wanted 64544 found 64545
Dec 10 13:14:49 ria kernel: [  136.340933] parent transid verify failed on 959105851392 wanted 64544 found 64545
Dec 10 13:14:51 ria kernel: [  137.855455] btrfs read error corrected: ino 1 off 959056744448 (dev /dev/mapper/bigdisk-backup sector 1877630536)
Dec 10 13:14:53 ria kernel: [  139.570771] btrfs read error corrected: ino 1 off 959072305152 (dev /dev/mapper/bigdisk-backup sector 1877660928)
Dec 10 13:14:53 ria kernel: [  140.119668] btrfs read error corrected: ino 1 off 959053987840 (dev /dev/mapper/bigdisk-backup sector 1877625152)
Dec 10 13:14:54 ria kernel: [  141.331207] parent transid verify failed on 959076446208 wanted 64506 found 64462
Dec 10 13:14:54 ria kernel: [  141.331227] parent transid verify failed on 959076446208 wanted 64506 found 64462
Dec 10 13:14:54 ria kernel: [  141.331238] parent transid verify failed on 959076446208 wanted 64506 found 64462
Dec 10 13:14:58 ria kernel: [  145.015268] btrfs read error corrected: ino 1 off 959075999744 (dev /dev/mapper/bigdisk-backup sector 1877668144)
Dec 10 13:14:58 ria kernel: [  145.077436] btrfs read error corrected: ino 1 off 959075987456 (dev /dev/mapper/bigdisk-backup sector 1877668120)
Dec 10 13:14:59 ria kernel: [  145.834595] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  145.834615] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  145.834627] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  145.834637] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  145.834645] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  145.834685] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  145.834696] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332028] verify_parent_transid: 71171 callbacks suppressed
Dec 10 13:14:59 ria kernel: [  146.332035] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332044] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332052] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332060] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332069] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332077] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332085] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332093] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332102] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:14:59 ria kernel: [  146.332110] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336024] verify_parent_transid: 939200 callbacks suppressed
Dec 10 13:15:04 ria kernel: [  151.336030] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336038] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336046] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336054] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336062] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336070] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336078] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336085] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336093] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:04 ria kernel: [  151.336101] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340025] verify_parent_transid: 958696 callbacks suppressed
Dec 10 13:15:09 ria kernel: [  156.340032] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340041] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340049] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340056] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340064] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340072] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340080] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340087] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340095] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:09 ria kernel: [  156.340103] parent transid verify failed on 959075995648 wanted 64457 found 64509
Dec 10 13:15:14 ria kernel: [  161.344016] verify_parent_transid: 966318 callbacks suppressed

This continues until I reboot


-- 
Regards,

Rob Hall


-- 
This email was Anti Virus checked by Astaro Security Gateway. http://www.astaro.com
