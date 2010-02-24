From: Josef Bacik <josef@redhat.com>
Subject: Re: No space left on device, btrfsctl segmentation fault
Date: Wed, 24 Feb 2010 10:43:54 -0500
Message-ID: <20100224154353.GB2257@localhost.localdomain>
References: <2b0225fb1002231939q2020bf05g145f852e5b4c560@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Boyd Waters <waters.boyd@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2b0225fb1002231939q2020bf05g145f852e5b4c560@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2010 at 10:39:33PM -0500, Boyd Waters wrote:
> Greetings!
> 
> I have a singe 2TB disk formatted with btrfs 0.19 on Ubuntu 10.04-alpha2:
> 
> # uname -a
> Linux fan-ting 2.6.32-14-generic #20-Ubuntu SMP Sat Feb 20 05:18:19
> UTC 2010 x86_64 GNU/Linux
> 
> # df -h /media/onlyhope/
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdi2             1.9T  1.7T  197G  90% /media/onlyhope
> 
> 
> I'm getting "no space left on device" errors when I try to move files
> to this volumes via rsync.
> 
> So I tried, as an experiment, to "defragment" the volume with btrfsctl:
> 
> # btrfsctl -d /media/onlyhope
> Segmentation fault
> 
> 
> I am a btrfs newbie. Clearly I am doing something wrong. Any
> suggestions for generating a more meaningful error report?
> 

You'll want to try

btrfs-vol -b /media/onlyhope

that will balance the metadata/data space and hopefully let you get back some of
your space.  Just a warning, that will take _forever_, and then it still may
hang.  You'll want to watch dmesg, if it says something like

moving <number> extents

and <number> does not change for like 20 lines, then its hung and you need to
reboot.  When you reboot and remount it will hang for a bit, thats ok its just
cleaning things up, and then you should be good to go.  Thanks,

Josef
