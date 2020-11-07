Return-Path: <SRS0=EQ1r=EN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60716C388F9
	for <linux-btrfs@archiver.kernel.org>; Sat,  7 Nov 2020 15:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E61A320888
	for <linux-btrfs@archiver.kernel.org>; Sat,  7 Nov 2020 15:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=petezilla.co.uk header.i=@petezilla.co.uk header.b="i+RXBu4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgKGPww (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 7 Nov 2020 10:52:52 -0500
Received: from krystal1.wisercloud.co.uk ([185.53.58.188]:42112 "EHLO
        krystal1.wisercloud.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgKGPwv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2020 10:52:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=petezilla.co.uk; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WZXTKYiQuJtOJSCD89INTkAO0RNL/8NWlDDbhBmfMRY=; b=i+RXBu4h1pxGxmW/FOgde1pGWa
        ZqxP+/V9YQoM5lxUdBUd0Owe2Vhy++bHvEcpEtHiVWOl6YJw+sV4gDriPz7gz6m1gcaI/9aoEEHlR
        dEQykg0x2qbtLNzDTXqDHITVM9xzIv0hKbyWnNrUU97P5nfnfK1ACDgTtQxTct5/twXXZjrDBw3C2
        tSi2G3x7xzYEXI3Y6DyYpAKM10RjRR2XaIScFhJ2KmB9Qv68rzaCPfEjA5hMPYq08/2Jl0oPmANw2
        DaJHqegmafjEkcxNH3v7mMuJLsFEcuZvWb1njqf3uoNLXB/9JUdASHo1ZuQBTeKyzMzUJpWJRqXbC
        8hg0M3Ag==;
Received: from cpc76102-ando7-2-0-cust287.15-1.cable.virginm.net ([80.7.33.32]:54784 helo=phoenix.exfire)
        by krystal1.wisercloud.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <pete@petezilla.co.uk>)
        id 1kbQWH-002pej-BV; Sat, 07 Nov 2020 15:52:49 +0000
Subject: Re: Move from 5.9.3 kernel to 5.4.75?
To:     Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <7d436bf1-80d2-a298-d124-e9385fb6ef42@petezilla.co.uk>
 <20201107154417.GP30996@savella.carfax.org.uk>
From:   Pete <pete@petezilla.co.uk>
Message-ID: <57c28223-139c-da3d-1c4d-32d87c5bc686@petezilla.co.uk>
Date:   Sat, 7 Nov 2020 15:52:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201107154417.GP30996@savella.carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-0.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - krystal1.wisercloud.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petezilla.co.uk
X-Get-Message-Sender-Via: krystal1.wisercloud.co.uk: authenticated_id: pete+petezilla.co.uk/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: krystal1.wisercloud.co.uk: pete@petezilla.co.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/7/20 3:44 PM, Hugo Mills wrote:

>    If it's going to fail, it'll fail safely. If there are features
> used on the FS that the earlier kernel can't deal with, it'll spot
> that there's incompat bits set and refuse to mount.
> 
>    You'll get back all the kernel bugs that didn't have fixes
> backported, but that's all.

Thanks.  Whilst the issues I have with a second x session are annoying
hosing the file system, even with backups, is far worse.  So thank you.

Pete


