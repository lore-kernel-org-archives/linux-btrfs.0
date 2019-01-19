Return-Path: <SRS0=mgXs=P3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB19C61CE4
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 20:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 952802086D
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 20:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XP4GIOyD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfASUeo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 19 Jan 2019 15:34:44 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:40040 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbfASUeo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Jan 2019 15:34:44 -0500
Received: by mail-lf1-f48.google.com with SMTP id v5so12882874lfe.7
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Jan 2019 12:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73SvAck1IagvxqyGzyPF9+NA3LJQY3TnylATyxEPw28=;
        b=XP4GIOyDBqbC4T/MU0VuQBaHmWz4c9u/PuiESRYB/9BEGYW2R5SQslL4+D23xOsjUp
         qESRUio5pXu29s1DNHEnYsbRAcKpKoxjFIAseIjuunDYNrylppTYrA8UP8aF+W4mXeVA
         hC2T/o8iFrGp1SBD/fCIkzbSyZcrtwfYT56lyo6HeKtBWYkOK+E+fMPi3qiNtXdidJ7M
         7zpNXCI/8OeGkIj+5UBaIDzClm5Vk1FdXycHF6asqo+MFB0kT6cMRmmCW4YHXk2t7BgA
         8Vpe5zGRKSu6d9jff5LZHO86tfxiFYjEnoaYF+v6Avr1q23seX7rDs4233lrJPbrKR3P
         Lmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=73SvAck1IagvxqyGzyPF9+NA3LJQY3TnylATyxEPw28=;
        b=IgT2arxLctVGZezQ+9TRo+ITM9Qw9qFM/Abw6Uct9RuaxoQPZTyxQSRudpogzd6c29
         HQnW8H5N4ULhwzyWiZoanlWCGMzrofEXbPTk1njDcasL2n+vlm6wzlajVI2PhwqjBhub
         DcBJmx4dvlEafX8fCv28N29SRymlJc5r/u9S6uIfOeAbPgSyjGAIz86Sqf8smodQOghT
         DbovpOcQmxOWFbG36o1hRbxWWownjwPO4Ns1L8UlbPQepRwNmGFiN6Gawwg6kym0T5aB
         BGOf9ylFVkE64pA7qV98J0DBQnToHfogj+ZkxUm+0cpF7EojQOcXb2pPwjJCnSZr9Mkj
         Rj1g==
X-Gm-Message-State: AJcUukdiMReZPVKISE2tpChm5GkgaYDJDhoQlFCkoPSDDwrUB9H9AXaM
        Z0VQm908gBdeHELGLlg9ksM7Yt/S
X-Google-Smtp-Source: ALg8bN5zp2GieiLX7KxWbIVmeWkeI9gavcd6Vcw1A4LhzWglf/VfRPtaLXedSlVEUJcsX6ppwway5Q==
X-Received: by 2002:a19:d5:: with SMTP id 204mr14519298lfa.116.1547930081583;
        Sat, 19 Jan 2019 12:34:41 -0800 (PST)
Received: from [192.168.1.4] ([109.252.90.29])
        by smtp.gmail.com with ESMTPSA id u15-v6sm1530373lja.63.2019.01.19.12.34.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 12:34:40 -0800 (PST)
Subject: Re: RAID 6 stable?
To:     Hans Kraus <hans@hanswkraus.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <c41a1da0-9986-413d-6b22-4183188fd8aa@hanswkraus.com>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=arvidjaar@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBDxiRwwRBAC3CN9wdwpVEqUGmSoqF8tWVIT4P/bLCSZLkinSZ2drsblKpdG7x+guxwts
 +LgI8qjf/q5Lah1TwOqzDvjHYJ1wbBauxZ03nDzSLUhD4Ms1IsqlIwyTLumQs4vcQdvLxjFs
 G70aDglgUSBogtaIEsiYZXl4X0j3L9fVstuz4/wXtwCg1cN/yv/eBC0tkcM1nsJXQrC5Ay8D
 /1aA5qPticLBpmEBxqkf0EMHuzyrFlqVw1tUjZ+Ep2LMlem8malPvfdZKEZ71W1a/XbRn8FE
 SOp0tUa5GwdoDXgEp1CJUn+WLurR0KPDf01E4j/PHHAoABgrqcOTcIVoNpv2gNiBySVsNGzF
 XTeY/Yd6vQclkqjBYONGN3r9R8bWA/0Y1j4XK61qjowRk3Iy8sBggM3PmmNRUJYgroerpcAr
 2byz6wTsb3U7OzUZ1Llgisk5Qum0RN77m3I37FXlIhCmSEY7KZVzGNW3blugLHcfw/HuCB7R
 1w5qiLWKK6eCQHL+BZwiU8hX3dtTq9d7WhRW5nsVPEaPqudQfMSi/Ux1kc0mQW5kcmVpIEJv
 cnplbmtvdiA8YXJ2aWRqYWFyQGdtYWlsLmNvbT7CZQQTEQIAJQIbAwYLCQgHAwIGFQgCCQoL
 BBYCAwECHgECF4AFAliWAiQCGQEACgkQR6LMutpd94wFGwCeNuQnMDxve/Fo3EvYIkAOn+zE
 21cAnRCQTXd1hTgcRHfpArEd/Rcb5+SczsBNBDxiRyQQBACQtME33UHfFOCApLki4kLFrIw1
 5A5asua10jm5It+hxzI9jDR9/bNEKDTKSciHnM7aRUggLwTt+6CXkMy8an+tVqGL/MvDc4/R
 KKlZxj39xP7wVXdt8y1ciY4ZqqZf3tmmSN9DlLcZJIOT82DaJZuvr7UJ7rLzBFbAUh4yRKaN
 nwADBwQAjNvMr/KBcGsV/UvxZSm/mdpvUPtcw9qmbxCrqFQoB6TmoZ7F6wp/rL3TkQ5UElPR
 gsG12+Dk9GgRhnnxTHCFgN1qTiZNX4YIFpNrd0au3W/Xko79L0c4/49ten5OrFI/psx53fhY
 vLYfkJnc62h8hiNeM6kqYa/x0BEddu92ZG7CRgQYEQIABgUCPGJHJAAKCRBHosy62l33jMhd
 AJ48P7WDvKLQQ5MKnn2D/TI337uA/gCgn5mnvm4SBctbhaSBgckRmgSxfwQ=
Message-ID: <d299b5de-0693-51cf-90ca-fafc14153504@gmail.com>
Date:   Sat, 19 Jan 2019 23:34:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c41a1da0-9986-413d-6b22-4183188fd8aa@hanswkraus.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

19.01.2019 19:07, Hans Kraus пишет:
> 
> A second question: the ZFS docu recommends very strongly to use ECC
> memory on machines with ZFS RAID-Zn. Holds these arguments true for
> BTRFS as well?
> 

This is simply true. For any use case. It is always better to have ECC
memory than memory without ECC.
