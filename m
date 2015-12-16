Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbbLPOAr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 09:00:47 -0500
Date: Wed, 16 Dec 2015 14:58:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
Message-ID: <20151216135840.GS4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz>
 <5670C017.5010104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5670C017.5010104@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 16, 2015 at 09:36:23AM +0800, Qu Wenruo wrote:
> >
> >   mount -o ro,nowr /dev/sdx /mnt
> >
> > would work when switching kernels.
> >
> That would be nice.
> 
> I'd like to forward the idea/discussion to filesystem ml, not only btrfs 
> maillist.

Good idea.

> Such behavior should better be coordinated between all(at least xfs and 
> ext4 and btrfs) filesystems.
> 
> One sad example is, we can't use 'norecovery' mount option to disable 
> log replay in btrfs, as there is 'recovery' mount option already.

I think we should pick a name that's not tied to the implementation how
the potential writes could happen under a RO mount.
Recovery/replay/whatever, the expected use is "avoid any writes".

> So I hope we can have a unified mount option between mainline filesystems.

That would be a good thing indeed.
