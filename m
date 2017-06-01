Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751078AbdFAO0E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 10:26:04 -0400
Date: Thu, 1 Jun 2017 16:25:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: replace opencoded kvzalloc with the helper
Message-ID: <20170601142501.GE12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496252765.git.dsterba@suse.com>
 <002ad26cc203ff949f1da74733766e20f9111b94.1496252765.git.dsterba@suse.com>
 <abbc29d6-eff6-7a9d-4361-9c67249307a6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <abbc29d6-eff6-7a9d-4361-9c67249307a6@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 01, 2017 at 04:04:47PM +0800, Anand Jain wrote:
> 
> 
> 
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index e8185c83f667..924b1d941b53 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -6389,13 +6389,10 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
> >
> >  	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
> >
> > -	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
> > +	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL);
> 
> 
>   Should be kvzalloc ?

Of course, I'll fix it. Thanks.
