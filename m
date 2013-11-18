Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46899 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab3KRKbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 05:31:23 -0500
Date: Mon, 18 Nov 2013 10:30:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20131118103055.GA22763@mudshark.cambridge.arm.com>
References: <20131114171952.3802.93244@localhost.localdomain>
 <20131115113216.GA7777@osiris>
 <20131115122131.3802.25439@localhost.localdomain>
 <20131115134019.3802.51473@localhost.localdomain>
 <CAMuHMdWsEaDKoPy7JhKUGqUrkg_8JrVH7fc8JePt=9MXzcSrgQ@mail.gmail.com>
 <20131115145723.GB7777@osiris>
 <20131117093604.GT2008@redhat.com>
 <20131118093555.GA4192@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131118093555.GA4192@osiris>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 18, 2013 at 09:35:55AM +0000, Heiko Carstens wrote:
> From b19687bad7e878aaed6edb786a22c6b05e886b97 Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Mon, 18 Nov 2013 10:05:57 +0100
> Subject: [PATCH] kvm: kvm_clear_guest_page(): fix empty_zero_page usage
> 
> Using the address of 'empty_zero_page' as source address in order to clear
> a page is wrong. On some architectures empty_zero_page is only the pointer
> to the struct page of the empty_zero_page.
> Therefore the clear page operation would copy the contents of a couple of
> struct pages instead of clearing a page.
> For kvm only arm64 is affected by this bug.

In theory ARM is affected too, but this code doesn't seem to be invoked by
any architecture other than x86 afaict. It looks like there's a similar
issue in drivers/spi/spi-fsl-cpm.c where empty_zero_page is used as a dummy
dma buffer, but that code is basically powerpc only, so again, unlikely to
cause a problem in practice.

Will

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 662f34c3287e..a0aa84b5941a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1615,8 +1615,9 @@ EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
>  
>  int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
>  {
> -	return kvm_write_guest_page(kvm, gfn, (const void *) empty_zero_page,
> -				    offset, len);
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +
> +	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
>  }
>  EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
