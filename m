Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133D8C433E9
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Jan 2021 11:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1B4323B01
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Jan 2021 11:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAJLgR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 06:36:17 -0500
Received: from aposti.net ([89.234.176.197]:33724 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbhAJLgQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Jan 2021 06:36:16 -0500
Date:   Sun, 10 Jan 2021 11:35:01 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [patch V3 13/37] mips/mm/highmem: Switch to generic kmap atomic
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     tglx@linutronix.de, airlied@linux.ie, airlied@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, bcrl@kvack.org,
        bigeasy@linutronix.de, bristot@redhat.com, bsegall@google.com,
        bskeggs@redhat.com, chris@zankel.net, christian.koenig@amd.com,
        clm@fb.com, davem@davemloft.net, deanbo422@gmail.com,
        dietmar.eggemann@arm.com, dri-devel@lists.freedesktop.org,
        dsterba@suse.com, green.hu@gmail.com, hch@lst.de,
        intel-gfx@lists.freedesktop.org, jcmvbkbc@gmail.com,
        josef@toxicpanda.com, juri.lelli@redhat.com, kraxel@redhat.com,
        linux-aio@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-btrfs@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-graphics-maintainer@vmware.com, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-snps-arc@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        linux@armlinux.org.uk, linuxppc-dev@lists.ozlabs.org,
        mgorman@suse.de, mingo@kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, nickhu@andestech.com,
        nouveau@lists.freedesktop.org, paulmck@kernel.org,
        paulus@samba.org, peterz@infradead.org, ray.huang@amd.com,
        rodrigo.vivi@intel.com, rostedt@goodmis.org,
        sparclinux@vger.kernel.org, spice-devel@lists.freedesktop.org,
        sroland@vmware.com, torvalds@linuxfoundation.org,
        vgupta@synopsys.com, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, virtualization@lists.linux-foundation.org,
        x86@kernel.org
Message-Id: <DUUPMQ.U53A0W7YJPGM@crapouillou.net>
In-Reply-To: <20210109003352.GA18102@alpha.franken.de>
References: <JUTMMQ.NNFWKIUV7UUJ1@crapouillou.net>
        <20210108235805.GA17543@alpha.franken.de>
        <20210109003352.GA18102@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Thomas,

Le sam. 9 janv. 2021 à 1:33, Thomas Bogendoerfer 
<tsbogend@alpha.franken.de> a écrit :
> On Sat, Jan 09, 2021 at 12:58:05AM +0100, Thomas Bogendoerfer wrote:
>>  On Fri, Jan 08, 2021 at 08:20:43PM +0000, Paul Cercueil wrote:
>>  > Hi Thomas,
>>  >
>>  > 5.11 does not boot anymore on Ingenic SoCs, I bisected it to this 
>> commit.
>>  >
>>  > Any idea what could be happening?
>> 
>>  not yet, kernel crash log of a Malta QEMU is below.
> 
> update:
> 
> This dirty hack lets the Malta QEMU boot again:
> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index c3a9ea7875ef..190cdda1149d 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -515,7 +515,7 @@ void *__kmap_local_pfn_prot(unsigned long pfn, 
> pgprot_t prot)
>  	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>  	BUG_ON(!pte_none(*(kmap_pte - idx)));
>  	pteval = pfn_pte(pfn, prot);
> -	set_pte_at(&init_mm, vaddr, kmap_pte - idx, pteval);
> +	set_pte(kmap_pte - idx, pteval);
>  	arch_kmap_local_post_map(vaddr, pteval);
>  	current->kmap_ctrl.pteval[kmap_local_idx()] = pteval;
>  	preempt_enable();
> 
> set_pte_at() tries to update cache and could do an kmap_atomic() 
> there.
> Not sure, if this is allowed at this point.

Yes, I can confirm that your workaround works here too.

Cheers,
-Paul


