Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18F4C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 21:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43A7A2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 21:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inwind.it header.i=@inwind.it header.b="O1fScDrK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfCRVNo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 17:13:44 -0400
Received: from smtp-18.italiaonline.it ([213.209.10.18]:43617 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727132AbfCRVNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 17:13:44 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2019 17:13:42 EDT
Received: from venice.bhome ([94.38.191.48])
        by smtp-18.iol.local with ESMTPA
        id 5zRrhdBcjsCsa5zRrhx0E0; Mon, 18 Mar 2019 22:05:32 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inwind.it; s=s2014;
        t=1552943132; bh=zBgkKtE1/I5/Et1q2GwqcWeD6930sz+TbOG4heYk3Wg=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=O1fScDrK8Dan7bDkdXdxms4nsGGGkZxbVTae4quMKm7dG2pvLrJUESCsPSizxn6rU
         P5491OQhX0uNB0TCFfKCCEZKo1Z9V/CpEdIO1+Y6kUslHpwg22lBmBfEIQ90HMw/7E
         czFSWKepJ/nQBplxvokSrPsxyz/tN9LM82JOxaxWzKCOMkuribz5Wc1BXI4/g04DLo
         L/psKU+e7Ks35TkmF6NyI0f+P/BXdmymhwx3LTfzqkClOFUf4SVAGsPNnpw1JDy8Oy
         tMu+LEmqY2GXc8m4yfMGyIBNXNJgZgbPJH+08hzJZ96RfwPuHCOrb/p7zxHUxdGusm
         +/uNFYP7O8xzQ==
X-CNFS-Analysis: v=2.3 cv=E6ccWpVl c=1 sm=1 tr=0
 a=LSmNtxrrF1VkTiQg1w8xYQ==:117 a=LSmNtxrrF1VkTiQg1w8xYQ==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=AwZj9w5X27oU-0GwW04A:9
 a=QEXdDO2ut3YA:10
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 1/1] btrfs-progs: fi usage: implement raid56
To:     =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
Cc:     linux-btrfs@vger.kernel.org
References: <20190317125150.26265-1-stephane_btrfs@lesimple.fr>
 <20190317125150.26265-2-stephane_btrfs@lesimple.fr>
 <8679eb74-8c98-d54d-f69e-821a6eba1cd9@libero.it>
 <26c40d46f4278edeb2604e26fda957ee@lesimple.fr>
From:   Goffredo Baroncelli <kreijack@inwind.it>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@inwind.it; keydata=
 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
Message-ID: <d35246f7-4506-7777-5d63-9712c20aae67@inwind.it>
Date:   Mon, 18 Mar 2019 22:05:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <26c40d46f4278edeb2604e26fda957ee@lesimple.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNl0MGQyTioNN1mBg/zr9rx7a4x6bGh835nmt0JLLhZI0nDgQVbCO34EVzEMi1cQaPOZoZ7++XkPlgS0XqL9Qbo7+0E5T5Id/o//izdA+4e87e2026si
 bCE85ClX4W9Gyn+RJTGF53XHPoy4Xu+mOGXaVGJ5FxPeeD8z3Y7P5BLxGQuZLvoI1P2fIR2BylthxWslbM/T0BISXlsr1cwsP8s=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 18/03/2019 20.12, Stéphane Lesimple wrote:
> Le 2019-03-17 19:41, Goffredo Baroncelli a écrit :
>> On 17/03/2019 13.51, stephane_btrfs@lesimple.fr wrote:
>> [...]
>>> -        if (!ratio)
>>> -            warning("RAID56 detected, not implemented");
>>> -
>>
>> IIRC one of the problem which lead to this code was that the not root
>> user cannot
>> access to chunkinfo. So the (regular) user should be warned about
>> that: the printed info may be not correct.
> 
> 
> I think you may be referencing this other warning:
> 
>         ret = load_chunk_info(fd, chunkinfo, chunkcount);
>         if (ret == -EPERM) {
>                 warning("cannot read detailed chunk info, per-device usage will not be shown, run as root");
> 
> This one is still present, and matches exactly what you say:
> it fires when btrfs fi usage is run under a non-root user.

Perfect ! I missed this part

BR
G.Baroncelli

> 
> The "RAID56 detected, not implemented" warning, on the other hand,
> is displayed even under the root user, and indicates that it's normal
> that most of the counters of "filesystem usage" are at zero, because
> the code to compute these properly under raid5/raid6 isn't there yet,
> and it's actually precisely this missing feature that my patch tries to add!
> 
> Thanks,
> 
> Stéphane.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
