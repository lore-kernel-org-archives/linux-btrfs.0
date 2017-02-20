Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34905 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753249AbdBTPv4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 10:51:56 -0500
Received: by mail-io0-f179.google.com with SMTP id j18so28613242ioe.2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 07:51:56 -0800 (PST)
Subject: Re: [PATCH 0/5] block subsystem refcounter conversions
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-kernel@vger.kernel.org
References: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
 <5fd906c2-61ba-319c-1bc2-cb48b2b378b4@kernel.dk>
 <1487605261.2337.4.camel@HansenPartnership.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org, peterz@infradead.org,
        gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp,
        mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ac578f17-e398-7a86-6bfc-dbac6f64e1df@kernel.dk>
Date: Mon, 20 Feb 2017 08:44:05 -0700
MIME-Version: 1.0
In-Reply-To: <1487605261.2337.4.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2017 08:41 AM, James Bottomley wrote:
> On Mon, 2017-02-20 at 08:15 -0700, Jens Axboe wrote:
>> On 02/20/2017 04:16 AM, Elena Reshetova wrote:
>>> Now when new refcount_t type and API are finally merged
>>> (see include/linux/refcount.h), the following
>>> patches convert various refcounters in the block susystem from 
>>> atomic_t to refcount_t. By doing this we prevent intentional or 
>>> accidental underflows or overflows that can led to use-after-free
>>> vulnerabilities.
> 
> This description isn't right ... nothing is prevented; we get warnings
> on saturation and use after free with this.
> 
>>> The below patches are fully independent and can be cherry-picked 
>>> separately. Since we convert all kernel subsystems in the same 
>>> fashion, resulting in about 300 patches, we have to group them for 
>>> sending at least in some fashion to be manageable. Please excuse
>>> the long cc list.
>>>
>>> Elena Reshetova (5):
>>>   block: convert bio.__bi_cnt from atomic_t to refcount_t
>>>   block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
>>>   block: convert blkcg_gq.refcnt from atomic_t to refcount_t
>>>   block: convert io_context.active_ref from atomic_t to refcount_t
>>>   block: convert bsg_device.ref_count from atomic_t to refcount_t
>>
>> I went to look at the implementation, and the size of a refcount_t.
>> But the code is not there?! You say it's finally merged, where is
>> it merged? Don't send code like this without the necessary
>> infrastructure being in mainline.
> 
> It's one of those no discussion except notice by tipbot things because
> Ingo liked it.
> 
> The size is atomic_t, but the primitives check for overflow and check
> inc from zero and things, so in a true refcounting situation we get
> automatic warnings of problems inside the primitives.
> 
> That said, if we were going to convert the block layer to this
> semantic, surely the benefit of the conversion would be getting rid of
> the now unnecessary BUG_ON and WARN_ON in the code, which do exactly
> the same thing the refcount primitives now do?

Well, I have no idea what it does, which is why I went to look at the
code. So any talk of converting the block layer is premature.  But it's
not there. I'll defer judgment until we have something in mainline,
until then I've archived this thread.

And I agree, keeping warn/bug for cases that should be handled
with this framework would be counter productive and pointless.

-- 
Jens Axboe

