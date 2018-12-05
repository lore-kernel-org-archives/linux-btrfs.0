Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81C2C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C55320878
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C55320878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lip6.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbeLEOqm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:46:42 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7679 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbeLEOqm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 09:46:42 -0500
X-IronPort-AV: E=Sophos;i="5.56,317,1539640800"; 
   d="scan'208";a="358940085"
Received: from vaio-julia.rsr.lip6.fr ([132.227.76.33])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2018 15:46:40 +0100
Date:   Wed, 5 Dec 2018 15:46:35 +0100 (CET)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Johannes Thumshirn <jthumshirn@suse.de>
cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [RFC PATCH 3/3] coccinelle: api: add offset_in_page.cocci
In-Reply-To: <20181205142305.15361-4-jthumshirn@suse.de>
Message-ID: <alpine.DEB.2.20.1812051542530.3726@hadrien>
References: <20181205142305.15361-1-jthumshirn@suse.de> <20181205142305.15361-4-jthumshirn@suse.de>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On Wed, 5 Dec 2018, Johannes Thumshirn wrote:

> Constructs like 'var & (PAGE_SIZE - 1)' or 'var & ~PAGE_MASK' can be
> replaced by the offset_in_page() macro instead of open-coding it.
>
> Add a coccinelle semantic patch to ease detection and conversion of these.
>
> This unfortunately doesn't account for the case when we want PAGE_ALIGNED()
> instead of offset_in_page() yet.
>
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  scripts/coccinelle/api/offset_in_page.cocci | 81 +++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
>  create mode 100644 scripts/coccinelle/api/offset_in_page.cocci
>
> diff --git a/scripts/coccinelle/api/offset_in_page.cocci b/scripts/coccinelle/api/offset_in_page.cocci
> new file mode 100644
> index 000000000000..ea5b3a8e0390
> --- /dev/null
> +++ b/scripts/coccinelle/api/offset_in_page.cocci
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0
> +///
> +/// Use offset_in_page macro on address instead of explicit computation.
> +///
> +//  Confidence: High
> +//  Keywords: offset_in_page
> +//  Comment: Based on vma_pages.cocci
> +
> +virtual context
> +virtual patch
> +virtual org
> +virtual report
> +
> +
> +//----------------------------------------------------------
> +//  For context mode
> +//----------------------------------------------------------
> +
> +@r_context depends on context && !patch && !org && !report@
> +expression E;
> +@@
> +
> +(
> +* E & ~PAGE_MASK
> +|
> +* E & (PAGE_SIZE - 1)
> +)
> +
> +
> +//----------------------------------------------------------
> +//  For patch mode
> +//----------------------------------------------------------
> +
> +@r_patch depends on !context && patch && !org && !report@
> +expression E;
> +type T;
> +@@
> +
> +(
> +- E & ~PAGE_MASK
> ++ offset_in_page(E)
> +|
> +- E & (PAGE_SIZE - 1)
> ++ offset_in_page(E)

The two lines above should be subsumed by the two lines below.  When there
is a type metavariable that has no other dependencies, an isomorphism will
consider that it is either present or absent.

Why not include the cast case for the context and org cases?

Masahiro will ultimately commit this.  I have added him to CC.

Thanks for the contribution.

julia


> +|
> +- E & ((T)PAGE_SIZE - 1)
> ++ offset_in_page(E)
> +)
> +
> +//----------------------------------------------------------
> +//  For org mode
> +//----------------------------------------------------------
> +
> +@r_org depends on !context && !patch && (org || report)@
> +expression E;
> +position p;
> +@@
> +
> +  (
> +  * E@p & ~PAGE_MASK
> +  |
> +  * E@p & (PAGE_SIZE - 1)
> +  )
> +
> +@script:python depends on report@
> +p << r_org.p;
> +x << r_org.E;
> +@@
> +
> +msg="WARNING: Consider using offset_in_page helper on %s" % (x)
> +coccilib.report.print_report(p[0], msg)
> +
> +@script:python depends on org@
> +p << r_org.p;
> +x << r_org.E;
> +@@
> +
> +msg="WARNING: Consider using offset_in_page helper on %s" % (x)
> +msg_safe=msg.replace("[","@(").replace("]",")")
> +coccilib.org.print_todo(p[0], msg_safe)
> +
> --
> 2.16.4
>
>
