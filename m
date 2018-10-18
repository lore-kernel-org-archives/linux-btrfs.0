Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95DFC5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 12:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 876F22145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 12:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JN4XPrH4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 876F22145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbeJRUfw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 16:35:52 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:40498 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbeJRUfw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 16:35:52 -0400
Received: by mail-io1-f50.google.com with SMTP id w16-v6so20847795iom.7
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 05:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=s3UP+rfLsvxTIvaxxMxQ4OrsBu8A1clOltuia+qFsJU=;
        b=JN4XPrH4KtnW+R8x9PDInZvBmaNf5lavEyrnJkdEWKtdQLGLyqqoJZ2pM2aeRrWx3C
         SLMBi5TTgE0/9l7A8pHI9d+f8kUx/OwprX4vBUp+Xm2YJw3Tys5n9Vv6UutBdeSOwjjc
         XhVVsq/Xb3G3bx3XX4wFZb8s4JTVc5hzBX5+GY4w8FL16GH4cAB5Ki34hkWce8+NPJ0E
         gDUMNIMOVC4xafh5EHhRLde+GwcIMI0za09q3HPM2Q3isge3PdW1IOAMTcJF1Sr5LUH1
         GHHHFStAfGCoZDhM7nDd326R2U/bJVgudLZ59xprQOol72U/Ho4CkV8xITZiMANCunBT
         BcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s3UP+rfLsvxTIvaxxMxQ4OrsBu8A1clOltuia+qFsJU=;
        b=jK/BhQLMdCX7OjCuQ+p15/E/GImmGe4dUu6/hLMVddOOTvbeSFwm3BY7KZFkXkoOkr
         TqN7lklxC6J459X90YSvSKQUA9pZ/1H6FPUvmYKlsEm6Vm/vmIkXYPEpW2ATKruBKhb8
         dTESTTbCQrJMMKFDzTn4a7ixZNfYq+lpNIdn27MaFsC9q7ojnag6UpQRb1+iCmmijtXR
         FNgseHoBNXsl7AAfNblntdyjbDND2Mxn+QEiW4HYPNEPZpkWakX1ldJEx9Ndvr9dliAS
         ihDjQ3NEoyfy0fP8MHyzGux4Os9pMZzy1nqwHd46nkwoannOKS5h1kxra/xg6J/0oASi
         /7gw==
X-Gm-Message-State: AGRZ1gIybh2eddDiUCI/YJNfgHZVRQx9v8wEPb4gRvI8B8mCq1kpUM7T
        GYQZxFoK9kJgHXKA/CKyP8t1kCSZuSqexw==
X-Google-Smtp-Source: AJdET5fIgzfX9yZr6DV8jOC17a10oEq0jKC6RKtbBTRySv3HlzWLSTCv4AqLNIEY54/6rmzDzdj4CQ==
X-Received: by 2002:a6b:7d01:: with SMTP id c1-v6mr38337ioq.251.1539866102064;
        Thu, 18 Oct 2018 05:35:02 -0700 (PDT)
Received: from [191.9.213.3] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id q205-v6sm832769itc.2.2018.10.18.05.35.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 05:35:00 -0700 (PDT)
Subject: Re: CRC mismatch
To:     Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
References: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
 <20181018150228.16680172c2551c06038d5344@gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <42f3ecf9-9e43-62ca-80b6-720ba23ba230@gmail.com>
Date:   Thu, 18 Oct 2018 08:34:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181018150228.16680172c2551c06038d5344@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 18/10/2018 08.02, Anton Shepelev wrote:
> I wrote:
> 
>> What may be the reason of a CRC mismatch on a BTRFS file in
>> a virutal machine:
>>
>> csum failed ino 175524 off 1876295680 csum 451760558
>> expected csum 1446289185
>>
>> Shall I seek the culprit in the host machine on in the
>> guest one?  Supposing the host machine healty, what
>> operations on the gueest might have caused a CRC mismatch?
> 
> Thank you, Austin and Chris, for your replies.  While
> describing the problem for the client, I tried again to copy
> the corrupt file and this time it was copied without error,
> which is of course scary because errors that miraculously
> disappear may suddenly reappear in the same manner.
> 
If The filesystem was running some profile that supports repairs (pretty 
much, anything except single or raid0 profiles), then BTRFS will have 
fixed that particular block for you automatically.

Of course, the other possibility is that it was a transient error in the 
block layer that caused it tor return bogus data when the data that was 
on-disk was in fact correct.
