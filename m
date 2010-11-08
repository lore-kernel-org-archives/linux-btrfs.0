From: Josef Bacik <josef@redhat.com>
Subject: Re: On Removing BUG_ON macros
Date: Mon, 8 Nov 2010 08:28:44 -0500
Message-ID: <20101108132844.GA2515@localhost.localdomain>
References: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com> <20101107145120.GF9728@dhcp231-156.rdu.redhat.com> <AANLkTinjy4HDf+74uTLo+zVqM0WqsvZUMjgw7Hv+jdLN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: josef@redhat.com, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Yoshinori Sano <yoshinori.sano@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinjy4HDf+74uTLo+zVqM0WqsvZUMjgw7Hv+jdLN@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 08, 2010 at 10:17:50PM +0900, Yoshinori Sano wrote:
> To reduce the number of such BUG_ON usages, the code will be more robust,
> which results in increasing the number of Btrfs production use.
> (This is one of the way, off course.)
> 
> But, as you pointed out, removing such BUG_ONs is tricky...
> 
> > static int foo = 1;
> >
> > path = btrfs_alloc_path();
> > if (!path || !(foo % 1000))
> >        return -ENOMEM;
> > foo++;
> 
> Is this a debugging idiom?
> I cannot understand why this idiom can be used to catch all the callers.
> Would you explain more about it?
> 

So this forces us to return the error case every 1000 times the function is
called.  So you can run various tests that stress the FS in different ways so
you can catch alot of the possible ways you can end up in this function.  Then
if any of the callers have problems getting ENOMEM then the box will panic or
something like that and you can fix the callers.  Then when the system stops
panicing/blowing up after a while you know you are pretty OK with returning
ENOMEM in this case and you can post the patch and move on to the next one.

But as Ian says it gets a little confusing in the more complicated cases, so you
are probably better off walking up the possible callchains by hand and fixing
any problems you see, and then doing the above to validate your work.  Thanks,

Josef
