Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360E1C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5A4205F4
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="CsxjpEGu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD5A4205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbeKBEEw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:04:52 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38661 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeKBEEw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:04:52 -0400
Received: by mail-yw1-f68.google.com with SMTP id d126-v6so8323834ywa.5
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=az8KmCsPWy235sIec82sITmaLYBQQogLbWdllgjyHVs=;
        b=CsxjpEGusJib8kihvc8dXIS1O3+fAytDHRyvLmWEcLeya08pnHkpkLxzgcwc4KRX1B
         SW0sz+dq+ohg7UyxxVqc4ijLiKq+hyN4dtzwS8m7mIPsPAhjTWZ7UQdRiSiHGW/870HU
         Q7dg3aujlprAX7ABf1FwJSRaPzloYW94CU1jSnYSa2hgAgqE3NpF2BqAdd3qnK7wtPfi
         23sGO46AFBIKQ3dHjTRjnP/omkRJy6VU4bYQLBoiK5+KG8yT6KajfL3nNE7CmDFewpOB
         5+TYPtX5tZBh3xuEDnT9m09AkG4qDYIVS9PQe+TIlLG+gMsVhPtdv0Ft67ipKSYttUiK
         Bn2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=az8KmCsPWy235sIec82sITmaLYBQQogLbWdllgjyHVs=;
        b=p0uVokjXQtzQZVP5s4E8x7pX9R/9En1icSGXS6t0mn4niY9gYyz/4zcok7BH1Mld0O
         /7QYxXAl4rGih1ls4phwEmNk46PkxQjiKt97Xxs77QpWt82ewTIA/+Q6n2bS8y2f0DjE
         jUWo8ASaqGwWkbUdaWwkW9aoJS0LuwCblbRXob2i5fGA2klhcFM/5+6XFou2VxCZnffj
         ysWTOr23dmY65Z7Fl0vzU/D3uDi1b3xpQQBCxj8tSAoZh1757f2qnhh1MFMiutijlT2G
         CeQgR3PIax/Dj8hwCY6unNTdEnwd6DoMUQlTzA1kADbe7dSWXAmLUypRUeafbS61Vb7b
         XZCg==
X-Gm-Message-State: AGRZ1gJB30UxFW5+TX1RpYQDjoIPeuHid/jLP2PfAaNsXnswz0789eHX
        ypYbrt3nmSEGnhGO+db5EpqRIQ==
X-Google-Smtp-Source: AJdET5chP7y6RxAp3I6yCxCv2A99zZsaX9fTPSw3G/4iRv8Ft7hHhK8nvqwXQbzIf5cSMHMqTvBcAA==
X-Received: by 2002:a81:8a45:: with SMTP id a66-v6mr8061255ywg.431.1541098838990;
        Thu, 01 Nov 2018 12:00:38 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id g5-v6sm10996380ywa.39.2018.11.01.12.00.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:00:38 -0700 (PDT)
Date:   Thu, 1 Nov 2018 15:00:37 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/8] btrfs: Remove extent_io_ops::writepage_start_hook
Message-ID: <20181101190035.jdgwlgjf26ehsegk@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-3-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:47PM +0200, Nikolay Borisov wrote:
> This hook is called only from __extent_writepage_io which is already
> called only from the data page writeout path. So there is no need to
> make an indirect call via extent_io_ops. This patch just removes the
> callback definition, exports the callback function and calls it
> directly at the only call site. Also give the function a more descriptive
> name. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
