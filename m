Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:53639 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3KRJhJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 04:37:09 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Mon, 18 Nov 2013 09:37:06 -0000
Date: Mon, 18 Nov 2013 10:35:55 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20131118093555.GA4192@osiris>
References: <20131114171952.3802.93244@localhost.localdomain>
 <20131115113216.GA7777@osiris>
 <20131115122131.3802.25439@localhost.localdomain>
 <20131115134019.3802.51473@localhost.localdomain>
 <CAMuHMdWsEaDKoPy7JhKUGqUrkg_8JrVH7fc8JePt=9MXzcSrgQ@mail.gmail.com>
 <20131115145723.GB7777@osiris>
 <20131117093604.GT2008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131117093604.GT2008@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 17, 2013 at 11:36:04AM +0200, Gleb Natapov wrote:
> On Fri, Nov 15, 2013 at 03:57:23PM +0100, Heiko Carstens wrote:
> > On Fri, Nov 15, 2013 at 02:42:08PM +0100, Geert Uytterhoeven wrote:
> > > I was just going to comment that
> > > 
> > > +       const void *zero_page = (const void *) page_to_phys(ZERO_PAGE(0));
> > > 
> > > won't fly. You can't just cast a physical address to "void *".
> > 
> > Ouch.. I think that only works on s390 because we have a 1:1 mapping for
> > physical to virtual addresses in kernel space due to our split address spaces.
> > 
> > So for btrfs and kvm it should be page_to_virt(), and for the dma_map_single()
> > case I have no idea. :)
> Can you send updated patch for kvm please?

See below. page_to_virt() is only defined for a couple of architectures, so I
used __va(page_to_phys()) instead.
I tested the patch on s390 only...

>From b19687bad7e878aaed6edb786a22c6b05e886b97 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 18 Nov 2013 10:05:57 +0100
Subject: [PATCH] kvm: kvm_clear_guest_page(): fix empty_zero_page usage

Using the address of 'empty_zero_page' as source address in order to clear
a page is wrong. On some architectures empty_zero_page is only the pointer
to the struct page of the empty_zero_page.
Therefore the clear page operation would copy the contents of a couple of
struct pages instead of clearing a page.
For kvm only arm64 is affected by this bug.

To fix this use the ZERO_PAGE macro instead which will return the struct
page address of the empty_zero_page on all architectures.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 662f34c3287e..a0aa84b5941a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1615,8 +1615,9 @@ EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
 
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 {
-	return kvm_write_guest_page(kvm, gfn, (const void *) empty_zero_page,
-				    offset, len);
+	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
+
+	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
 
-- 
1.8.3.4

