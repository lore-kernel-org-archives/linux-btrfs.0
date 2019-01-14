Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588E0C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 00:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EBAE20656
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 00:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lwrKBHxk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfANAtB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 13 Jan 2019 19:49:01 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:41976 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfANAtA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Jan 2019 19:49:00 -0500
Received: by mail-wr1-f41.google.com with SMTP id x10so20959402wrs.8
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Jan 2019 16:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:from:to:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=5bdviKqAMhkVhZE4Hn+85jlmD+MJN3WE/TCVJKONKUw=;
        b=lwrKBHxk91Dw+gxez+fKkzTfC+a8AiJ+961OGtXuG+ozPyrbiWkYl6YTdunKrhpnS7
         vj2/zC0fdKHpO0z1d9QTaFVB9DwPsgQfIAWvAYZVIIpwxdqPxzvJ9xbunwKrDag0ZfvB
         ti2K2UV/xibE+wRzpF2O1XAvtI0anVKdmm9eCb2lloSwTifqnpcCXhBBlDx1LcnLFoeF
         anpmuYGsn1OLd5R6hGzwrTlcmOTsPjprjXzwaSQJvftvMKd4UkHGSoa2rMU5DxHKaYfT
         g7lahj2/7mJCqpNciV/VF2mSAkeWAp5At8InD9iLWMaFlleXxTvgZT2c+oN1TOtchgge
         LB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language;
        bh=5bdviKqAMhkVhZE4Hn+85jlmD+MJN3WE/TCVJKONKUw=;
        b=qjaIrBfdnzGo2Nmcc0Id9ICwjfOplgMdU3wQZz2F+cvep2VY/eoTZtVDgszNhzmruY
         eYVSwGx4uYi0g5F5jvx3QmWC5WwtRhmaDnimzK2jMVbmedyx3pyZU0DiHF3xP7KOnKy3
         7IucGWuEhBzy0oKGG9fbzmH3IPNEWoJEtBHk8g8rV0grEMfuPSwstJKX3YWzUmciApdb
         jddMH8kOFgneibV5ZP9DmFlb60zud4xsk4SmxIh3b3g/zQTcY06vFRqjgChcmlnGS455
         2c5LtNUABjGjkCIufwwDs3zBFEXc5LAg3d6GHE9szZ9NuZJIs71xCwsfcLoRtVqv2HLH
         4ztA==
X-Gm-Message-State: AJcUukfCzl9eQZri2/hitjjxyALdjAUxu19kbAF82WHeya09eDIbAGcI
        y1uvhLwHaot7YAa/Q1jncGw7KgM6
X-Google-Smtp-Source: ALg8bN5lqtVoOawDiUoLDj0jVPS8eAPSBLUaxoPppgId4941sat0F9rBsoNwzzvjAi38nHsTNUxQ+w==
X-Received: by 2002:adf:b649:: with SMTP id i9mr22643729wre.70.1547426936377;
        Sun, 13 Jan 2019 16:48:56 -0800 (PST)
Received: from ?IPv6:2a01:5c0:e09f:91c0:e1e1:7176:b27b:4ae2? ([2a01:5c0:e09f:91c0:e1e1:7176:b27b:4ae2])
        by smtp.googlemail.com with ESMTPSA id 125sm44878277wmm.26.2019.01.13.16.48.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Jan 2019 16:48:55 -0800 (PST)
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
From:   Oliver Freyermuth <o.freyermuth@googlemail.com>
To:     linux-btrfs@vger.kernel.org
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=o.freyermuth@googlemail.com; prefer-encrypt=mutual; keydata=
 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
 KB7t2CoZv5xo0STm
