From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: Re: [PATCH] Don't exist from cleaner_kthread and transaction_kthread
	until kthread_should_stop is true
Date: Fri, 4 Sep 2009 09:11:51 +0900
Message-ID: <2014bcab0909031711k64c0ff21jaffb15c4a405c6a5@mail.gmail.com>
References: <2014bcab0909030312i73f6cccfib1e612da0501cfc6@mail.gmail.com>
	 <2014bcab0909031706y5d3397f9nd14fc1000c8b8aaf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2014bcab0909031706y5d3397f9nd14fc1000c8b8aaf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

However, it seems that the kthread_stop() patch is not yet applied.
Linux 2.6.30.5 still use the order one.

On Fri, Sep 4, 2009 at 9:06 AM, =ED=99=8D=EC=8B=A0 shin hong<hongshin@g=
mail.com> wrote:
> However, Vitaily Gusev notice me that kthread_stop() has been changed
> recently so that it may executed for threads which was existed.
> (commit =C2=A063706172f332fd3f6e7458ebfb35fa6de9c21dc5
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kthreads: rework kthr=
ead_stop())
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
