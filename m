Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FABC352A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 20:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFFD524650
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 20:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ZEc9qA8t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgBMUFu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 15:05:50 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:41902 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgBMUFu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 15:05:50 -0500
Received: by mail-pf1-f181.google.com with SMTP id j9so3598877pfa.8
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2020 12:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FJ3/E1QZB+NhjNzmVQtUkZNKiqD99PdDuzX+ATm65J8=;
        b=ZEc9qA8tNK04ztK0P5OAJkrXQC9hKcnHasjESzxOXJ3dbfugrRH7Vt/S/ianw5+Kh4
         4UenszuyJClkpZ8r6HEOrhsaTpwuXDebKSX/dW5loZatI2iP5Zl7fi5Bwq17zUlQ79Mf
         TXneaE1b770F4TYmD5LBNElL+TYS/ZDhcGfuMgv+q6BuE+F3THRRuVSp8BF6KnL/5Bfd
         R9c6DX9YgfPCOZ3J4gbRwPWLGm82nChwo83LkKN83Bsy22x38AhOuXJgD6uzoW6IFY8m
         UG/MlmksIDJgTUX4cj4wlzoOlfBYjY4jZsBpWLVacOZ2/GSW6QTo+rPsDPZhqTkRGTzD
         9Kog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJ3/E1QZB+NhjNzmVQtUkZNKiqD99PdDuzX+ATm65J8=;
        b=flhIS2L5jabfbuvN2Djt6SQqfky4mLWQDg04ffoD72+B6Oeqr18CwFvdtQi94ZCSOs
         oX/MaJ4g2DGhd9HdzorEbZJmb9lDUEoxUgpAlYfCxUYPuS9kkNtqycj1R3BC+e8pX0ty
         aZn2O4Db3XBGrwz11d/4ZIfCvpbBRCmJ9zo+s/gHWLIlkHLUsNjQPaQwtEWxdCR8zR+/
         Pe9URrhsqCz+ajoMHCJuGy8Z7E4OHaC+VCieftmVNhrfaR1ibGxG7OsRrKt3wT/ObM9K
         sHFsTCAmWDIeTYIBCdqg4BFd7DgS+o2ZeD2ntRyVNAbSFi7Et4YrTWgPNzAfyx/62GO2
         4UBg==
X-Gm-Message-State: APjAAAU0YG2YuCEae8sDrSHcQRQrIdtQvFE0vZrd2OnCyeQfkAF5vmUI
        cjiNjQdkUM/D6HLMr4HGKHB0ykwMnNY=
X-Google-Smtp-Source: APXvYqyz64ATzUYX5/4vSsPv6fAbWCg+Abliq5PEwrueXBiZcwN1qEJeYtT39iOD3nVTdc+oK+I1ug==
X-Received: by 2002:a62:16d0:: with SMTP id 199mr18678801pfw.96.1581624348865;
        Thu, 13 Feb 2020 12:05:48 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21cf::1150? ([2620:10d:c090:400::5:249c])
        by smtp.gmail.com with ESMTPSA id o16sm3875420pgl.58.2020.02.13.12.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 12:05:48 -0800 (PST)
Subject: Re: [PATCH v2 3/4] btrfs: relocation: Check cancel request after each
 extent found
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20200211053729.20807-1-wqu@suse.com>
 <20200211053729.20807-4-wqu@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <b8f1a951-7203-4e50-a04a-f4720ac90885@toxicpanda.com>
Date:   Thu, 13 Feb 2020 15:05:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200211053729.20807-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/11/20 12:37 AM, Qu Wenruo wrote:
> When relocating data block groups with tons of small extents, or
> large metadata block groups, there can be over 200,000 extents.
> 
> We will iterate all extents of such block group in relocate_block_group(),
> where iteration itself can be kinda time-consuming.
> 
> So when user want to cancel the balance, the extent iteration loop can
> be another target.
> 
> This patch will add the cancelling check in the extent iteration loop of
> relocate_block_group() to make balance cancelling faster.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
