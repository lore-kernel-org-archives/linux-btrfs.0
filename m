Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20976 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3BYFGR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 00:06:17 -0500
Date: Mon, 25 Feb 2013 13:03:58 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: dsterba@suse.cz, Marios Titas <redneb8888@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: update inode flags when renaming
Message-ID: <20130225050357.GC3480@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com>
 <CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com>
 <20130222084034.GC12835@liubo.cn.oracle.com>
 <51273BB7.60504@cn.fujitsu.com>
 <20130222220440.GL27541@twin.jikos.cz>
 <20130225034959.GA3480@liubo.jp.oracle.com>
 <512AE727.2040800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512AE727.2040800@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 12:23:03PM +0800, Miao Xie wrote:
> On 	mon, 25 Feb 2013 11:50:01 +0800, Liu Bo wrote:
> > On Fri, Feb 22, 2013 at 11:04:40PM +0100, David Sterba wrote:
> >> On Fri, Feb 22, 2013 at 05:34:47PM +0800, Miao Xie wrote:
> >>> On 	fri, 22 Feb 2013 16:40:35 +0800, Liu Bo wrote:
> >>>> On Fri, Feb 22, 2013 at 03:32:50AM -0500, Marios Titas wrote:
> >>>>> Sorry, but the bug persists even with the above patch.
> >>>>>
> >>>>> touch test
> >>>>> chattr +C test
> >>>>> lsattr test
> >>>>> mv test test2
> >>>>> lsattr test2
> >>>>>
> >>>>> In the above scenario test2 will not have the C flag.
> >>>>
> >>>> What do you expect?  IMO it's right that test2 does not have the C flag.
> >>>
> >>> No, it's not right.
> >>> For the users, they expect the C flag is not lost because they just do
> >>> a rename operation. but fixup_inode_flags() re-sets the flags by the
> >>> parent directory's flag.
> >>>
> >>> I think we should inherit the flags from the parent just when we create
> >>> a new file/directory, in the other cases, just give a option to the users.
> >>> How do you think about?
> >>
> >> I agree with that. The COW status of a file should not be changed at all
> >> when renamed. The typical users are database files and vm images, losing
> >> the NOCOW flag just from moving here and back is quite unexpected.
> >>
> >> david
> > 
> > Yeah, I agree to remove this bad 'change in rename', will send a patch to
> > address it.
> 
> I think we can add a mount option, if the option is set, when we move a file 
> to a new directory, or create a new file, we will inherit the flags of the parent.
> If not set, we inherit the flags only when create a new file.
> How do you think about it?
> 

I'm ok with the option, but...
from some reports on the list, end users are more likely to control, use chattr
files by themselves, inheriting flags via moving a file to a new directory is
indeed not very welcomed.

So for practical use, I assume that it's fairly enough to inherit flags only on
creation?

thanks,
liubo