Message-ID: <2dba4f49-2be5-694b-2676-0fa75a250e2d@googlemail.com>
Date:   Mon, 14 Jan 2019 01:48:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------1AC4C7E28D66A6BED8B0C6C2"
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------1AC4C7E28D66A6BED8B0C6C2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Am 13.01.19 um 22:51 schrieb Oliver Freyermuth:
> (resending with gzipped attachment)
> 
> Dear BTRFS experts,
> 
> I just upgraded to 4.20.1 from 4.19 (not sure if related) and my btrfs backup volume entered read-only mode when running btrfs-cleaner,
> i.e. when purging old subvolumes. 
> 
> I have attached the kernel log from when this happens. 
> 
> What is the best way to proceed from here? Running "btrfs check repair" on the device? 
> Worst case it's not a huge issue to lose the data stored there, it's my backup volume after all. 
> But it would be good to understand the cause and know if there is a better fix than starting from scratch. 
> 
> Cheers,
> 	Oliver
> 
> PS: Please include me directly in replies, I am not subscribed to the list. 
> 

Dear BTRFS experts,

attached is the output of "btrfs check -p /dev/sdc2". 
I can't guarantee the volume has never been cleanly unmounted. 

I found several past occasions of this here:
https://www.spinics.net/lists/linux-btrfs/msg69040.html
and here:
https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing
but without conclusive result. 

Please let me know what's the best way to proceed. From these links, it seems
btrfs check --repair
_should_ help, but I would prefer to get some advice first whether this is really the best approach. 

Cheers,
	Oliver

--------------1AC4C7E28D66A6BED8B0C6C2
Content-Type: application/gzip;
 name="btrfsck.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfsck.txt.gz"

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
BGNdPaKy5VfN0ijJ2AZaiV3vXBhjHDv2ZBSOjQLRsetyCBWZ99qhUTY2DtRpUYR4jTEo7nwz
aBRnBIGuMUJxy2hcfWZ0ztw1t9AoyEgEWmekxARjDlbVfgjzvYbQKPdiPCpQh5EQ04wuWPaz
+aBRsh7bQH1GLG4ZrXbeaR2596ehUZCRCETFNtraUn2eeykAGCVjt4HWq4YSE4wuZlUn+TCX
TkGjJGMbqMNIiAnGaEtH37Evp0OjJGMbqMNIiClGZ+uFH+4r8KBRlLEJ1GNsxSuMoYxmmMv4
oVGaEQa6wojENGM5pKrSh+MzTkZhRhSoz4jFLaPTdU6MZS8Xg0ZBRiLQOiMlJhmzNro0amY9
AqMsIw7UZWzEBGN971PSXjFv50OjJGMbqMNIiElGV1+/nZRSXMbZKMuIA3UZG/Fn8yn+dhbe
P/5++dXDsPbnnbox9sbpYXzYPh3G3Yc6SvJa5xP/4VzQuHu/+ecvv/z8y80wPj/vnw8N1fbh
YX+7Pd4XhtN22j8X58vjt8UXmy/l07fh9+f9y9NQ13snVQ6Yufaev24Pw4/nfYm7/V4KPg77
u+GuFnN42t6OHxafh9ttSXQy+GhLL39ZaP2/ur6JRm0um+i4Hx72211bwF0JuJpn89mCbdi4
222o3I0Ji23orMMb8Mf2+bGW9nD/OA7WZX9qKYdOxfhwo+yiUKWyyRGX+9nBsIe/VK7D5aam
XA/KvT28lG/f/bg/ft2/HIc/xuf7uz/rF7vtcfv+vBHSjVZzuWVrRtU2pM8BlHvaXUrbPqzn
VfXvIq+xTZkRlPnfl/1xe67Zw3D4dv/0VNrCu7o3jo/bL7Vh1Hb69f4w/Os/7zeXHdx478qA
7rQebPjy53E8DC+n3zs1+XeH9+dGvzmWsh9Om+OsuilWFcqg3od0+fJ8qLh8mZ126dTFu3xb
UIEgeG+qJJuLYHGkmH8ip2BSUGnz5Tg3xx/bw3HSuLpKoYhi3NyV1n+qmHMjP7zuhuPuZjA2
eavrlI/6UOtN3fZjOXzdlq1ijCm9l+jrrTe1+dvm/3fQ2XmIjQAA
--------------1AC4C7E28D66A6BED8B0C6C2--
