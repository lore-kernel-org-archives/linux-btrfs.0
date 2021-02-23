Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F99C433DB
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E0A64DF3
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhBWSAY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 13:00:24 -0500
Received: from smtp-35.italiaonline.it ([213.209.10.35]:41489 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233065AbhBWSAY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Feb 2021 13:00:24 -0500
Received: from venice.bhome ([78.12.28.43])
        by smtp-35.iol.local with ESMTPA
        id EbyIl4C2npK9wEbyIlsah7; Tue, 23 Feb 2021 18:59:42 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614103182; bh=BZgEj/S8yHMb/WudboVndT0uA3/wntR2X0UgadJtamY=;
        h=From;
        b=nR4mJ7r/2oQp/Gz2qSqojJ6VyqiH7KZs72Qib0z2gtvWiHo7Gz5fzHU75JZpfSC0R
         +peSl3ix5qa6RME2iNSwWHdJkSO0FQo57s4BzekPGwMOpL8RB314OZRG//ECzSlQAs
         FbHSlxwppFLnOeHIwrA3S5tP98kPp1xmjdzBYU3tpRjubejioBl1M789WIYH+kgQu7
         1foGihyLMZ0VjfRRO1tpQB5Zwum/PbEFoegEF0ah6CO3+qmwH60/7R6Y8e4uHmbFi5
         0MFwko0G15VXxp1JOOBoYM2BFku9ZONFoFgyo4DcwejZAWoapolXP6MtTEhSfiYfda
         QdiTi+WtWrooQ==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=6035428e cx=a_exe
 a=Q5/16X4GlyvtzKxRBiE+Uw==:117 a=Q5/16X4GlyvtzKxRBiE+Uw==:17
 a=IkcTkHD0fZMA:10 a=u_ao1BzJJDxruMQh9pUA:9 a=QEXdDO2ut3YA:10
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 1/4] btrfs: add ioctl BTRFS_IOC_DEV_PROPERTIES.
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <cover.1614028083.git.kreijack@inwind.it>
 <d48a0e28d4ba516602297437b1f132f2a8efd5d2.1614028083.git.kreijack@inwind.it>
 <20210223135330.GU1993@twin.jikos.cz>
From:   Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <73fa4d2c-2593-5db2-c9b2-3adb34fb51b4@libero.it>
Date:   Tue, 23 Feb 2021 18:59:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223135330.GU1993@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKFuZ2gT3qjQiyUtpX05UMvwsSYeX9ceNikBD7vMaxEvr7vrk1bL29U2s1I2f6tuEpGeNvrV7Js9gOETQyooQYPqEDzk/8kzr3itQM0DfVBTLqVsOmU0
 x92ECkC91xU8eMRr8QzbjPCDGD/Goac8EHqF7wvzWGGgmYDMr3UvXfcV5TMToS8EpEVg530Hdc4CHGWXrdJlQ6GIo9jV8/0biB0BNmNOBhUeYNSvr/lWrN8Q
 npEU0unU0Oij8NJACQKhCQ==
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/23/21 2:53 PM, David Sterba wrote:
> On Mon, Feb 22, 2021 at 10:19:06PM +0100, Goffredo Baroncelli wrote:
>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>
>> This ioctl is a base for returning / setting information from / to  the
>> fields of the btrfs_dev_item object.

Hi David,

> 
> Please don't add a new ioctl for properties, they're using the xattr as
> interface alrady.
> how it is supposed to work with a device ?

I have to point out that the property is already exported in sysfs.
However I read a comment in sysfs code that discourages
to make a filesystem updating (open a new transaction) in the sysfs
handler. Do you have any suggestion ?

Thanks in advance
BR
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
