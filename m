From: Ian Kent <raven@themaw.net>
Subject: Re: On Removing BUG_ON macros
Date: Mon, 08 Nov 2010 10:54:07 +0800
Message-ID: <1289184847.3309.26.camel@localhost>
References: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com>
	 <20101107145120.GF9728@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Yoshinori Sano <yoshinori.sano@gmail.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101107145120.GF9728@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2010-11-07 at 09:51 -0500, Josef Bacik wrote:
> On Sun, Nov 07, 2010 at 04:16:47PM +0900, Yoshinori Sano wrote:
> > This is a question I've posted on the #btrfs IRC channel today.
> > hyperair adviced me to contact with Josef Bacik or Chris Mason.
> > So, I post my question to this maling list.
> > 
> > Here are my post on the IRC:
> > 
> > Actually, I want to remove BUG_ON(ret) around the Btrfs code.
> > The motivation is to make the Btrfs code more robust.
> > First of all, is this meaningless?
> > 
> > For example, there are code like the following:
> > 
> >     struct btrfs_path *path;
> >     path = btrfs_alloc_path();
> >     BUG_ON(!path);
> > 
> > This is a frequenty used pattern of current Btrfs code.
> > A btrfs_alloc_path()'s caller has to deal with the allocation failure
> > instead of using BUG_ON.  However, (this is what most interesting
> > thing for me) can the caller do any proper error handlings here?
> > I mean, is this a critical situation where we cannot recover from?
> >
> 
> No we're just lazy ;).  Tho making sure the caller can recover from getting
> -ENOMEM is very important, which is why in some of these paths we just do BUG_ON
> since fixing the callers is tricky.  A good strategy for things like this is to
> do something like
> 
> static int foo = 1;
> 
> path = btrfs_alloc_path();
> if (!path || !(foo % 1000))
> 	return -ENOMEM;
> foo++;

Hahaha, I love it.

So, return ENOMEM every 1000 times we call the containing function!

> 
> that way you can catch all the callers and make sure we're handling the error
> all the way up the chain properly.  Thanks,

Yeah, I suspect this approach will be a bit confusing though.

I believe that it will be more effective, although time consuming, to
work through the call tree function by function. Although, as I have
said, the problem is working out what needs to be done to recover,
rather than working out what the callers are. I'm not at all sure yet
but I also suspect that it may not be possible to recover in some cases,
which will likely lead to serious rework of some subsystems (but, hey,
who am I to say, I really don't have any clue yet).

Ian


