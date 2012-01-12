From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 16/21] Btrfs: recover balance on mount
Date: Thu, 12 Jan 2012 16:29:48 +0200
Message-ID: <20120112142948.GA26924@zambezi.lan>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
 <1325860269-15013-17-git-send-email-idryomov@gmail.com>
 <20120112140031.GZ7322@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120112140031.GZ7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2012 at 03:00:31PM +0100, David Sterba wrote:
> On Fri, Jan 06, 2012 at 04:31:04PM +0200, Ilya Dryomov wrote:
> > +static int restriper_kthread(void *data)
> 
> you've changed restripe -> balance in some places, I'm not sure if you
> want to distinguish them sometimes, like the kthread worker name here
> 
> > +{
> ...
> > +}
> > +
> > +int btrfs_recover_balance(struct btrfs_root *tree_root)
> > +{
> ...
> > +	btrfs_balance_data(leaf, item, &disk_bargs);
> > +	btrfs_disk_balance_args_to_cpu(&bctl->data, &disk_bargs);
> > +	btrfs_balance_meta(leaf, item, &disk_bargs);
> > +	btrfs_disk_balance_args_to_cpu(&bctl->meta, &disk_bargs);
> > +	btrfs_balance_sys(leaf, item, &disk_bargs);
> > +	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
> > +
> > +	tsk = kthread_run(restriper_kthread, bctl, "btrfs-restriper");
> 
> or process name here.
> 
> Nothing serious, I noticed this while diffing the previous version.

I'll change it to btrfs-balance and balance_kthread.  Thanks for
reviewing!

		Ilya

