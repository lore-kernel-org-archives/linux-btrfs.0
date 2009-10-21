From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Proper error handling on NULL pointers
Date: Wed, 21 Oct 2009 19:43:51 +0200
Message-ID: <200910211943.51623.diegocg@gmail.com>
References: <200910191236.14046.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
To: Andi Drebes <lists-receive@programmierforen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910191236.14046.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Lunes 19 Octubre 2009 12:36:13 Andi Drebes escribi=C3=B3:
> However, is there any interest in patches fixing these problems? If y=
es: what would be the best strategy? Should we start fixing this "layer=
 by layer" -- the low-level functions first and the high-level function=
s later on? Or should use come kind of "vertical approach" -- one low-l=
evel function and all of its callers at once?

I don't know what is the developer plan to fix that - apparently it's
not in the high-priority list (but it must be certainly in the priority
list, anyone who gets out of memory using btrfs will have some chances =
of
getting an oops - but notice that most of the important paths are ready
to handle errors reliably and there aren't many bug reports due to bad
oom handling, so it doesn't seems to be that critical).

I realized that it isn't really helpful to add BUG_ONs to failed alloca=
tion
paths, the code will oops itself as soon as it tries to use the NULL po=
inter,
so adding BUG_ONs is redundant. Passing the error to the callers and ha=
ndling
all that properly is the real fix, but since it requires auditing the w=
hole FS
it's probably not an easy task. I tried to do that with a couple of fun=
ctions,
but Kleen's mail made me realize that it isn't that easy.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
