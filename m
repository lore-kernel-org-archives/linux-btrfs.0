Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56544 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdF2HiJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 03:38:09 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        Ingo Molnar <mingo@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: RE: [PATCH 0/5] v3 block subsystem refcounter conversions
Date: Thu, 29 Jun 2017 07:38:04 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B6FF1F012@IRSMSX102.ger.corp.intel.com>
References: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
 <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
 <CAGXu5jJeTAoy1mh1qy0reP_H=u8D86AN=Aj7G6k2cafz76+8NA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B6FF1DA36@IRSMSX102.ger.corp.intel.com>
 <22e0adc4-3c02-e1f8-9017-213b50fdb8a8@kernel.dk>
In-Reply-To: <22e0adc4-3c02-e1f8-9017-213b50fdb8a8@kernel.dk>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 06/28/2017 05:58 AM, Reshetova, Elena wrote:
> >
> >> Subject: Re: [PATCH 0/5] v3 block subsystem refcounter conversions
> >>
> >> On Tue, Jun 27, 2017 at 6:26 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>> On 06/27/2017 05:39 AM, Elena Reshetova wrote:
> >>>> Changes in v3:
> >>>> No changes in patches apart from trivial rebases, but now by
> >>>> default refcount_t = atomic_t and uses all atomic standard operations
> >>>> unless CONFIG_REFCOUNT_FULL is enabled. This is a compromize for the
> >>>> systems that are critical on performance and cannot accept even
> >>>> slight delay on the refcounter operations.
> >>>
> >>> Is that true in 4.12-rc, or is that true in a later release once
> >>> Linus has pulled those changes in? If the latter, please resend
> >>> this when those changes are in, thanks.
> >>
> >> It's in -next currently ("locking/refcount: Create unchecked atomic_t
> >> implementation")
> >
> > I would really like to start discussion on the these patches asap
> > since it normally takes some adjustments etc. before they can be
> > merged and we want many changes to go into next release round and not
> > to miss the merge window.
> 
> As far as I'm concerned, there's no need for a discussion on these. If
> the other patches go in to make it as light weight as what we currently
> have, then I'm fine with it. I can queue it up for post initial merge
> submission.

Ok, fair enough. Thank you very much!

Best Regards,
Elena.

> 
> --
> Jens Axboe

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
