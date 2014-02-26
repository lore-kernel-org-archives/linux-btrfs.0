Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53431 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaBZRQn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 12:16:43 -0500
Date: Wed, 26 Feb 2014 09:16:42 -0800
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0rc3: did not find backref in send_root
Message-ID: <20140226171642.GB640@merlins.org>
References: <20140226074603.GA11372@merlins.org> <530D9D09.8070600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530D9D09.8070600@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 26, 2014 at 03:51:37PM +0800, Wang Shilong wrote:
> >I've applied your patch from
> >https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=1334bebe71bebbca47b3b92f25511ea980fdeab8

I can confirm this fixed the btrfs send error on my server, thank you.

> >At snapshot var_ro.20140225_23:28:47
> >ERROR: send ioctl failed with -5: Input/output error
> >ERROR: unexpected EOF in stream.
> >[  216.534313] BTRFS info (device dm-0): csum failed ino 2326136 off 
> >192512 csum 3851586574 expected csum 1402824092
> >
> >Then again, this seems to be my problem on the laptop:
> >legolas:/mnt/btrfs_pool1# btrfs scrub status /mnt/btrfs_pool1
> >scrub status for 4850ee22-bf32-4131-a841-02abdb4a5ba6
> >	scrub started at Tue Feb 25 07:35:07 2014 and finished after 1945 
> >	seconds
> >	total bytes scrubbed: 451.64GiB with 2 errors
> >	error details: csum=2
> >	corrected errors: 0, uncorrectable errors: 2, unverified errors: 0
> >
> >Ok, so that's not a btrfs send problem.
> >Just out of curiosity, how do I find out which inodes are compromized so
> >that I can delete/restore them?
> You can use command  "btrfs inspect-internal inode-resolve" which will 
> print inode's
> corresponding path with it's inode id.

Yes, sorry, I wasn't clear. I know how to do this.
What I meant is that btrfs scrub tells me there are 2 errors and does not
tell me which inode/subvolume the error are in.

Aah, but they were in syslog, I just hadn't found them until now :)

Ok, I'm all good then.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
