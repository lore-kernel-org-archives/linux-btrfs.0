From: Felix Blanke <felixblanke@gmail.com>
Subject: btrfs and raid1 (restore)
Date: Wed, 8 Sep 2010 00:28:07 +0200
Message-ID: <20100907222807.GA3546@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I made a REALLY bad mistake today.

I've two hdds which are running at raid1 via btrfs. Today I mistyped a device-node
and did a "mkfs.vfat" on one of them.

Then I simply did a "btrfs filesystem balance /path/". "btrfs filesystem show /path/"
now looks like this:

Label: 'home1'  uuid: c3c38f32-f176-4479-8c44-e832ea64639f
    Total devices 2 FS bytes used 226.12GB
    devid    2 size 465.76GB used 114.38GB path /dev/loop3
    devid    1 size 465.76GB used 114.39GB path /dev/loop4


Before my mistake the "FS bytes used" were all three the same, now the bottom two are
only half of the size. Am I right that those devices didnt run in raid1 mode anymore?
:(


Is there a way, without copying back all data from my backup, to get those 2 running in
raid1 mode?
Or do I have to make a "mkfs.btrfs -m raid1 -d raid1 /dev/1", "btrfs device add /dev/2" and
"btrfs filesystem balance /path/"? :/ That would cost a lot of time.


Thanks for your help!


Regards,
Felix
