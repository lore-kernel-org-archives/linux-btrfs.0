From: Josef Bacik <josef@redhat.com>
Subject: Re: On Removing BUG_ON macros
Date: Sun, 7 Nov 2010 09:51:20 -0500
Message-ID: <20101107145120.GF9728@dhcp231-156.rdu.redhat.com>
References: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, josef@redhat.com,
	linux-btrfs@vger.kernel.org
To: Yoshinori Sano <yoshinori.sano@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 07, 2010 at 04:16:47PM +0900, Yoshinori Sano wrote:
> This is a question I've posted on the #btrfs IRC channel today.
> hyperair adviced me to contact with Josef Bacik or Chris Mason.
> So, I post my question to this maling list.
> 
> Here are my post on the IRC:
> 
> Actually, I want to remove BUG_ON(ret) around the Btrfs code.
> The motivation is to make the Btrfs code more robust.
> First of all, is this meaningless?
> 
> For example, there are code like the following:
> 
>     struct btrfs_path *path;
>     path = btrfs_alloc_path();
>     BUG_ON(!path);
> 
> This is a frequenty used pattern of current Btrfs code.
> A btrfs_alloc_path()'s caller has to deal with the allocation failure
> instead of using BUG_ON.  However, (this is what most interesting
> thing for me) can the caller do any proper error handlings here?
> I mean, is this a critical situation where we cannot recover from?
>

No we're just lazy ;).  Tho making sure the caller can recover from getting
-ENOMEM is very important, which is why in some of these paths we just do BUG_ON
since fixing the callers is tricky.  A good strategy for things like this is to
do something like

static int foo = 1;

path = btrfs_alloc_path();
if (!path || !(foo % 1000))
	return -ENOMEM;
foo++;

that way you can catch all the callers and make sure we're handling the error
all the way up the chain properly.  Thanks,

Josef
