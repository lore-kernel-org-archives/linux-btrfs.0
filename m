Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49141 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752146AbdJTInH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 04:43:07 -0400
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com, keescook@chromium.org
Subject: Re: [PATCH 0/6] v4 block refcount conversion patches
In-Reply-To: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
        (Elena Reshetova's message of "Fri, 20 Oct 2017 11:15:56 +0300")
References: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
Date: Fri, 20 Oct 2017 10:43:03 +0200
Message-ID: <mqdr2typ5uw.fsf@linux-x5ow.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Elena Reshetova <elena.reshetova@intel.com> writes:
> Elena Reshetova (6):
>   block: convert bio.__bi_cnt from atomic_t to refcount_t
>   block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
>   block: convert blkcg_gq.refcnt from atomic_t to refcount_t
>   block: convert io_context.active_ref from atomic_t to refcount_t
>   block: convert bsg_device.ref_count from atomic_t to refcount_t
>   drivers, block: convert xen_blkif.refcnt from atomic_t to refcount_t

Hi Elena,

While the bsg ref_count is cheap, do you have any numbers how the other
conversions compare in performance (throughput and latency) vs atomics?

It should be quite easy to measure against a null_blk device.

Thanks a lot,
       Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
