Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC24C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A99623A7F
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbhAHVAe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 16:00:34 -0500
Received: from aposti.net ([89.234.176.197]:44438 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbhAHVAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jan 2021 16:00:34 -0500
Date:   Fri, 08 Jan 2021 20:20:43 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [patch V3 13/37] mips/mm/highmem: Switch to generic kmap atomic
To:     tglx@linutronix.de
Cc:     airlied@linux.ie, airlied@redhat.com, akpm@linux-foundation.org,
        arnd@arndb.de, bcrl@kvack.org, bigeasy@linutronix.de,
        bristot@redhat.com, bsegall@google.com, bskeggs@redhat.com,
        chris@zankel.net, christian.koenig@amd.com, clm@fb.com,
        davem@davemloft.net, deanbo422@gmail.com, dietmar.eggemann@arm.com,
        dri-devel@lists.freedesktop.org, dsterba@suse.com,
        green.hu@gmail.com, hch@lst.de, intel-gfx@lists.freedesktop.org,
        jcmvbkbc@gmail.com, josef@toxicpanda.com, juri.lelli@redhat.com,
        kraxel@redhat.com, linux-aio@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-fsdevel@vger.kernel.org,
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
        tsbogend@alpha.franken.de, vgupta@synopsys.com,
        vincent.guittot@linaro.org, viro@zeniv.linux.org.uk,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Message-Id: <JUTMMQ.NNFWKIUV7UUJ1@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Thomas,

5.11 does not boot anymore on Ingenic SoCs, I bisected it to this 
commit.

Any idea what could be happening?

Cheers,
-Paul


