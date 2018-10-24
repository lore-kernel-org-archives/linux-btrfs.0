Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA4CC67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5852075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF5852075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbeJYAIg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 20:08:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:46894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726504AbeJYAIg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 20:08:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7AAAFAEB0;
        Wed, 24 Oct 2018 15:40:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9ACEDABAA; Wed, 24 Oct 2018 17:39:21 +0200 (CEST)
Date:   Wed, 24 Oct 2018 17:39:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix compile warning when using gcc8 to
 compile btrfs-progs
Message-ID: <20181024153921.GX16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20181012013637.10220-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012013637.10220-1-suyj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 09:36:37AM +0800, Su Yanjun wrote:
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
> Using the GCC option -Wno-format-truncation to disable this.

Disabling for the default build is probably ok, but I'd rather keep the
warning in the extended set that's defined in Makefile.extrawarn. Please
update the patch and also pick a more specific subject line, there's
another patch with exactly same text but completely different set of
changes. Thanks.
