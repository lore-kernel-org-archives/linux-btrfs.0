Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:48001 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752092AbdJTKZm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 06:25:42 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Johannes Thumshirn <jthumshirn@suse.de>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "james.bottomley@hansenpartnership.com"
        <james.bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>,
        "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: RE: [PATCH 0/6] v4 block refcount conversion patches
Date: Fri, 20 Oct 2017 10:25:37 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B802B37B3@IRSMSX102.ger.corp.intel.com>
References: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
 <mqdr2typ5uw.fsf@linux-x5ow.site>
In-Reply-To: <mqdr2typ5uw.fsf@linux-x5ow.site>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Elena Reshetova <elena.reshetova@intel.com> writes:
> > Elena Reshetova (6):
> >   block: convert bio.__bi_cnt from atomic_t to refcount_t
> >   block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
> >   block: convert blkcg_gq.refcnt from atomic_t to refcount_t
> >   block: convert io_context.active_ref from atomic_t to refcount_t
> >   block: convert bsg_device.ref_count from atomic_t to refcount_t
> >   drivers, block: convert xen_blkif.refcnt from atomic_t to refcount_t
> 
> Hi Elena,
> 
> While the bsg ref_count is cheap, do you have any numbers how the other
> conversions compare in performance (throughput and latency) vs atomics?
Hi Johannes,

The performance would depend on which "breed" of refcount_t is used underneath. 
We currently have 3 versions:

- refcount_t defaults to atomic_t (no CONFIG_REFCOUNT_FULL enabled, no arch. support)
  Impact is zero in this case since it is just atomic functions are used. 
- refcount_t uses arch. specific implementation (arch. enables ARCH_HAS_REFCOUNT)
 Impact depends on arch. implementation. Currently only x86 provides one. 
- refcount_t uses "full" arch. independent implementation.

Here are cycle numbers for comparing these 3 (https://lwn.net/Articles/728626/):
Just copy pasting for convenience:

">These are the cycle counts comparing a loop of refcount_inc() from 1
>to INT_MAX and back down to 0 (via refcount_dec_and_test()), between
>unprotected refcount_t (atomic_t), fully protected REFCOUNT_FULL
>(refcount_t-full), and this overflow-protected refcount (refcount_t-fast):

>2147483646 refcount_inc()s and 2147483647 refcount_dec_and_test()s:
			cycles	protections
>atomic_t	   82249267387	none
>refcount_t-fast    82211446892	overflow, untested dec-to-zero
>refcount_t-full   144814735193	overflow, untested dec-to-zero, inc-from-zero"

So, the middle option (called here refcount_t-fast) with arch. specific
implementation gives a negligible impact. The "full" one is more pricey, but it is
disabled by default anyway, so only people who want strict security enable it.  

Are these numbers convincing enough that we don't have to measure
the block devices? :)

Best Regards,
Elena.


> 
> It should be quite easy to measure against a null_blk device.
> 
> Thanks a lot,
>        Johannes
> 
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 NÃ¼rnberg
> GF: Felix ImendÃ¶rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG NÃ¼rnberg)
> Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
