Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751165AbeDEOHF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 10:07:05 -0400
Date: Thu, 5 Apr 2018 16:04:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/16] btrfs: move clearing of EXCL_OP out of
 __cancel_balance
Message-ID: <20180405140435.GC2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1522780026.git.dsterba@suse.com>
 <ee98f1c7110273148101478e302de3783e7b8a3b.1522780026.git.dsterba@suse.com>
 <0ba1d0f6-0fd8-dd26-9efa-23a22a55226f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <0ba1d0f6-0fd8-dd26-9efa-23a22a55226f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2018 at 05:42:14PM +0800, Anand Jain wrote:
> 
> 
> > @@ -3926,11 +3925,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
> >   	return ret;
> >   out:
> >   	if (bctl->flags & BTRFS_BALANCE_RESUME)
> > -		__cancel_balance(fs_info);
> > -	else {
> > +		reset_balance_state(fs_info);
> 
>   reset_balance_state() is something unrelated. More over compile fails 
> at this patch.
> 
> ----
> fs/btrfs/volumes.c: In function ‘btrfs_balance’:
> fs/btrfs/volumes.c:3928:3: error: implicit declaration of function 
> ‘reset_balance_state’; did you mean ‘insert_balance_item’? 
> [-Werror=implicit-function-declaration]
>     reset_balance_state(fs_info);

Right, it looks like a misapplied fixup for patch "btrfs: cleanup
helpers that reset balance state" that's farther in the series. Will
fix.
