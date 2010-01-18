From: "Ronny H. Kavli" <ronny.kavli@gmail.com>
Subject: Re: Inconsistent reports after disk-error.
Date: Mon, 18 Jan 2010 23:59:37 +0100
Message-ID: <1263855577.6829.26.camel@bollox.stuffit.loc>
References: <1263854740.6829.20.camel@bollox.stuffit.loc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1263854740.6829.20.camel@bollox.stuffit.loc>
List-ID: <linux-btrfs.vger.kernel.org>

Ah. I can reply to myself after checking the logs when I try to mount
with dmesg(1).

Two successive mount-attempts give indeed a consistent result:

[ 3712.163040] device fsid 794be0222f8f0708-ffaf918752666783 devid 1
transid 9044 /dev/mapper/vg3-vbox1
[ 3712.172059] btrfs: dm-7 checksum verify failed on 142837022720 wanted
5D181110 found 5D18D333 level 0
[ 3712.172931] btrfs: dm-7 checksum verify failed on 142837022720 wanted
5D181110 found 5D18D333 level 0
[ 3712.173433] btrfs: dm-7 checksum verify failed on 142837022720 wanted
5D185110 found 5D18D333 level 0
[ 3712.173440] btrfs: failed to read tree root on dm-7
[ 3712.173762] btrfs: open_ctree failed
[ 3714.210952] device fsid 794be0222f8f0708-ffaf918752666783 devid 1
transid 9044 /dev/mapper/vg3-vbox1
[ 3714.220220] btrfs: dm-7 checksum verify failed on 142837022720 wanted
5D181110 found 5D18D333 level 0
[ 3714.220718] btrfs: dm-7 checksum verify failed on 142837022720 wanted
5D181110 found 5D18D333 level 0
[ 3714.221217] btrfs: dm-7 checksum verify failed on 142837022720 wanted
5D185110 found 5D18D333 level 0
[ 3714.221224] btrfs: failed to read tree root on dm-7
[ 3714.221461] btrfs: open_ctree failed

I then make the the assumption that my copy of btrfsck is not giving
correct output.

 -- RHK

