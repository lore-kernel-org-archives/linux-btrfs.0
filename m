Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11DFC04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80C6B214DE
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80C6B214DE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbeLDLE5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 06:04:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:45246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727079AbeLDLEy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 06:04:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3839BAC17
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 11:04:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7B8D1DA7A3; Tue,  4 Dec 2018 12:04:32 +0100 (CET)
Date:   Tue, 4 Dec 2018 12:04:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs-progs: Makefile.extrawarn: Import
 cc-disable-warning
Message-ID: <20181204110432.GH17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116075426.4142-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 03:54:18PM +0800, Qu Wenruo wrote:
> We imported cc-option but forgot to import cc-disable-warning.
> 
> Fixes: b556a992c3ad ("btrfs-progs: build: allow to build with various compiler warnings")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  Makefile.extrawarn | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Makefile.extrawarn b/Makefile.extrawarn
> index 1f4bda94a167..5849036fd166 100644
> --- a/Makefile.extrawarn
> +++ b/Makefile.extrawarn
> @@ -19,6 +19,12 @@ try-run = $(shell set -e;               \
>   cc-option = $(call try-run,\
>           $(CC) $(CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
>  
> +# cc-disable-warning
> +# Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
> +cc-disable-warning = $(call try-run,\
> +	$(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))

btrfs-progs don't use KBUILD_CPPFLAGS nor CC_OPTION_CFLAGS so this needs
to be properly ported from kernel.
