Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36526 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040255AbdDUODQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 10:03:16 -0400
Received: by mail-qt0-f169.google.com with SMTP id g60so70339886qtd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 07:03:16 -0700 (PDT)
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
        Eric Biggers <ebiggers3@gmail.com>, Kees Cook <keescook@chromium.org>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org>
 <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
 <20170420183319.GB103004@gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
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
        "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <31311853-3554-cefe-1210-2ffae1a20058@kernel.dk>
Date: Fri, 21 Apr 2017 08:03:13 -0600
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/21/2017 04:55 AM, Reshetova, Elena wrote:
>>>> Please don't send any more conversions until those have been resolved.
>>
>> Like I suggested months ago, how about doing an efficient implementation of
>> refcount_t which doesn't use the bloated cmpxchg loop?  Then there would be
>> no
>> need for endless performance arguments.  In fact, in PaX there are already
>> example implementations for several architectures.  It's unfortunate that
>> they're still being ignored for some reason.
> 
> Providing efficient arch. specific implementation for refcount_t is
> likely the next step to make performance-sensitive places happy.
> However, in order to do it, we will need to measure for each subsystem
> a) current atomic_t usage - base measurement 
> b) pure refcount_t usage impact
> c) arch. specific refcount_t impact 

> Otherwise I have a chicken and egg problem here: people want better
> performance and want to see arch. specific code for this, but in order
> to convince maintainer in need of arch. specific code, I need to show
> that we do have indeed a performance issue. 

Sorry, but that's a big load of...

You have it so easy - the code is completely standalone, building a
small test framework around it and measuring performance in _user space_
is trivial. Don't go around benchmarking conversions in specific
subsystems. Generate numbers showing how refcount_t compares to atomic_t
for various (valid) use cases.

Once you have that, convincing people to adopt it would be so much
easier. So stop talking about excuses, and start producing some numbers.
If you can't do that, my level of interest in converting anything in
block is zero.

-- 
Jens Axboe

