From: Ian Kent <raven@themaw.net>
Subject: Re: On Removing BUG_ON macros
Date: Mon, 08 Nov 2010 10:36:10 +0800
Message-ID: <1289183770.3309.13.camel@localhost>
References: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: chris.mason@oracle.com, josef@redhat.com,
	linux-btrfs@vger.kernel.org
To: Yoshinori Sano <yoshinori.sano@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2010-11-07 at 16:16 +0900, Yoshinori Sano wrote:
> This is a question I've posted on the #btrfs IRC channel today.
> hyperair adviced me to contact with Josef Bacik or Chris Mason.
> So, I post my question to this maling list.
> 
> Here are my post on the IRC:
> 
> Actually, I want to remove BUG_ON(ret) around the Btrfs code.
> The motivation is to make the Btrfs code more robust.
> First of all, is this meaningless?

No, it isn't meaningless it's essential that it be fixed, although it is
quite difficult.

The main problem is that while this remains it makes it almost
impossible (at least much more difficult) for those implementing
improvements to avoid perpetuating the problem. 

> 
> For example, there are code like the following:
> 
>     struct btrfs_path *path;
>     path = btrfs_alloc_path();
>     BUG_ON(!path);

Yes, this is quite common but the fact is that there are many other
situations where errors are handled in the same way.

> 
> This is a frequenty used pattern of current Btrfs code.
> A btrfs_alloc_path()'s caller has to deal with the allocation failure
> instead of using BUG_ON.  However, (this is what most interesting
> thing for me) can the caller do any proper error handlings here?
> I mean, is this a critical situation where we cannot recover from?

If you work through the function call tree quite a good number of the
dead end BUG_ON()s can be handled (at least it looks like that to me).
But there are also quite a good number of cases where the recovery
needed isn't yet clear to me. I hope that as I study the code some of
these cases will become apparent to me, failing that I plan to post some
patches with specific questions to see what others have to say.

Ian


