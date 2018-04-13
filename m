Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48649 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754131AbeDMNSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 09:18:11 -0400
Date: Fri, 13 Apr 2018 15:15:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 11/16] btrfs: kill btrfs_fs_info::volume_mutex
Message-ID: <20180413131541.GN21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1522780026.git.dsterba@suse.com>
 <773c3cb3c347d102718975831837e8eb7e9f30ad.1522780026.git.dsterba@suse.com>
 <aca80fac-b712-f0c6-a35a-3cd70be6884f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aca80fac-b712-f0c6-a35a-3cd70be6884f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2018 at 01:30:22PM +0800, Anand Jain wrote:
> 
> 
> > @@ -4569,8 +4560,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
> >   		/* this is either (2) or (3) */
> >   		if (!atomic_read(&fs_info->balance_running)) {
> >   			mutex_unlock(&fs_info->balance_mutex);
> > -			if (!mutex_trylock(&fs_info->volume_mutex))
> > -				goto again;
> 
> 
> > +			/*
> > +			 * Lock released to allow other waiters to continue,
> > +			 * we'll reexamine the status again.
> > +			 */
> 
>   I wonder if there was any case where performing the unlock and lock
>   sequence on the balance_mutex has helped?

It might help in cases something is waiting on the balance mutex, like
reading status, calling pause in parallel, but I doubt that it has some
significant impact.

>   Otherwise IMO we can clean this up as well. It looks like this sequence
>   was needed only to acquire the volume_mutex.

Agreed and I probably had removed in some early versions of the patch,
but this needs to be considered separately from volume_mutex so this
patch preserves the code though it's likely not needed.
