Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49225 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaBZHqN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 02:46:13 -0500
Date: Tue, 25 Feb 2014 23:46:04 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Message-ID: <20140226074603.GA11372@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530D61B6.7040106@cn.fujitsu.com>
 <20140225063652.GD3521@merlins.org>
Subject: Re: 3.14.0rc3: did not find backref in send_root
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 26, 2014 at 11:38:30AM +0800, Wang Shilong wrote:
> Hi Marc,
> 
> On 02/26/2014 01:30 AM, Marc MERLIN wrote:
> >On Tue, Feb 25, 2014 at 03:50:15PM +0800, Wang Shilong wrote:
> >>Hi Marc,
> >>
> >>This seems a regression which has been fixed by the following
> >>commit(only pushed into btrfs-next):
> >>
> >>https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=1334bebe71bebbca47b3b92f25511ea980fdeab8
> >I'll revert this, thanks.
> >
> >Mmmh, but I just found another problem I didn't have before upgrading to 3.14.0-rc3
> >(on my laptop this time):
> What is your previous version, give a double check whether the
> following commit exists:
> 
> Btrfs: remove transaction from btrfs send(commitid: 41ce9970)
> 
> This regression should exist in 3.14 Sine chris firstly pull big
> btrfs request for Linux 3.14.
> >
> >+ btrfs send -p /mnt/btrfs_pool1/var_ro.20140224_14:01:54 var_ro.20140225_09:27:57
> >+ btrfs receive /mnt/btrfs_pool2//
> >At subvol var_ro.20140225_09:27:57
> >At snapshot var_ro.20140225_09:27:57
> >ERROR: send ioctl failed with -5: Input/output error
> >ERROR: unexpected EOF in stream.
> Did dmesg output the same things like before?
> 
> Hm, we can esaily trigger that regression if there is snapshot and
> send running concurrently.
> (balance/scrub ...device operations can also trigger send failure.)

So I was confused because I got this on my server:
On Mon, Feb 24, 2014 at 10:36:52PM -0800, Marc MERLIN wrote:
> I got this during a btrfs send:
> BTRFS error (device dm-2): did not find backref in send_root. inode=22672, offset=524288, disk_byte=1490517954560 found extent=1490517954560

and that on my laptop:
[82841.563339] BTRFS info (device dm-0): csum failed ino 2590 extent 2397949952 csum 3100992190 wanted 2786811954 mirror 0

I've applied your patch from 
https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=1334bebe71bebbca47b3b92f25511ea980fdeab8

legolas:/mnt/btrfs_pool1# bash -vx /var/local/scr/btrfs-subvolume-backup -k 5  var /mnt/btrfs_pool2/

still failed on my laptop
+ btrfs send -p /mnt/btrfs_pool1/var_ro.20140224_14:01:54 var_ro.20140225_23:28:47
+ btrfs receive /mnt/btrfs_pool2//
At subvol var_ro.20140225_23:28:47
At snapshot var_ro.20140225_23:28:47
ERROR: send ioctl failed with -5: Input/output error
ERROR: unexpected EOF in stream.
[  216.534313] BTRFS info (device dm-0): csum failed ino 2326136 off 192512 csum 3851586574 expected csum 1402824092

Then again, this seems to be my problem on the laptop:
legolas:/mnt/btrfs_pool1# btrfs scrub status /mnt/btrfs_pool1
scrub status for 4850ee22-bf32-4131-a841-02abdb4a5ba6
	scrub started at Tue Feb 25 07:35:07 2014 and finished after 1945 seconds
	total bytes scrubbed: 451.64GiB with 2 errors
	error details: csum=2
	corrected errors: 0, uncorrectable errors: 2, unverified errors: 0

Ok, so that's not a btrfs send problem.
Just out of curiosity, how do I find out which inodes are compromized so
that I can delete/restore them?

Back to my server, I installed the new kernel, and I'm testing send
again. So far it hasn't failed, so there is a chance the patch fixed the
problem, but I'll only know more tomorrow after it's run longer.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
