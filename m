Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47051 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932629AbcJTHVi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 03:21:38 -0400
Date: Thu, 20 Oct 2016 09:17:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Philipp Hahn <pmhahn@pmhahn.de>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
In-Reply-To: <20161020065216.GB29032@gmail.com>
Message-ID: <alpine.DEB.2.20.1610200915230.5073@nanos>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk> <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk> <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com> <20161018233148.GA93792@clm-mbp.masoncoding.com> <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com> <9ba0cd0b-33f6-2156-aaf2-ad9ed9a00115@pmhahn.de> <CA+55aFx1W2d4TJN5_D-v_3-hVKKqSyrweqk+eigvNtr_hJe_9A@mail.gmail.com> <20161020065216.GB29032@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 20 Oct 2016, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > So I don't think it's related. Yours looks like some subtle timer base
> > race. It smells like a locking problem with timers. I'm not seeing
> > what it might be, but it *might* have been fixed by doing the
> > TIMER_MIGRATING bit right in add_timer_on() (commit 22b886dd1018).

4.1 does not have the new fangled timer wheel. So 22b886dd1018 is
irrelevant.

> > Adding some timer people just in case, but I don't think your 4.1
> > report is related.

This looks like one of the classic issues where an enqueued timer gets
freed/reinitialized or otherwise manipulated. So yes, Ingos recommendation
for debugging is the right thing to do.
 
Thanks,

	tglx
