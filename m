Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbcEJIVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 04:21:52 -0400
Date: Tue, 10 May 2016 10:21:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: switch to common message helpers in open_ctree,
 adjust messages
Message-ID: <20160510082120.GQ29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462786798-15247-1-git-send-email-dsterba@suse.com>
 <573148AB.6080800@oracle.com>
 <20160510074203.GP29353@twin.jikos.cz>
 <57319541.7000300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57319541.7000300@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 04:01:05PM +0800, Anand Jain wrote:
> > In more detail:
> >
> > * introduce _btrfs_printk that takes a string pointer as 1st argument
> >    (this could be used for messages before fs_info exists)
> > * _btrfs_printk(NULL, ...) will be valid
> > * then btrfs_printk(fs_info, ...) will become a wrapper
> >    _btrfs_printk(btrfs_sb(fs_info)->s_id, ...)
> > * _btrfs_err & others do not need to be introduced, we can use the
> >    standard KERN_ERR
> 
>   Does it mean logs when fs_info is not available won't have fsid ?

Right, we don't have fsid until we read the superblock from disk
(somewhere in open_ctree).

>   Except for the logs in the context such as modload.. which does not
>   involve a disk. Consistency in logging would help. Like fishing-out
>   all logs related to a FSID.

Yeah, this is probably related to your patches switching the messages to
print fsid instead of device. Consistency is desirable of course, though
we might need to make the output style configurable.
