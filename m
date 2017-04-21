Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33750 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161813AbdDUQkF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 12:40:05 -0400
Received: by mail-io0-f177.google.com with SMTP id k87so126780551ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 09:40:05 -0700 (PDT)
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
To: Peter Zijlstra <peterz@infradead.org>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org>
 <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
 <20170420183319.GB103004@gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
 <31311853-3554-cefe-1210-2ffae1a20058@kernel.dk>
 <20170421152241.q45w3ckjax5xiddq@hirez.programming.kicks-ass.net>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
        Eric Biggers <ebiggers3@gmail.com>, Kees Cook <keescook@chromium.org>,
        Christoph Hellwig <hch@infradead.org>,
        "james.bottomley@hansenpartnership.com"
        <james.bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>,
        "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <99e3518a-bb1a-cab2-80b8-dd466827b5e6@kernel.dk>
Date: Fri, 21 Apr 2017 10:29:45 -0600
MIME-Version: 1.0
In-Reply-To: <20170421152241.q45w3ckjax5xiddq@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/21/2017 09:22 AM, Peter Zijlstra wrote:
> On Fri, Apr 21, 2017 at 08:03:13AM -0600, Jens Axboe wrote:
>> You have it so easy - the code is completely standalone, building a
>> small test framework around it and measuring performance in _user space_
>> is trivial.
> 
> Something like this you mean:
> 
>   https://lkml.kernel.org/r/20170322165144.dtidvvbxey7w5pbd@hirez.programming.kicks-ass.net

Yes, exactly. But it'd be great to see better coverage of the API, and
various cases of X threads running operations on the same refcount,
so we get a full view of that side too. The above looks like just
counting cycles for a single op of foo_inc().

-- 
Jens Axboe

