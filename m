Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:30315 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757276AbaISRY3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 13:24:29 -0400
Date: Fri, 19 Sep 2014 13:21:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Return a value from printk_ratelimited
Message-ID: <20140919132123.418b276f@gandalf.local.home>
In-Reply-To: <3629aa32fd3e434e41e5e5f4a97ab50adb8edcdc.1411116672.git.osandov@osandov.com>
References: <cover.1411116672.git.osandov@osandov.com>
	<3629aa32fd3e434e41e5e5f4a97ab50adb8edcdc.1411116672.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 Sep 2014 02:01:29 -0700
Omar Sandoval <osandov@osandov.com> wrote:

> printk returns an integer; there's no reason for printk_ratelimited to swallow
> it.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  include/linux/printk.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index d78125f..67534bc 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -343,12 +343,14 @@ extern asmlinkage void dump_stack(void) __cold;
>  #ifdef CONFIG_PRINTK
>  #define printk_ratelimited(fmt, ...)					\
>  ({									\
> +	int __ret = 0;							\

My only issues is with the "__ret" name.

It's not really unique enough. If something else uses __ret and does

  printk_ratelimit("some fmt string %d\n", __ret);

This will not print the right value.

printk_ratelimit can be used almost anywhere thus using a really unique
value may be worth while here.

What about:

  int ______r

?

-- Steve

>  	static DEFINE_RATELIMIT_STATE(_rs,				\
>  				      DEFAULT_RATELIMIT_INTERVAL,	\
>  				      DEFAULT_RATELIMIT_BURST);		\
>  									\
>  	if (__ratelimit(&_rs))						\
> -		printk(fmt, ##__VA_ARGS__);				\
> +		__ret = printk(fmt, ##__VA_ARGS__);			\
> +	__ret;								\
>  })
>  #else
>  #define printk_ratelimited(fmt, ...)					\

