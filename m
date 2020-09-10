Return-Path: <SRS0=1Lxm=CT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6CCC433E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 19:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CBF21D81
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 19:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="QsN7UQkn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbgIJPYk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731242AbgIJPFH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Sep 2020 11:05:07 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A87FC0617B1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2020 08:04:20 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id n18so5097950qtw.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2020 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cCN1cM+BpYA/vwg1dRPAkK53lOBLtHeZQsMaFnEQfsI=;
        b=QsN7UQknO/u17+c38Ygv5Ot5CnDyzQOjLEJWfwawruDyHrbtIgHxJWtf7drnJJgXDy
         2YS2cCwd7FoNnsVoPaKBxI0Qy0eC0pWxTV3Hhq/BibB/sbSh/D1TLeSac1WF8iF6rGnF
         zbHDj9hwogqh4FccnpxAGs4/C6ONPR3PKVNDDqQR1ayAccKqFTA47PYQQDK02Bk2vYPG
         fvJ1SRggIfkAtwtvSFE9xD0sPzQOC76E5MAiIGPabkkR8CpNlVvLYu81OksVRMB8KYnY
         XMrbc6opROuBHj8meB7U0/xIbrsfue8HHiSbNJlrLt1X18r7XB4pf0sA/Bo4txGZJvle
         Bu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cCN1cM+BpYA/vwg1dRPAkK53lOBLtHeZQsMaFnEQfsI=;
        b=mAcNZ+8lUn9ky+RE7CHYov5yXXy2tfkAEPqCLDZIZp3vvJ9uHiL7x9LgmzqqFjJ8Kh
         aAHIZMJzpy0FNY3jjHtH7Lt3Ni+qS1qpWBUP2XZ4a4Tb+rTB7xiqgDy+w8l0mHUO/p0F
         ZEyrwpcq/m3q6xOl3ijTITlvk19ZRFLkvcdDez/AD2SbHpAU/GbDypDPgOb9MoFtkjYL
         zejPh/AjlRlYglYfoGKtPBDvuI1CSDj5LoBJjBxEi0tTgWIxukfjtOowByR3zZC7qGQK
         saRrV72jy/4mz/fhucEm2bDAJbmtlH9uRnAB3qIF3sYZHGuUtjClWhlhlIFRmO5F6Jj9
         XkLg==
X-Gm-Message-State: AOAM531QyMTeiG7TXjZBW7S4LI3bUjNmvm/9IFYoCK5GleuWjTCPzT2u
        QUws7GtotyjZRk70UeIl+mPnLRp8dHvKgiNn
X-Google-Smtp-Source: ABdhPJwIxwH2m1Q/NQWh+WZomG25IVGRufnCtLgQJWRWTNycKDWPgepJdnq5oKJzCgbKlRQYlYqi2A==
X-Received: by 2002:ac8:c44:: with SMTP id l4mr8533824qti.2.1599750259166;
        Thu, 10 Sep 2020 08:04:19 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id x6sm6952412qke.54.2020.09.10.08.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 08:04:18 -0700 (PDT)
Subject: Re: [PATCH 10/10] btrfs: Sink mirror_num argument in __do_readpage
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20200909094914.29721-1-nborisov@suse.com>
 <20200909094914.29721-11-nborisov@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <5a837a0f-9f55-0813-3edc-d65f309568b6@toxicpanda.com>
Date:   Thu, 10 Sep 2020 11:04:17 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200909094914.29721-11-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 9/9/20 5:49 AM, Nikolay Borisov wrote:
> It's always set to 0 by the 2 callers so move it inside __do_readpage.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
