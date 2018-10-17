Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51909ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 11:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1480F21526
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 11:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvvo0Qmc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1480F21526
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbeJQTzI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:55:08 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:38504 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQTzI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 15:55:08 -0400
Received: by mail-io1-f49.google.com with SMTP id n5-v6so18608229ioh.5
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 04:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5o9y5h7TVQ/kt4eKK1MAer4HTWH9C4kGFnUDzQ5erzk=;
        b=bvvo0QmcOnyZGThK8eR7orUHMns9W1Fnu7jT8Plvc9g42bRbDPH17QL5/eS5WBpdSC
         lTauB5j0UO/tTA0l1DyKt46Kw9CpCOB87Vo5GrzhPvav9zxH6HKrd1gPrI2amORkKfgi
         FPSxM47N8rYPAm0vdokGuCg2E7wwkXeCtvEQ9iEJ7ddRNuSOOm/Qi9C0jN2jQWstFy7F
         tQG8ePrp+tCy+e+mNe4mOOBnQHkERkAlmI1XwuI0RRELe74pM+hFZ7mAKbkGjfOp3wg/
         83msI8gKqYr1L2OT9VxUDrvyBzOmlLxIGEfGW2wcIKuL+82XP4rZ9BbQZc2fm5wjG3YK
         SKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5o9y5h7TVQ/kt4eKK1MAer4HTWH9C4kGFnUDzQ5erzk=;
        b=uMcvsvF8t3OVwZt69RjCKn+xZoEvsP3gjTDB7iPIk6xcKuxSaFnxa7IB8w1jsgxk8i
         0AckESWbXIno4rE6YiyNDW93vmIW9ldP1Xz0RwFSPNsG2lVLR7qRzFUss4AW8jv3iSHg
         oQUJGVW3cAEfN6OGVJGbFPRG0Dp9BJhjHtBWzLMtDFxi0DYdokcCbauJi0JfYjixAKMW
         v8ZwxlGX2e74qDqsDb/YoJcWkAsASXDtjccHvKEGbrqy4gkEAjEwSx9T6hfFgEmMLtN3
         hu538s+g81R7wPjX2CN1BnJ0igdtD0syl1y1/ARdlIqmvdrxyQxw++nf0JZL4lhapHq1
         a2Zg==
X-Gm-Message-State: ABuFfogXdTmJVE7PZjsqciAc/VewsjDgkurAK9YhwBTkmGitJocQCapw
        VmyLtJMEGJOXuWpOVZWUDASdPOK9X5oQMQ==
X-Google-Smtp-Source: ACcGV61jJpT1IGDOA7DjL41fqtzOxA/zBGSgCWqVbz0n4ztEJNx/kQOxmyf8jgnRMUlKctcSXf6CzQ==
X-Received: by 2002:a6b:1505:: with SMTP id 5-v6mr17368610iov.56.1539777584120;
        Wed, 17 Oct 2018 04:59:44 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id q123-v6sm5815784iod.23.2018.10.17.04.59.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Oct 2018 04:59:42 -0700 (PDT)
Subject: Re: CRC mismatch
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Anton Shepelev <anton.txt@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
 <f2df5862-ae3e-5808-4f00-e153f604df60@gmail.com>
 <CAJCQCtRrqOf+AzkH+-z++GTx9+Mh0-wA5PqQB9g0kDhBBCJ2qQ@mail.gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6e6fc20f-94ef-55e6-66da-cc6947b86ce9@gmail.com>
Date:   Wed, 17 Oct 2018 07:59:39 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRrqOf+AzkH+-z++GTx9+Mh0-wA5PqQB9g0kDhBBCJ2qQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-16 16:27, Chris Murphy wrote:
> On Tue, Oct 16, 2018 at 9:42 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2018-10-16 11:30, Anton Shepelev wrote:
>>>
>>> Hello, all
>>>
>>> What may be the reason of a CRC mismatch on a BTRFS file in
>>> a virutal machine:
>>>
>>>      csum failed ino 175524 off 1876295680 csum 451760558
>>>      expected csum 1446289185
>>>
>>> Shall I seek the culprit in the host machine on in the guest
>>> one?  Supposing the host machine healty, what operations on
>>> the gueest might have caused a CRC mismatch?
>>>
>> Possible causes include:
>>
>> * On the guest side:
>>    - Unclean shutdown of the guest system (not likely even if this did
>> happen).
>>    - A kernel bug on in the guest.
>>    - Something directly modifying the block device (also not very likely).
>>
>> * On the host side:
>>    - Unclean shutdown of the host system without properly flushing data from
>> the guest.  Not likely unless you're using an actively unsafe caching mode
>> for the guest's storage back-end.
>>    - At-rest data corruption in the storage back-end.
>>    - A bug in the host-side storage stack.
>>    - A transient error in the host-side storage stack.
>>    - A bug in the hypervisor.
>>    - Something directly modifying the back-end storage.
>>
>> Of these, the statistically most likely location for the issue is probably
>> the storage stack on the host.
> 
> Is there still that O_DIRECT related "bug" (or more of a limitation)
> if the guest is using cache=none on the block device?
I had actually forgotten about this, and I'm not quite sure if it's 
fixed or not.
> 
> Anton what virtual machine tech are you using? qemu/kvm managed with
> virt-manager? The configuration affects host behavior; but the
> negative effect manifests inside the guest as corruption. If I
> remember correctly.
> 

