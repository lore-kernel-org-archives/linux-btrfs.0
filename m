Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34524 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3KEKkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 05:40:32 -0500
Date: Tue, 5 Nov 2013 12:40:16 +0200
From: Aldo Iljazi <mail@aldo.io>
To: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FS: BTRFS: fixed coding style issues
Message-ID: <20131105104016.GA24096@linux>
References: <1383571658-7440-1-git-send-email-mail@aldo.io>
 <20131105102859.GC16662@twin.jikos.cz>
 <20131105103237.GA23961@linux>
 <20131105103652.GD16662@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131105103652.GD16662@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 David Sterba wrote:

> On Tue, Nov 05, 2013 at 12:32:37PM +0200, Aldo Iljazi wrote:
> >  David Sterba wrote:
> > 
> > > On Mon, Nov 04, 2013 at 03:27:38PM +0200, Aldo Iljazi wrote:
> > > > Fixed three coding style issues. Replaced spaces with tabs.
> > > > 
> > > > Signed-off-by: Aldo Iljazi <mail@aldo.io>
> > > > ---
> > > >  fs/btrfs/dev-replace.c | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> > > > index 9efb94e..b2fe609 100644
> > > > --- a/fs/btrfs/dev-replace.c
> > > > +++ b/fs/btrfs/dev-replace.c
> > > > @@ -377,7 +377,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
> > > >  	printk_in_rcu(KERN_INFO
> > > >  		      "btrfs: dev_replace from %s (devid %llu) to %s) started\n",
> > > >  		      src_device->missing ? "<missing disk>" :
> > > > -		        rcu_str_deref(src_device->name),
> > > > +			rcu_str_deref(src_device->name),
> > > 
> > > What's the change here? I don't think we need to fix whitespace, this makes
> > > searching in patch history more tedious, namely in case where the code looks
> > > exactly the same before and after the patch.
> > > 
> > > The style issues should be best fixed when the patch is about to be
> > > merged, doing it later like this is kind of not welcome, speaking for
> > > myself. There are lots of opportunities to do real code cleanups.
> > > 
> > > Whitespace changes are just noise, we don't need them at this point of
> > > development phase of btrfs.
> > > 
> > > 
> > > david
> > 
> > I replaced the spaces with tabs, as the kernel coding style suggests.
> 
> I repeat:
> 
> Whitespace changes are just noise, we don't need them at this point of
> development phase of btrfs.
> 
> david

Okay then ignore the patch.
-- 
Aldo Iljazi
