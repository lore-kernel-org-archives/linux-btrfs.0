Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A96CC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 15:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFA05218D2
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 15:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKOGeHvu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfBIP54 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:57:56 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:54943 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfBIP54 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 10:57:56 -0500
Received: by mail-wm1-f49.google.com with SMTP id a62so8925966wmh.4
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2019 07:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=A17Kf3r9YT/pj0nMVPx6ayDGqzeP4LYbacsAdYP2RvQ=;
        b=pKOGeHvuexFqylAhy3zI7l9dhssaxGYqCqp/uOtS0dYN6ELgleZbEgUbH/0GQansIa
         ujxxp5hA02ssbNqAz4ebSd5Q45MFmlLpP6LUW3gXdqi/DvOpuKq3VJ+8jSrIYI5Z02zk
         vw/Tg6xcxRYio6FmuREReYcL5k/+G5/G2QjuR0MRuHxlGBQd5DHTNbJyqTEV6ZpWj9jC
         irtZm7alGpZe6EJHerZUdxTyojKmw7B0BLNnInQPGyZMPAhUTocO3HaopCen1uA1BQbM
         M2c2/njVC4MKrxojtSRflY7GJ+jchCeE5gk8Sakeh+ZDCaxcRaqykkgRHZoVpVEfZoUd
         r8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=A17Kf3r9YT/pj0nMVPx6ayDGqzeP4LYbacsAdYP2RvQ=;
        b=YRFbeT7M+AHi0zoB3Pn+sdsjSDQpzIBuOZFhexGqhX5FuRRPRyYx+yMTfOvnoFRRks
         j7lTGRzs4tGRGtL5sKd3bMB6aecAHOrsnDqEo8XNPifksUFyWEAe+AsjL33B8hdcTXBc
         53V63aF58C7+Bx9+eWCZNEBKBWCe+x+6wXDxBnzotpIHE3z6MBLcOELWLycAzBnLWUpK
         onyyLQiLADzXVd4kBbHumbKNhWDtCxmPJFjs0i5FIJQ7ry1Ded0PChmLimhQZ2SwE8s1
         Xv/juLva7pAIF9v9y641gaK7sY3uMqUpsUcHRkjSVM9gMzPmePT3JLOPdoXYOb7Q3a55
         NeCA==
X-Gm-Message-State: AHQUAuaejuOUSXbXrfasNvXUgMrU+JJULgm5UKmSz8PxoCmwmebYWTvX
        ZvMbxSh50+ciEWFCbaZyNQ==
X-Google-Smtp-Source: AHgI3IatTQ8Y2/ttUPgrVZFEeRnXeJEjTOCMQHUj1Efg4e9ve/qCRyN4sx9SWZF5chV6B5lVoCqh4Q==
X-Received: by 2002:adf:fb0d:: with SMTP id c13mr4429491wrr.285.1549727873019;
        Sat, 09 Feb 2019 07:57:53 -0800 (PST)
Received: from [192.168.178.53] (ip2505f80d.dynamic.kabel-deutschland.de. [37.5.248.13])
        by smtp.googlemail.com with ESMTPSA id y24sm9962094wma.0.2019.02.09.07.57.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 07:57:52 -0800 (PST)
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
To:     Andrei Borzenkov <arvidjaar@gmail.com>, linux-btrfs@vger.kernel.org
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
 <5441dc9d-a552-e77e-f74d-fe6ef702d400@gmx.com>
 <57d3a28d-bf6e-7f89-3a2d-ebcb90fc6e32@gmail.com>
 <0680cf0a-5a03-086f-d3f7-3317655401f0@gmail.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>
From:   =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jschoett@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <969d659b-bce1-7a72-6e50-6981dae56a94@gmail.com>
Date:   Sat, 9 Feb 2019 16:57:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <0680cf0a-5a03-086f-d3f7-3317655401f0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: de-DE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Am 09.02.19 um 16:32 schrieb Andrei Borzenkov:
> Running
>
> btrfs balance start -f -ssoft,convert=3Draid1 -dsoft,convert=3Draid1
> -msoft,convert=3Draid1 /mnt
>
> fixes it. I am not sure whether btrfs is expected to do it automaticall=
y
> as of now.

This fix seems to work for me, too. Output was:
 > Done, had to relocate 5 out of 8 chunks

Tested without any subvolumes or data.

