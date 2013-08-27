Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36770 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3H0Nri (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 09:47:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1BBBC9A06AB
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 07:47:38 -0600 (MDT)
Date: Tue, 27 Aug 2013 09:47:36 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: add support for asserts
Message-ID: <20130827134736.GJ29654@localhost.localdomain>
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
 <20130826215326.GH26818@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130826215326.GH26818@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 26, 2013 at 02:53:26PM -0700, Zach Brown wrote:
> > With this we can
> > go through and convert any BUG_ON()'s that we have to catch actual programming
> > mistakes to the new ASSERT() and then fix everybody else to return errors.
> 
> I like the sound of that!
> 
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -3814,6 +3814,22 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
> >  #define btrfs_debug(fs_info, fmt, args...) \
> >  	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
> >  
> > +#ifdef BTRFS_ASSERT
> > +
> > +static inline void assfail(char *expr, char *file, int lin)
> > +{
> > +	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
> > +	       expr, file, line);
> > +	BUG();
> > +}
> 
> I'm not sure why this is needed.
> 
> > +#define ASSERT(expr)	\
> > +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> 
> (Passing the assertion is unlikely()?  I know, this is from xfs...
> still.)
>

Yeah I copy+pasted and then thought about it after I sent it.  I will fix it up.
 
> > +#else
> > +#define ASSERT(expr)	((void)0)
> > +#endif
> 
> Anyway, if you're going to do it this way, why not:
> 
> 	#ifdef BTRFS_ASSERT
> 	#define btrfs_assert(cond)  BUG_ON(!(cond))
> 	#else
> 	#define btrfs_assert(cond)  do { if (cond) ; } while (0)
> 	#endif
>

I like the verbosity, especially with random kernel versions and such, it will
help me figure out where we BUG_ON()'ed without having to checkout a particular
version and go hunting.  Thanks,

Josef 
