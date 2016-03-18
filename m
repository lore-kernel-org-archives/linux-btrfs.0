Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbcCRPDb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 11:03:31 -0400
Date: Fri, 18 Mar 2016 16:03:03 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add stat check in open_ctree_fs_info
Message-ID: <20160318150303.GZ21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458141971-56355-1-git-send-email-ahferroin7@gmail.com>
 <56EA7314.2080104@cn.fujitsu.com>
 <56EA935C.1040408@gmail.com>
 <56EB4E09.6090703@cn.fujitsu.com>
 <56EBE3C1.6060009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56EBE3C1.6060009@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2016 at 07:17:21AM -0400, Austin S. Hemmelgarn wrote:
> >>> This one seems to be too restrict.
> >>>
> >>> I prefer to block char/pipe/dir and some other obvious wrong ones other
> >>> than only allowing regular and block ones.
> >> Running against a directory gives a cryptic error about the superblock
> >> having bad info.  Running against a pipe is nonsensical, as it can't
> >> contain a filesystem.  Running against a character device is potentially
> >> dangerous (read operations are not guaranteed to be idempotent on
> >> character devices, depending on what hardware it is connected to, you
> >> could cause all kinds of odd things to happen).
> >>
> >> Everything this function gets called on is trying to get info from a
> >> unmounted filesystem image, which means that it only makes sense to try
> >> to parse things that can contain a unmounted filesystem image.
> >
> > Yes, I understand what you are doing.
> >
> > Just as I alreayd mentioned, the problem is, your current patch only
> > allowing regular and block device and will block valid soft link.
> > Just as Duncan mentioned, soft link should be allowed too.
> Symbolic links are allowed though.  stat(2) follows symlinks and returns 
> information on their target, not the link itself.  I also tested it on 
> symlinks, and it still works to run `btrfs check` on a link to a block 
> device containing a BTRFS filesystem
> >
> > I mean to *block/prevent* char/pipe/dir instead of *only allowing*
> > regular/block device.
> I apologize for the misunderstanding, I misread your original message.
> 
> As to blacklisting invalid types instead of whitelisting valid ones, I'd 
> personally would prefer whitelisting in this particular case, as it 
> results in both a smaller conditional, and makes the intent of only 
> allowing things that can contain a BTRFS filesystem  more clear (at 
> least, it does to me).

I agree with your reasoning.
