From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: Re: On Removing BUG_ON macros
Date: Mon, 8 Nov 2010 22:17:50 +0900
Message-ID: <AANLkTinjy4HDf+74uTLo+zVqM0WqsvZUMjgw7Hv+jdLN@mail.gmail.com>
References: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com>
	<20101107145120.GF9728@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101107145120.GF9728@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

To reduce the number of such BUG_ON usages, the code will be more robust,
which results in increasing the number of Btrfs production use.
(This is one of the way, off course.)

But, as you pointed out, removing such BUG_ONs is tricky...

> static int foo = 1;
>
> path = btrfs_alloc_path();
> if (!path || !(foo % 1000))
>        return -ENOMEM;
> foo++;

Is this a debugging idiom?
I cannot understand why this idiom can be used to catch all the callers.
Would you explain more about it?

Thank you,

-- 
Yoshinori Sano <yoshinori.sano@gmail.com>
