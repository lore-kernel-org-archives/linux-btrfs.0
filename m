Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBDBC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 22:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7915120866
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 22:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="miH9dzxM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387892AbfAOWZB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:25:01 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:43125 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfAOWZB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 17:25:01 -0500
Received: by mail-ed1-f43.google.com with SMTP id f9so3860906eds.10
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 14:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:from:to:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uqAc5BIjUC797Q0VV3szW0AFs/DsYfNQe9DVR1/ly0E=;
        b=miH9dzxMEoTsnabO709vf9Ta0xg3ossM4TwB8o2xmohA0pXfKMmnEyN7r5/fecM8pO
         ZWkIgJ4wetDVDb3FU6Qw6knNvyRslmfcvV9npEtf/baLNPK7f3ssNPQu0J8HmRhB0vDF
         KCT+WQAyESroy6mbQvagbjlBxXkQvi9LCi+3mtYXGhLLwTq0JGpqwA9M6NKIlnd4T/LW
         jcEC9Ebc04tXTLgll5MZ6ETBws9gWXJwM2fTm9BWeT0eSoCXwvmFqJMVPGGINdDiwtiB
         yIJ0yRH+y2cNq9vNmH3ysIUrVbpJVvh3cRbn3k7HJVGVqMyzkbMJLRoiilUTSfYS9jKS
         xSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uqAc5BIjUC797Q0VV3szW0AFs/DsYfNQe9DVR1/ly0E=;
        b=YNvkN94eoOlz1//JZ6QSyfTDvwYYXPEDuWlRP9O6pVPYKSObgLFqt49LryRe6CLY8U
         buE8z5xTxj5NrzgecIABAChfHUAU0kMWwtucjcO5wg2iFvFv08PynEVjIMOl31qWu9VN
         Ww+xzSO3SCgbWPslFR2ncgVCmz7kwtLhYfzLU1GJCrl+kRSo6ZJoHqu7vekvHSJiIuz4
         8DexmIJMxrEBG6Gqsxpd4OP1H2IPnc3Ehi2IYsW1UvymDXFxN5Ln+bEUiKdSJzoDvNlv
         +OdYiTYnSE1gSZmBN07aB32bxt08pwaCGFs70IyHdAhfQ+dHnuW5mEnM597UPX2OGPe8
         VisQ==
X-Gm-Message-State: AJcUukdYt+gf30aZorXTqRXIXLDFnNwWncYH8rUZx2sw/rlBF7N9Hjhe
        yO13j84bMeG/stCPLPkfeOqgNFgs
X-Google-Smtp-Source: ALg8bN5So5XMZruXQ9R2XFrWvkbRocqwSJcY/kjwN7Mc21WmmTI4vMnEHOJ031+Qbh9ANKvyP5fe0A==
X-Received: by 2002:aa7:d9d6:: with SMTP id v22mr4942519eds.265.1547591097935;
        Tue, 15 Jan 2019 14:24:57 -0800 (PST)
Received: from ?IPv6:2a01:5c0:e088:2f20:fa16:54ff:fe84:9770? ([2a01:5c0:e088:2f20:fa16:54ff:fe84:9770])
        by smtp.googlemail.com with ESMTPSA id n3-v6sm2760534ejd.35.2019.01.15.14.24.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 14:24:56 -0800 (PST)
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
From:   Oliver Freyermuth <o.freyermuth@googlemail.com>
To:     linux-btrfs@vger.kernel.org
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
 <2dba4f49-2be5-694b-2676-0fa75a250e2d@googlemail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=o.freyermuth@googlemail.com; prefer-encrypt=mutual; keydata=
 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
 KB7t2CoZv5xo0STm
Message-ID: <45de3cc0-b8b5-9e33-fbba-d02505583d2b@googlemail.com>
Date:   Tue, 15 Jan 2019 23:24:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2dba4f49-2be5-694b-2676-0fa75a250e2d@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am 14.01.19 um 01:48 schrieb Oliver Freyermuth:
> Am 13.01.19 um 22:51 schrieb Oliver Freyermuth:
>> I just upgraded to 4.20.1 from 4.19 (not sure if related) and my btrfs backup volume entered read-only mode when running btrfs-cleaner,
>> i.e. when purging old subvolumes. 
>>
>> I have attached the kernel log from when this happens. 
>>
>> What is the best way to proceed from here? Running "btrfs check repair" on the device? 
>> Worst case it's not a huge issue to lose the data stored there, it's my backup volume after all. 
>> But it would be good to understand the cause and know if there is a better fix than starting from scratch. 
> attached is the output of "btrfs check -p /dev/sdc2". 
> I can't guarantee the volume has never been cleanly unmounted. 
> 
> I found several past occasions of this here:
> https://www.spinics.net/lists/linux-btrfs/msg69040.html
> and here:
> https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing
> but without conclusive result. 
> 
> Please let me know what's the best way to proceed. From these links, it seems
> btrfs check --repair
> _should_ help, but I would prefer to get some advice first whether this is really the best approach. 
> 

Dear BTRFS experts,

I have now salvaged all my backup subvolumes with btrfs send (using btrbk archive) to a new btrfs partition. 
Interestingly, when the old partition was mounted r/w initially and remounted r/o after the described issue was triggered by btrfs-cleaner:

[34758.491644] BTRFS: error (device sdc2) in __btrfs_free_extent:6828: errno=-2 No such entry                                                                                                                                               
[34758.491647] BTRFS info (device sdc2): forced readonly                                                                                                                                                                                     
[34758.491652] BTRFS: error (device sdc2) in btrfs_run_delayed_refs:2978: errno=-2 No such entry 

btrfs send appeared to fail on some subvolumes with:

[41822.676040] BTRFS error (device sdc2): parent transid verify failed on 52633681920 wanted 88063 found 87999                                                                                                                               
[41822.676260] BTRFS error (device sdc2): parent transid verify failed on 52633681920 wanted 88063 found 87999                                                                                                                               
[41822.676266] BTRFS info (device sdc2): no csum found for inode 22175978 start 0                                                                                                                                                           
[41822.683112] BTRFS warning (device sdc2): csum failed root 25758 ino 22175978 off 4427459514368 csum 0x5d3b8d26 expected csum 0x00000000 mirror 1 

Unmounting and remounting the broken file system r/o, all visible subvolumes could be transferred without that issue. 
I presume that there's also a bug when the automatic remount as r/o happens since csum 0x00000000 does not look correct. 

Since there's now nothing to lose and I received no other advice up to now, I'm running "btrfs check --repair" now just for the sake of learning
whether this appears to fix it. I'll shortly report back when that's done. 

If anybody can suggest a better solution in case this happens again (the issue appears to be wide-spread) I would be happy to learn. 

Cheers,
	Oliver
