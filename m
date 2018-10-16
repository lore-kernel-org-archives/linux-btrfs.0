Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A782FC04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 15:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51949208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 15:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ALxqvptM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51949208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbeJPXd4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:33:56 -0400
Received: from mail-it1-f175.google.com ([209.85.166.175]:52885 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbeJPXd4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 19:33:56 -0400
Received: by mail-it1-f175.google.com with SMTP id 134-v6so33702629itz.2
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2018 08:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Pi9x0pGJKSaxGwdhA2aWAYMGlLuNknjaajIii/WP1ds=;
        b=ALxqvptM6u5KhO8Nc1s/1XY/0h15I4mMX164XeaxjyS/yTeLPcVO0GfUK9Bs2scvAj
         Y6rJ66QKAwi3W4WxqmYyQ3x/HM0DMZNF8W5xXQEgCuUt2lHKMhRIwSm4OspkhAfWWMpC
         yxvIZEneEWQcDHjAfv1nHYD82sGoO+gpgZ6c2ramNJf5Gn55yL7onDU0z1Q1bvd0fQiQ
         H/b8+UWnnJSFbX/tpvY1Ks9stbMCJ5Sz5HIsKpkOhFTihruG1J5ByeC7da0PMUzXDAPp
         0bMT1NipZSGNyQr9DWdRKcXG3xQtpCQBWYe0OF62RHQWVNVeUS1ROBEKi8cwn0OPin2t
         J1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pi9x0pGJKSaxGwdhA2aWAYMGlLuNknjaajIii/WP1ds=;
        b=BpJkLVQJLxdIkdtf5yYWMsX8rlRpBiKMOu3Uz5tl2RhYDbmIpy10hcYKHiaeYUsNyG
         BoB3jfqrnIO6LEsMt+bHB5HVSi9TZJ9OrdxjRZawNJJIAmuLCTwxWL1wCHh0D2NqLRCB
         TTLs7GhEZJf9b4qikvGl7ceN31ZzkqkMprDNCCCSgEjvH7sqhn+ZBqIS+7uU1oFno33J
         /PolRyaP2RLYGNTwncvM9v7dyyLmmxcFLDQx8PqXzJQDWCJXTlsGA0RtHcAso24V2SFg
         XFW+lIcpWxGSAQ9L/4aWkmEbSZj/enlg8vW959jmR3b0pmmp7bQlA6olymP5nZsh2DHb
         JEnA==
X-Gm-Message-State: ABuFfojLzIQImiMjQPjazdN9OLMzdXcHfoqtV49T7HkdjR+YgB1EBo/Z
        /1ROhogBS3D46h7saAH6QnkyYbqMtm7Omw==
X-Google-Smtp-Source: ACcGV62OAY5Tu/yxo6JzcRSrx+xvZmdVgtvp8YfUDC94BaHOCyxTSKdO3VAPtuoABjoATm/fW8EJEg==
X-Received: by 2002:a24:2487:: with SMTP id f129-v6mr14331312ita.51.1539704573961;
        Tue, 16 Oct 2018 08:42:53 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id z186-v6sm5041361itd.43.2018.10.16.08.42.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 08:42:52 -0700 (PDT)
Subject: Re: CRC mismatch
To:     Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
References: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f2df5862-ae3e-5808-4f00-e153f604df60@gmail.com>
Date:   Tue, 16 Oct 2018 11:42:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-16 11:30, Anton Shepelev wrote:
> Hello, all
> 
> What may be the reason of a CRC mismatch on a BTRFS file in
> a virutal machine:
> 
>     csum failed ino 175524 off 1876295680 csum 451760558
>     expected csum 1446289185
> 
> Shall I seek the culprit in the host machine on in the guest
> one?  Supposing the host machine healty, what operations on
> the gueest might have caused a CRC mismatch?
> 
Possible causes include:

* On the guest side:
   - Unclean shutdown of the guest system (not likely even if this did 
happen).
   - A kernel bug on in the guest.
   - Something directly modifying the block device (also not very likely).

* On the host side:
   - Unclean shutdown of the host system without properly flushing data 
from the guest.  Not likely unless you're using an actively unsafe 
caching mode for the guest's storage back-end.
   - At-rest data corruption in the storage back-end.
   - A bug in the host-side storage stack.
   - A transient error in the host-side storage stack.
   - A bug in the hypervisor.
   - Something directly modifying the back-end storage.

Of these, the statistically most likely location for the issue is 
probably the storage stack on the host.
