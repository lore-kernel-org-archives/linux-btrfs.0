Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC30CC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 13:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 816CC218CD
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 13:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TsAkLI5i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbfABN7g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 08:59:36 -0500
Received: from mail-io1-f53.google.com ([209.85.166.53]:43399 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbfABN7g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jan 2019 08:59:36 -0500
Received: by mail-io1-f53.google.com with SMTP id b23so3618304ios.10
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jan 2019 05:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jCLpmvzD1DvFaJuHDkF47YbR2BuVeJT7AQFH0OOGCpg=;
        b=TsAkLI5ityNfOVI2OxzdJFzeEOZe/kasgk0pMav1mQWdsCL4iv6/iGPoo0C8FTPZ8+
         wpiC3NpJwf2A0WWmKrmd4tlCgGfGOuRgoqWorYK6Gfe36OWIHYO6hWNN1mS2/xhTSU6b
         84kobGPCt2o9WWUoBNh/myBwCLNw3nyX2CKzunkjbtvIn/B/WayEbKH0NrtSyI0CWnRl
         BzzlMcUpA5Kxt09u7UrS1FOfL/nOKx2Dl3x8FxoUroRYUllGgh/34qI2s+wU7kcRbhgs
         sv2UxDt4dWjgkdUaGTsrnlqIEZtvkjF7lGP/3u+f3yjnLlow8r24zyWSVH6hHq3Lqvf/
         tjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jCLpmvzD1DvFaJuHDkF47YbR2BuVeJT7AQFH0OOGCpg=;
        b=MwOrqpRsVdWJxYc60zSD7vxH7Rfm7cnavVXF9sI+CwnLTMIose9zrAlqoCJi5vYsTR
         ZR3fZ8QI8LemcxuzPNn5zwhEtMpfJ61HxV1mLMmcSGdr4sfIvvx51eFZn9oS/gY0gRTr
         jiqMf3+lPaMoHwtj0VhBlDslbdVbbytnoN1Y+4tXYx7OFeEYAw7FIPwTCpOTqLfX/OGJ
         NPAAch+q0pn0lL0A3gyWeEdw6Vbj7smdSYk+rChmXEmv9PxDH2ql5nbrO0HqPAbuJ3GG
         7HrlbBjoOH8WS1ZMXQVCa/aMoRNaluPEDgCnzzbwku0/oouL70/lBMpGnmj8Uc/UAwYi
         GdQA==
X-Gm-Message-State: AJcUukdG/IINamyXIWV6bNpjOHslKCIqOQwvhs/rQBdB4u0rAUDU4/II
        illbnpojKgw+9mOpWLNp6WNMjz+IXIigxg==
X-Google-Smtp-Source: ALg8bN5PGdFjlKiSp00IAjNoPz0lQ8YBJR3xWhrC6JDDRi160us1yLFS/Gwz9ZbQtsZrcGPrA7pZlg==
X-Received: by 2002:a5e:c74d:: with SMTP id g13mr29770648iop.26.1546437574874;
        Wed, 02 Jan 2019 05:59:34 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id x17sm23812267ioa.6.2019.01.02.05.59.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jan 2019 05:59:33 -0800 (PST)
Subject: Re: compress-force not really forcing compression?
To:     Adam Borowski <kilobyte@angband.pl>,
        Paul Jones <paul@pauljones.id.au>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "devzero@web.de" <devzero@web.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
 <79977718-ac8f-3a62-529d-e9046c8066b2@gmx.com>
 <f527b243-4379-ec32-a6f2-3f04c72fb8d9@suse.com>
 <SYCPR01MB5086BDC3A10DC10383C12EFB9EBA0@SYCPR01MB5086.ausprd01.prod.outlook.com>
 <20181223061605.qrl5zsi36kpyltql@angband.pl>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <01b57072-9a85-76fd-ab9d-fc08f5b0e556@gmail.com>
Date:   Wed, 2 Jan 2019 08:59:28 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181223061605.qrl5zsi36kpyltql@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/23/2018 1:16 AM, Adam Borowski wrote:
> On Sun, Dec 23, 2018 at 12:24:02AM +0000, Paul Jones wrote:
>>> IMHO the more pertinent question is :
>>>
>>> If a file has portions which are not easily compressible does that imply all
>>> future writes are also incompressible. IMO no, so I think what will be prudent
>>> is remove FORCE_COMPRESS altogether and make the code act as if it's
>>> always on.
>>>
>>> Any opinions?
>>
>>
>> That is a good idea.  If I turn on compression I would expect everything
>> to be compressed, except in cases where there is no size benefit.
> 
> I expect that the vast majority of files consist of blocks of similar
> compressibility.  Thus, finding a block that fails to compress strongly
> suggests other blocks are either incompressible as well or compress only
> minimally.  Refusing to waste time, electricity and fragmentation in such
> case is a good default, I think.
> 
> But, if you believe this should be changed, there's an easy experiment you
> can try: for all files on your filesystem, chop every file into 128KB pieces
> and compress each of them with your chosen algorithm.  Noting the compressed
> size of every block in a file that had at least one block fail to compress
> would give us some data.

I would suggest looking at Windows DLL files installed as part of a Wine 
setup as a potential candidate for this.  They tend to have very long 
runs of null bytes scattered seemingly randomly throughout the file 
(because hot patching, except you can't hot-patch DLL's reliably on 
Windows) and use UTF-16 strings.  As a result, the actual machine code 
generally doesn't compress well, but most of the rest of the file does. 
Fixed-size preallocated VM disk images would be another good candidate, 
just wipe the free space with zeroes from the VM before testing them.

Realistically though, I see a couple of issues with the default behavior:

* There's no way for a regular user to figure out if a file actually is 
transparently compressed or not.
* Without editing the filesystem directly, there's no way to 
preemptively set the bit in metadata that tells BTRFS to not try to 
compress a file, and there's no way to reset it either.
* The default behavior happens to be what `chattr +c` honors, which 
leads to potentially unexpected behaviors some times (I, and most people 
I know, would expect 'chattr +c' to behave like `compress-force`, not 
`compress`).
