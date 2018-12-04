Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C2DC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 960FF2082D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:10:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 960FF2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbeLDLKl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 06:10:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:46680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728382AbeLDLKk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 06:10:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B93ABAC7A;
        Tue,  4 Dec 2018 11:10:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 53476DA7A3; Tue,  4 Dec 2018 12:10:19 +0100 (CET)
Date:   Tue, 4 Dec 2018 12:10:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/9] btrfs-progs: fix gcc8 default build warning caused
 by '-Wformat-truncation'
Message-ID: <20181204111018.GI17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Su Yanjun <suyj.fnst@cn.fujitsu.com>
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116075426.4142-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 03:54:19PM +0800, Qu Wenruo wrote:
> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> 
> When using gcc8 compiles utils.c, it complains as below:
> 
> utils.c:852:45: warning: '%s' directive output may be truncated writing
> up to 4095 bytes into a region of size 4084 [-Wformat-truncation=]
>    snprintf(path, sizeof(path), "/dev/mapper/%s", name);
>                                              ^~   ~~~~
> In file included from /usr/include/stdio.h:873,
>                  from utils.c:20:
> /usr/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk'
> output between 13 and 4108 bytes into a destination of size 4096
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This isn't a type of warning we care about, particularly when PATH_MAX
> is much less than either.
> 
> Using the GCC option -Wno-format-truncation to disable this for default
> build.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> [Use cc-disable-warning to fix the not working CFLAGS setting in configure.ac]
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  Makefile           | 1 +
>  Makefile.extrawarn | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index f4ab14ea74c8..252299f8869f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -49,6 +49,7 @@ CSCOPE_CMD := cscope -u -b -c -q
>  include Makefile.extrawarn
>  
>  EXTRA_CFLAGS :=
> +EXTRA_CFLAGS += $(call cc-disable-warning, format-truncation)

Please don't touch EXTRA_CFLAGS, this is for users who want to override
any defaults that are set by build. This should go to CFLAGS.

>  EXTRA_LDFLAGS :=
>  
>  DEBUG_CFLAGS_DEFAULT = -O0 -U_FORTIFY_SOURCE -ggdb3
> diff --git a/Makefile.extrawarn b/Makefile.extrawarn
> index 5849036fd166..bbb2d5173846 100644
> --- a/Makefile.extrawarn
> +++ b/Makefile.extrawarn
> @@ -53,6 +53,7 @@ warning-1 += -Wold-style-definition
>  warning-1 += $(call cc-option, -Wmissing-include-dirs)
>  warning-1 += $(call cc-option, -Wunused-but-set-variable)
>  warning-1 += $(call cc-disable-warning, missing-field-initializers)
> +warning-1 += $(call cc-disable-warning, format-truncation)

It's ok to disable for W=1 but eg. the W=3 level could take all
previously disabled warnings.

>  
>  warning-2 := -Waggregate-return
>  warning-2 += -Wcast-align
> -- 
> 2.19.1
