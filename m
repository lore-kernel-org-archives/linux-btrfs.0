Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98241C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68FB1207E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmCM0H7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfA3QA7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:00:59 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:38205 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730688AbfA3QA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 11:00:59 -0500
Received: by mail-io1-f54.google.com with SMTP id l14so19159ioj.5
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 08:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=M8irxGkGp/WzxpmU/zoSY67b4bupddk07FEGyZXaSkI=;
        b=UmCM0H7lvBfJKgzC+huOp2i69Fday+LnP5hHaTxqiss0ywlv6CMaT+hZ0jpkyz0hHm
         wUoQo2dm3cdpmQkN22IIaypThQnmTHOFP5pLWaRsxqmPyVJ7utYfTbviKorGSrZzasQX
         XtN+jrp8fSFZPgSqNeMqVClhZha8uI4kt34qNjpG3TI/MW1i/wxiJdo6ey4l34/wEC/f
         nqat6aaCH5khlG0C6vDeAHFY/XDgIkPgFe9liEmnWja3HqeTlSF9D8aK/cWXuI7QhjbN
         /1Q1fgMEqAejt6VmquEtzO7IauDrCP0mfCO+W7ZMzXfqg80a2xeHMYrmQ4NOGWbmf9NB
         XM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8irxGkGp/WzxpmU/zoSY67b4bupddk07FEGyZXaSkI=;
        b=YZeZzEFVfLiGvqoJp9HJl+mab6YMVSeWt7d0Zghxp/pS5pnnZ4pmRo+rV16fTQQ6eq
         MeD6anjOEhTB/5soYYiOomyolIKbx6HZt6lM94Rdtn3DWRmRjVfqSUNqn3VFwGeKAXpu
         eBgYmZgppkYNhCIpukMeSH7C6aabLdiXglm/ZxmFzNdIsLO8LY+UZXjQQsndjVYCKG1h
         rgJf/xqiqYf39B3Sgi8fCKUNGdYwNSYRRaM2g30xRoUDTEFSHYIHBm5Dhnl1Ix+yWJ8Y
         KLXgF8yT6aOXtf7sV0iNpTsHYUhRdAx+bOuLikd7SHTaLKHMo+7lQozcSBPJUS4oQgPr
         yTVA==
X-Gm-Message-State: AHQUAube2gzKt8TxY/cO9S7dqvQhY+Wlux9m7lL2TUCA41hi314YlM/1
        IPvMaUvMWLRk9MSCORoP1LHQv0IMpN0=
X-Google-Smtp-Source: AHgI3IZA4SG2JxJ/qHR1IwWefyxVZzO5jEecDOmcejFukz/gUmgu4hhZscKi0+05+IqBDdGZUkSQKw==
X-Received: by 2002:a6b:5103:: with SMTP id f3mr19109584iob.30.1548864057214;
        Wed, 30 Jan 2019 08:00:57 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f4sm786712iop.70.2019.01.30.08.00.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 08:00:56 -0800 (PST)
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
To:     Christoph Anton Mitterer <calestyo@scientia.net>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
 <5c11b6a4-de3d-2ba0-c5c6-65ea04cd0245@gmail.com>
 <6ce96b57897acb62101dd213f8127ffeb981ee90.camel@scientia.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f7a55647-ac67-4a6d-ca7e-bf3ed05428fb@gmail.com>
Date:   Wed, 30 Jan 2019 11:00:54 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <6ce96b57897acb62101dd213f8127ffeb981ee90.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-30 10:26, Christoph Anton Mitterer wrote:
> On Wed, 2019-01-30 at 07:58 -0500, Austin S. Hemmelgarn wrote:
>> Running dm-integrity without a journal is roughly equivalent to
>> using
>> the nobarrier mount option (the journal is used to provide the same
>> guarantees that barriers do).  IOW, don't do this unless you are
>> willing
>> to lose the whole volume.
> 
> That sounds a bit strange to me.
Probably because I forgot to qualify the statement properly and should 
have worded it differently.  It should read:

Running dm-integrity on a device which doesn't support barriers without 
a journal is risky, because the journal can help mitigate the issues 
arising from the lack of barrier support.  So, make sure your storage 
devices support barriers properly first.
> 
> My understanding was that the idea of being able to disable the journal
> of dm-integrity was just to avoid any double work, if equivalent
> guarantees are already given by higher levels.
Except they aren't completely if the storage device doesn't support 
barriers properly.
> 
> If btrfs is by itself already safe (by using barriers), then I'd have
> expected that not transaction is committed, unless it got through all
> lower layers... so either everything works well on the dm-integrity
> base (and thus no journal is needed)... or it fails there... but then
> btrfs would already safe by it's own means (barriers + CoW)?
BTRFS is _mostly_ safe.  The problem is that there are still devices out 
there that don't have proper barrier support.  Without barriers, the 
superblocks can hit the disk before the most recent transactions do, and 
in that case you're kind of screwed.  dm-integrity's journaling can help 
protect against this to a limited degree (it doesn't completely solve 
the issue, but it's better than nothing), but at the cost of higher 
overhead from duplicated work.
