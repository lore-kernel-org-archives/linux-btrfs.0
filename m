Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34829 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbcJTGwU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 02:52:20 -0400
Date: Thu, 20 Oct 2016 08:52:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Philipp Hahn <pmhahn@pmhahn.de>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <clm@fb.com>, Jens Axboe <axboe@fb.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161020065216.GB29032@gmail.com>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
 <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <9ba0cd0b-33f6-2156-aaf2-ad9ed9a00115@pmhahn.de>
 <CA+55aFx1W2d4TJN5_D-v_3-hVKKqSyrweqk+eigvNtr_hJe_9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFx1W2d4TJN5_D-v_3-hVKKqSyrweqk+eigvNtr_hJe_9A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Oct 19, 2016 at 10:09 AM, Philipp Hahn <pmhahn@pmhahn.de> wrote:
> >
> > Nearly a month ago I reported also a "list_add corruption", but with 4.1.6:
> > <http://marc.info/?l=linux-kernel&m=147508265316854&w=2>
> >
> > That server rungs Samba4, which also is a heavy user of xattr.
> 
> That one looks very different. In fact, the list that got corrupted
> for you has since been changed to a hlist (which is *similar* to our
> doubly-linked list, but has a smaller head and does not allow adding
> to the end of the list).
> 
> Also, the "should be" and "was" values are very close, and switched:
> 
> should be ffffffff81ab3ca8, but was ffffffff81ab3cc8
> should be ffffffff81ab3cc8, but was ffffffff81ab3ca8
> 
> so it actually looks like it was the same data structure. In
> particular, it looks like enqueue_timer() ended up racing on adding an
> entry to one index in the "base->vectors[]" array, while hitting an
> entry that was pointing to another index near-by.
> 
> So I don't think it's related. Yours looks like some subtle timer base
> race. It smells like a locking problem with timers. I'm not seeing
> what it might be, but it *might* have been fixed by doing the
> TIMER_MIGRATING bit right in add_timer_on() (commit 22b886dd1018).
> 
> Adding some timer people just in case, but I don't think your 4.1
> report is related.

Side note: in case timer callback related corruption is suspected, a very 
efficient debugging method is to enable debugobjects tracking+checking:

CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_KOBJECT_RELEASE=y

( Appending these to the .config and running 'make oldconfig' should enable all of 
  these. )

If the problem is in any of these areas then a debug warning could trigger at a 
more convenient place than some later 'some unrelated bits got corrupted' warning.

Thanks,

	Ingo
