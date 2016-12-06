Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34503 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbcLFIg4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 03:36:56 -0500
Date: Tue, 6 Dec 2016 09:36:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161206083651.GB13195@gmail.com>
References: <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
 <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
 <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
 <CA+55aFxeWe2VQaW30qGR0syiZ75jSwFwg3Ac+wS20KDtf5UKNw@mail.gmail.com>
 <CAOMGZ=Eb8mw6CfGaruM-tRir7pWn78vLTaCqp1pGPqkagfzPPA@mail.gmail.com>
 <CA+55aFzEG-6pkJXy4itiXsHPu_VV5q2vd6zJLq6vmi=AzdnaUw@mail.gmail.com>
 <CA+55aFwC3nfmum6oPoBRU325CKjK-g3MuqW+bhq3+9DnE_4fgw@mail.gmail.com>
 <20161206081659.GV3092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161206081659.GV3092@twins.programming.kicks-ass.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


* Peter Zijlstra <peterz@infradead.org> wrote:

> $ git grep DECLARE_WAIT_QUEUE_HEAD_ONSTACK | wc -l
> 28

This debug facility looks sensible. A couple of minor suggestions:

> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -39,6 +39,9 @@ struct wait_bit_queue {
>  struct __wait_queue_head {
>  	spinlock_t		lock;
>  	struct list_head	task_list;
> +#ifdef CONFIG_DEBUG_WAITQUEUE
> +	int			onstack;
> +#endif

The structure will pack better in the debug-enabled case if 'onstack' is next to 
'lock', as spinlock_t is 4 bytes on many architectures.

> -#define __WAIT_QUEUE_HEAD_INITIALIZER(name) {				\
> +#ifdef CONFIG_DEBUG_WAITQUEUE
> +#define ___WAIT_QUEUE_ONSTACK(onstack)	.onstack = (onstack),
> +#else
> +#define ___WAIT_QUEUE_ONSTACK(onstack)
> +#endif

Please help readers by showing the internal structure of the definition:

#ifdef CONFIG_DEBUG_WAITQUEUE
# define ___WAIT_QUEUE_ONSTACK(onstack)	.onstack = (onstack),
#else
# define ___WAIT_QUEUE_ONSTACK(onstack)
#endif


> +static inline void prepare_debug(wait_queue_head_t *q, wait_queue_t *wait)
> +{
> +#ifdef CONFIG_DEBUG_WAITQUEUE
> +	WARN_ON_ONCE(q->onstack && wait->func == autoremove_wake_function)
> +#endif
> +}

I'd name this debug_waitqueue_check() or such - as the 'prepare' is a bit 
misleadig (we don't prepare debugging, we do the debug check here).

> +config DEBUG_WAITQUEUE
> +	bool "Debug waitqueue"
> +	depends on DEBUG_KERNEL

I'd name it DEBUG_SCHED_WAITQUEUE=y and I'd also make it depend on 
CONFIG_DEBUG_SCHED.

LGTM otherwise!

Thanks,

	Ingo
