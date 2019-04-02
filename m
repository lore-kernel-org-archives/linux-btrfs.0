Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2869FC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 14:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8712084B
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 14:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="jWdxjJvo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbfDBOFN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 10:05:13 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:60514 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfDBOFN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 10:05:13 -0400
Received: from [192.168.99.127] (unknown [93.241.30.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 127F447C38BF;
        Tue,  2 Apr 2019 17:05:11 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554213911;
        bh=5qrbJrEWg4ZOjpt4wLdjqPr7WP6jP2J4zIRsgwGUlko=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=jWdxjJvoZjo13KToKtJB83jCtVaIyNqnhpX/rQh5MfF4QWDEXFyzBejMSRsXktFdL
         v44chguF+ePJiytk5gr6jH5i3hL6RUqMz6ndYOdCbN5Y1N04e5pYzKygMjgxmuwkue
         1Jr2EXdwMsXi3RIWw8LrILRwZQ1YGDg+QiGiT+Ext2pxcr/GWvdKQVj7a80zPcDCdB
         7DUNFDtgDEKgsgvQtEMtQXQ3Vr4TDkecybDKql4cx3NzQtyIpUKfv0yncT4yUR28Sx
         ElEzLN8DK/xokPOdCwVIrDW2D+Wyn4vPlusWAwXCNb+bflpCgLYewyczJLwS08wg2Z
         kEksn1Z5kJ9MQ==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Hugo Mills <hugo@carfax.org.uk>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <20190402132920.GA29117@carfax.org.uk>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <d1b57363-7d57-93e8-4c66-01deddf6aefd@avgustinov.eu>
Date:   Tue, 2 Apr 2019 16:05:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190402132920.GA29117@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

of course it complains, it was a typo from me, sorry. The real command 
was "btrfs check --readonly ...", just to ensure that no writing takes 
place.
	Nik.
--

2019-04-02 15:29, Hugo Mills:
> On Tue, Apr 02, 2019 at 09:24:03PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/2 下午9:06, Nik. wrote:
> [snip]
>>> On the larger file system only "btrfs check --repair --readonly ..." was
>>> attempted (without success; most command executions were documented, so
>>> the results can be made available), no writing commands were issued.
>>
>> --repair will cause write, unless it even failed to open the filesystem.
> 
>     If btrfs check accepted both --repair and --readonly without
> complaining, then that's a regression and a bug. --readonly should be
> mutually exclusive with any option that might write to the FS, and if
> it isn't any more, then it's been broken and needs fixing.
> 
>     Hugo.
> 
