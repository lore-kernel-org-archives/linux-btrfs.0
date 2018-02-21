Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:59009 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934983AbeBUOUg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 09:20:36 -0500
Message-ID: <1519222829.4313.10.camel@scientia.net>
Subject: Re: BUG: unable to handle kernel paging request at ffff9fb75f827100
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 21 Feb 2018 15:20:29 +0100
In-Reply-To: <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
References: <1519186148.24817.1.camel@scientia.net>
         <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Nikolay.

Thanks.

On Wed, 2018-02-21 at 08:34 +0200, Nikolay Borisov wrote:
> This looks like the one fixed by
> e8f1bc1493855e32b7a2a019decc3c353d94daf6 . It's tagged for stable so
> you
> should get it eventually.

Another consequence of this was that I couldn't sync/umount or shutdown
anymore properly.

And now after hard reset I found this in the kernel logs:
Feb 21 14:49:29 heisenberg kernel: BTRFS warning (device dm-0): csum failed root 257 ino 49103564 off 2076672 csum 0xe1f5b83a expected csum 0x0e0adf97 mirror 1
Feb 21 14:49:29 heisenberg kernel: BTRFS warning (device dm-0): csum failed root 257 ino 49103505 off 4464640 csum 0x0b661193 expected csum 0xe9c939a3 mirror 1
Feb 21 14:49:45 heisenberg kernel: BTRFS warning (device dm-0): csum failed root 257 ino 47533539 off 139264 csum 0x4d704dc7 expected csum 0x2303d9f7 mirror 1


That may be totally unrelated to the above bug (I just may not have
noticed it earlier), but I checked that now:
# btrfs inspect-internal inode-resolve 49103564 /
//usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.9.2
# btrfs inspect-internal inode-resolve 49103505 /
//usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.9.2
# btrfs inspect-internal inode-resolve 47533539 /
//usr/lib/python2.7/dist-packages/libxml2.py

AFAIU inode-resolve should give me the files belonging to the above
broken inodes?

# dpkg -S //usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.9.2
libqt5widgets5:amd64: /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.9.2
# dpkg -S //usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.9.2
libqt5gui5:amd64: /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.9.2
# dpkg -S //usr/lib/python2.7/dist-packages/libxml2.py
python-libxml2: /usr/lib/python2.7/dist-packages/libxml2.py

Which belong to these Debian packages.

# debsums -asc libqt5widgets5 libqt5gui5 python-libxml2
#

Which are apparently correct (as it regards Debian, which keeps some
hash sums of "all" it's package's files).


Interestingly, another:
# btrfs scrub start -Br /dev/disk/by-label/system
scrub done for b6050e38-716a-40c3-a8df-fcf1dd7e655d
	scrub started at Wed Feb 21 14:52:45 2018 and finished after 00:23:25
	total bytes scrubbed: 629.61GiB with 0 errors

#

returned no further error...
What does that mean now? How could btrfs correct the error (did it - I
have no RAID or so)?
Anything further I should do to check the consistency of my filesystem?


Thanks,
Chris.
