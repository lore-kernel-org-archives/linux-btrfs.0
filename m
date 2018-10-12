Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B348C28CF8
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 01:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4502085B
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 01:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA4502085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=t-5.eu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbeJLJOS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 05:14:18 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:46979 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbeJLJOS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 05:14:18 -0400
Received: by mail-ed1-f50.google.com with SMTP id g32-v6so10000799edg.13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 18:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:date:message-id:in-reply-to:references
         :user-agent:subject:mime-version:content-transfer-encoding;
        bh=NmXQ23psePO/pctcUnuAj1kOcAxur16DWWw4Dc1oKJs=;
        b=lhnihqtc87OrPPyEHGhv3mm9T7ZtY3RPPH3adc8OSCAqA9h2xdtxc+zJtv+WXvPGrR
         WR9wKX2KgtLZT2/yxfNF9HSaDKWK6Zb8+j56jWHAV5N+H838RLO2iypfNJ3Pop1mJUHg
         MKmRU4Jk53G3IXxh36tie0RyTM2LdF+W5TAe5Vt5XeSw8pCI7NB95D27Y49EABqOfdt6
         Tn48zCRStSFtmMURf9wndHs/VFvIEhr4G6DQKtHHfOgEUK/B+EVvU8wtEIEVjs0Yj/B2
         ZUu7VNX0rp8N0dVPErk4bnN1sZJUJWOxTtFpaLmTqZuxiDIhXFVAJ6UwPYNjNehdICBz
         JsMw==
X-Gm-Message-State: ABuFfogwrWgY7usTaVpx2PRsPUaG31kV0ko7VbDK3C3TfrNufiNbgIK7
        lXs+VFDa37gFuRTYWuiVaGvFmdXI
X-Google-Smtp-Source: ACcGV61TQjekfSAJwdBz0XVPI52bzmJ59jw6MYV9ZHjNFVR3LoDtiTcXIoTVOUm3DASOZpMYZQxkRA==
X-Received: by 2002:a50:9b52:: with SMTP id a18-v6mr5929815edj.246.1539308659394;
        Thu, 11 Oct 2018 18:44:19 -0700 (PDT)
Received: from t-5.eu (p5B2838F0.dip0.t-ipconnect.de. [91.40.56.240])
        by smtp.gmail.com with ESMTPSA id w8-v6sm9104980eda.37.2018.10.11.18.44.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 18:44:18 -0700 (PDT)
Received: from [192.168.2.101] (t5-oneplus [192.168.2.101])
        by t-5.eu (Postfix) with ESMTPSA id 0E3081ACCD9
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 03:44:16 +0200 (CEST)
From:   =?UTF-8?B?SsO8cmdlbiBIZXJybWFubg==?= <t-5@t-5.eu>
To:     <linux-btrfs@vger.kernel.org>
Date:   Fri, 12 Oct 2018 03:44:16 +0200
Message-ID: <16665f21580.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
In-Reply-To: <CAJCQCtRoN=0oQyiwOPhkO6ZwqQL+Qjsm_mue8aoMWPsg2b7OQQ@mail.gmail.com>
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
 <CAJCQCtRoN=0oQyiwOPhkO6ZwqQL+Qjsm_mue8aoMWPsg2b7OQQ@mail.gmail.com>
User-Agent: AquaMail/1.16.1-1284 (build: 101600100)
Subject: Re: errors reported by btrfs-check
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

4.17.1 compiled from source.

Best regards,
Jürgen

Am 12. Oktober 2018 00:36:26 schrieb Chris Murphy <lists@colorremedies.com>:

> What version of btrfs-progs?


Mit AquaMail Android
https://www.mobisystems.com/aqua-mail


