From: Diwaker Gupta <diwaker@maginatics.com>
Subject: Error mounting multi-device fs after restart
Date: Mon, 7 Feb 2011 11:46:20 -0800
Message-ID: <AANLkTi=vSb0i-joekFrZRmwcAE+5w8FwV2FFWcbMvC6n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

We have 10 1-TB drives hosting a multi-device btrfs filesystem,
configured with raid1+0 for both data and metadata. After some package
upgrades over the weekend I restarted the system and it did not come
back up afterwards. I booted using a rescue disk and ran btrfsck (next
branch from Chris's git repository). Unfortunately btrfsck aborts on
every single drive with errors like this:

parent transid verify failed on 12050980864 wanted 377535 found 128327
parent transid verify failed on 12074557440 wanted 422817 found 126691
parent transid verify failed on 12057542656 wanted 422786 found 126395
parent transid verify failed on 12075556864 wanted 423004 found 126691
bad block 12095545344
parent transid verify failed on 12079190016 wanted 422826 found 105147
leaf parent key incorrect 12097544192
bad block 12097544192

I'm running 10.04 Ubuntu Lucid with the lts-backport x86_64 kernel:
2.6.35-23-server

Attempting to mount the filesystem blocks indefinitely, with
/var/log/messages getting filled with the 'parent transid verify'
errors.

IIUC the 'btrfs-select-super' utility is not really helpful in our
case. At this point, my only priority is to somehow rescue the data
from the filesystem. I'd really appreciate if someone on the list
could help me out.

I'm happy to provide any other information required. Please CC me on
replies as I'm not subscribed to the list.

Thanks,
Diwaker
