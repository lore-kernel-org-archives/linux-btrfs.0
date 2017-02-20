Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36139 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbdBTPQe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 10:16:34 -0500
Received: by mail-it0-f41.google.com with SMTP id h10so71974448ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 07:15:23 -0800 (PST)
Subject: Re: [PATCH 0/5] block subsystem refcounter conversions
To: Elena Reshetova <elena.reshetova@intel.com>, linux-kernel@vger.kernel.org
References: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org, peterz@infradead.org,
        gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp,
        mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5fd906c2-61ba-319c-1bc2-cb48b2b378b4@kernel.dk>
Date: Mon, 20 Feb 2017 08:15:21 -0700
MIME-Version: 1.0
In-Reply-To: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2017 04:16 AM, Elena Reshetova wrote:
> Now when new refcount_t type and API are finally merged
> (see include/linux/refcount.h), the following
> patches convert various refcounters in the block susystem from atomic_t
> to refcount_t. By doing this we prevent intentional or accidental
> underflows or overflows that can led to use-after-free vulnerabilities.
> 
> The below patches are fully independent and can be cherry-picked separately.
> Since we convert all kernel subsystems in the same fashion, resulting
> in about 300 patches, we have to group them for sending at least in some
> fashion to be manageable. Please excuse the long cc list.
> 
> Elena Reshetova (5):
>   block: convert bio.__bi_cnt from atomic_t to refcount_t
>   block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
>   block: convert blkcg_gq.refcnt from atomic_t to refcount_t
>   block: convert io_context.active_ref from atomic_t to refcount_t
>   block: convert bsg_device.ref_count from atomic_t to refcount_t

I went to look at the implementation, and the size of a refcount_t.
But the code is not there?! You say it's finally merged, where is
it merged? Don't send code like this without the necessary
infrastructure being in mainline.

-- 
Jens Axboe

