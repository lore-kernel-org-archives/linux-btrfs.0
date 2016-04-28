Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53838 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbcD1QMr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 12:12:47 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1604281157180.6220@file01.intranet.prod.int.rdu2.redhat.com>
References: <1461805789-3632-1-git-send-email-ming.lei@canonical.com>
	<1461805789-3632-3-git-send-email-ming.lei@canonical.com>
	<alpine.LRH.2.02.1604281127130.14065@file01.intranet.prod.int.rdu2.redhat.com>
	<CACVXFVPgPh3snp-B6=G9fShzJwwKz2NyQETSnMJBGp=HzTL_-w@mail.gmail.com>
	<alpine.LRH.2.02.1604281157180.6220@file01.intranet.prod.int.rdu2.redhat.com>
Date: Fri, 29 Apr 2016 00:12:44 +0800
Message-ID: <CACVXFVN7bE3tFs9KVGX-M3LCvOr0WuCMwyoGiW4qu5G4h8EzhA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] block: avoid to call .bi_end_io() recursively
From: Ming Lei <ming.lei@canonical.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Alan Cox <alan@linux.intel.com>, Neil Brown <neilb@suse.de>,
        Liu Bo <bo.li.liu@oracle.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 11:58 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Thu, 28 Apr 2016, Ming Lei wrote:
>
>> Hi Mikulas,
>>
>> On Thu, Apr 28, 2016 at 11:29 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> >
>> >
>> > On Thu, 28 Apr 2016, Ming Lei wrote:
>> >
>> >> There were reports about heavy stack use by recursive calling
>> >> .bi_end_io()([1][2][3]). For example, more than 16K stack is
>> >> consumed in a single bio complete path[3], and in [2] stack
>> >> overflow can be triggered if 20 nested dm-crypt is used.
>> >>
>> >> Also patches[1] [2] [3] were posted for addressing the issue,
>> >> but never be merged. And the idea in these patches is basically
>> >> similar, all serializes the recursive calling of .bi_end_io() by
>> >> percpu list.
>> >>
>> >> This patch still takes the same idea, but uses bio_list to
>> >> implement it, which turns out more simple and the code becomes
>> >> more readable meantime.
>> >>
>> >> One corner case which wasn't covered before is that
>> >> bi_endio() may be scheduled to run in process context(such
>> >> as btrfs), and this patch just bypasses the optimizing for
>> >> that case because one new context should have enough stack space,
>> >> and this approach isn't capable of optimizing it too because
>> >> there isn't easy way to get a per-task linked list head.
>> >
>> > Hi
>> >
>> > You could use preempt_disable() and then you could use per-cpu list even
>> > in the process context.
>>
>> Image why the .bi_end_io() is scheduled to process context, and the only
>> workable/simple way I thought of is to use per-task list because it may sleep.
>
> The bi_end_io callback should not sleep, even if it is called from the
> process context.

If it shouldn't sleep, why is it scheduled to run in process context by paying
extra context switch cost?

And you can find that btrfs_subio_endio_read() does sleep for checksum stuff.

Thanks,
Ming

>
>> Given new context should have enough stack and only btrfs has this kind of
>> usage as far as I see, so don't think that is worth of the optimization.
>>
>> Thanks,
>> Ming
>
> Mikulas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
