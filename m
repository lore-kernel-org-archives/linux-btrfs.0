Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45BAC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93C0F222D0
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="saWDJxGG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbfBOTzS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:55:18 -0500
Received: from mail-it1-f169.google.com ([209.85.166.169]:50566 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbfBOTzS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 14:55:18 -0500
Received: by mail-it1-f169.google.com with SMTP id z7so27049903iti.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 11:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8J39SYL6CZryhxGgO3jbz1ah8gq7JFwciVZTWzs3DTI=;
        b=saWDJxGGmbHnaoB4Sm2uC8++rIGRz1YmpJQA1F0VOjN0w71csJmplDrXf7eEnNbOpx
         MaVSKU+C5VRE98GPQtLtpniGIYFUrhmRZsoMax2x2wtBsopRxiT95pPh4ztMApuueIK2
         QEHMbManr/q5bymG2vGjx85REX+VdTnch4y9V/tAs8pwi4DUUe5t06R6+U4jjOrHVmnX
         mKBU6PnNaIMNZHXUweg0jT8af1MgkCcOWzLeRXS8U2OMwNjZ8PA2xifSLS1xbo75Zp7g
         ucI7Kku66DkCNq5id6Ln6HPs24WpCAzWoymVEmp8qD2F+NDAR7yNo/nDz8IOOp2yJhWo
         8SNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8J39SYL6CZryhxGgO3jbz1ah8gq7JFwciVZTWzs3DTI=;
        b=B4DSNRg+fvrmQlDD/MntW8b8xghXZUnMGiAlRoePsQjuXsTjtcJBvhoxemgHxqpFhx
         ShylNpwqlNWCGJXZeXyQQN5l7pSzhByDbEHCzBPfvG1vaSxPOjSrcEN3k3bDkReaz2ah
         dnexh2yTVS3iRBpxnxkBQG+qWEpoukn5WvbfL9WLhPadOex2euJVfPn7GskNT3vIyTLt
         BJ7KrxP/rZH0R8Jb5u4NyH85xDcLkQyXJ7r3+slGHh6nidIDZ8PEzhIMaH+dXf18Owql
         7u/XOFD3O7CS+qFaeEd8d4Z3Pdp9ivbgxik3OtPCXV3Ye6TnA39M5YEbUrIPUbGYjmPO
         aIFg==
X-Gm-Message-State: AHQUAuaAEeD/QpuEGlav32eHy5pHOuOcg1YRkrjiCiZUBcdZ3mSQLV1U
        pCYsRfX6f0oXo0ZGr3K8UnfCown60ig=
X-Google-Smtp-Source: AHgI3Ib834OasZD1q5i7Qazh5rco5Z0/Blx0TI21YA3k6fMCqsOobtrZioRn4x85R+Bp43rIaHCHHw==
X-Received: by 2002:a24:c486:: with SMTP id v128mr4805216itf.138.1550260517129;
        Fri, 15 Feb 2019 11:55:17 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id q64sm2892367iod.48.2019.02.15.11.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 11:55:16 -0800 (PST)
Subject: Re: Better distribution of RAID1 data?
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     Brian B <brian@sd85.net>, linux-btrfs@vger.kernel.org
References: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
 <91c2c290-5796-3f18-804e-0c19ae17f1db@gmail.com>
 <20190215195035.GD9995@hungrycats.org>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <43af782e-4648-5758-9e3f-9e94e81310f3@gmail.com>
Date:   Fri, 15 Feb 2019 14:55:13 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190215195035.GD9995@hungrycats.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-15 14:50, Zygo Blaxell wrote:
> On Fri, Feb 15, 2019 at 11:54:57AM -0500, Austin S. Hemmelgarn wrote:
>> On 2019-02-15 10:40, Brian B wrote:
>>> It looks like the btrfs code currently uses the total space available on
>>> a disk to determine where it should place the two copies of a file in
>>> RAID1 mode.  Wouldn't it make more sense to use the _percentage_ of free
>>> space instead of the number of free bytes?
>>>
>>> For example, I have two disks in my array that are 8 TB, plus an
>>> assortment of 3,4, and 1 TB disks.  With the current allocation code,
>>> btrfs will use my two 8 TB drives exclusively until I've written 4 TB of
>>> files, then it will start using the 4 TB disks, then eventually the 3,
>>> and finally the 1 TB disks.  If the code used a percentage figure
>>> instead, it would spread the allocations much more evenly across the
>>> drives, ideally spreading load and reducing drive wear.
> 
> Spreading load should make all the drives wear at the same rate (or a rate
> proportional to size).  That would be a gain for the big disks but a
> loss for the smaller ones.
> 
>>> Is there a reason this is done this way, or is it just something that
>>> hasn't had time for development?
>> It's simple to implement, easy to verify, runs fast, produces optimal or
>> near optimal space usage in pretty much all cases, and is highly
>> deterministic.
>>
>> Using percentages reduces the simplicity, ease of verification, and speed
>> (division is still slow on most CPU's, and you need division for
>> percentages), and is likely to not be as deterministic (both because the
> 
> A few integer divides _per GB of writes_ is not going to matter.
> raid5 profile does a 64-bit modulus operation on every stripe to locate
> parity blocks.
It really depends on the system in question, and division is just the 
_easy_ bit to point at being slower.  Doing this right will likely need 
FP work, which would make chunk allocations rather painfully slow.

