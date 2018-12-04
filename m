Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A52C04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39BFD2082D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:11:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39BFD2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbeLDLLL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 06:11:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:46782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728355AbeLDLLK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 06:11:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C22D6AC7A
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 11:11:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 721B8DA7A3; Tue,  4 Dec 2018 12:10:49 +0100 (CET)
Date:   Tue, 4 Dec 2018 12:10:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v1.1 3/9] btrfs-progs: Makefile.extrawarn: Don't warn on
 sign compare
Message-ID: <20181204111049.GJ17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181116075426.4142-4-wqu@suse.com>
 <20181116080040.5941-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116080040.5941-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 04:00:40PM +0800, Qu Wenruo wrote:
> Under most case, we are just using 'int' for 'unsigned int', and doesn't
> care about the sign.
> 
> The Wsign-compare is causing tons of false alerts.
> Suppressing it would make W=1 less noisy.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v1.1:
>    Use cc-disable-warning to provide much better compatibility against
>    older compiler
> ---
>  Makefile.extrawarn | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile.extrawarn b/Makefile.extrawarn
> index bbb2d5173846..736bee82759f 100644
> --- a/Makefile.extrawarn
> +++ b/Makefile.extrawarn
> @@ -54,6 +54,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
>  warning-1 += $(call cc-option, -Wunused-but-set-variable)
>  warning-1 += $(call cc-disable-warning, missing-field-initializers)
>  warning-1 += $(call cc-disable-warning, format-truncation)
> +warning-1 += $(call cc-disable-warning, sign-compare)

Please enable it for W=3
