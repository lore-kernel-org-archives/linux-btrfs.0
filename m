Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaAMSlM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 13:41:12 -0500
Date: Mon, 13 Jan 2014 19:40:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Btrfs: fix wrong send_in_progress accounting
Message-ID: <20140113184024.GT6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20140108121609.GF6498@suse.cz>
 <FBF55D09-2D04-4ACF-A159-2DDD3D896C3A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <FBF55D09-2D04-4ACF-A159-2DDD3D896C3A@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 08, 2014 at 11:09:02PM +0800, Wang Shilong wrote:
> 
> Hello David,
> 
> > On Tue, Jan 07, 2014 at 05:25:18PM +0800, Wang Shilong wrote:
> >> Steps to reproduce:
> >> # mkfs.btrfs -f /dev/sda8
> >> # mount /dev/sda8 /mnt
> >> # btrfs sub snapshot -r /mnt /mnt/snap1
> >> # btrfs sub snapshot -r /mnt /mnt/snap2
> >> # btrfs send /mnt/snap1 -p /mnt/snap2 -f /mnt/1
> >> # dmesg
> >> 
> >> The problem is that we will sort clone roots(include @send_root), it
> >> might push @send_root before thus @send_root's @send_in_progress will
> >> be decreased twice.
> > 
> > Of course, the sort(). I think your fix adds some complexity that's not
> > necessary. Whether the clone_roots array is sorted is not important, we
> > just have to process each root once.
> > 
> > send_root becomes a clone_root member, so the missing part is to account
> > in the rollback counter:
> > 
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -4937,6 +4937,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
> >         * for possible clone sources.
> >         */
> >        sctx->clone_roots[sctx->clone_roots_cnt++].root = sctx->send_root;
> > +       clone_sources_to_rollback++;
> 
> Not really, If we fail to come here, we still need decrease @send_root.

Right. I was thinking if the code can be simplified somehow, but don't
have anything vastly better. Can you please add a comment to the first
branch that send_root is processed in the loop and not missed? It looks
unabalanced when it's handled just a few lines below and not in the 1st
loop.

thanks,
david
