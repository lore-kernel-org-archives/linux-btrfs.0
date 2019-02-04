Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6B5C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 17:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 647AD2080A
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 17:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IY1MGU5y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfBDRzK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 12:55:10 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:54679 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfBDRzK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 12:55:10 -0500
Received: by mail-it1-f194.google.com with SMTP id i145so1851050ita.4
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Feb 2019 09:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g2knvhKIsPBZk397AfpQgNTSjqvstKLF3KG8x9OVZj0=;
        b=IY1MGU5ydeBm2+XZ832Jm7s8arEN4xa6h/NFNtUPRqspsPRP6IT/fmfXusliVnG488
         oFub2ni9mFeawLwDRDIgE1/5rMLJQ5m49SFD14waZoCv4nQIAIjyqa4e+M3p+Fb/FHwq
         SxuAX14dOc0kB+U4fyF80lK7AVLRUC2HwMd2D45DiT1aizAFInVi6IXMnc2gRc49c11A
         oq4KAZNOzuxypM1ITekt27yk4nkSmnNnHwa1MK1r/SlBXfrsvfrHeAEuyuQinb9PlQRX
         pRD9xbJucQTzJ2+Y5HDgcTvIRe+nAnaJ+hb7SDiAZrOEfYMG7jnSS8KaCBXiSln54JoD
         h49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g2knvhKIsPBZk397AfpQgNTSjqvstKLF3KG8x9OVZj0=;
        b=LMaW+JvOrkkDIgafHLf2Xba/OanlL3B0YSZONoyA9+tHXs5FyN1Bo/vTN23CXVHst3
         HR+cJl0d3yqgLU9+TfjuDyK4XAocx54gCzeCtUx/+gXP3Y0plIIlDbJ7n7KwrnY2kC6A
         GGibkuBLTTtO1aT1VV4UJyjg1U2L88iYeh5sa6ZedW0wKe0Wmkl3BYZPwCBHq4guHVgi
         FDXCaBArW8ufSWvYV+7h78FJcD0CNJyi1zB8nWttB4jqa3rYbGBtIuPvXLlwJkyym1sS
         OqEO1w5hQxwqDBG5uqH7xVQDQK9X+GnIYhqOYPTdprhoyG1JeLtyZ5NudYOogFiSLzxk
         IVOQ==
X-Gm-Message-State: AHQUAua2N57JtlXyD7XOKwPLnRVF1dXLENWsfJo8Dw/v/6ow/oc08M2j
        7beis7DQaEbJKZyUDN9fdohT/Iwo0Oo=
X-Google-Smtp-Source: AHgI3IYzl6kN4S5BQuSuIhoHLvVAgdDj80xFAk9l9kVnCvTbDopfsHuaRNlwBBNAP8o39I8k+p9hnQ==
X-Received: by 2002:a24:a64f:: with SMTP id r15mr328753iti.101.1549302909348;
        Mon, 04 Feb 2019 09:55:09 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id x79sm305757ita.34.2019.02.04.09.55.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 09:55:08 -0800 (PST)
Subject: Re: btrfs as / filesystem in RAID1
To:     Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <33679024.u47WPbL97D@t460-skr>
 <CAJCQCtR=WZGk4eaG63_-uqb0wzGVDDrS1SsxhzxT7k3qbWVtCg@mail.gmail.com>
 <CAA7pwKN9B7LZEo7Op0PndTnU6jo3JdtLi0vdphXZakgbKBB-9w@mail.gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b879a985-c991-b4b3-590e-d2aa1a5fa5c5@gmail.com>
Date:   Mon, 4 Feb 2019 12:55:02 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAA7pwKN9B7LZEo7Op0PndTnU6jo3JdtLi0vdphXZakgbKBB-9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-04 12:47, Patrik Lundquist wrote:
> On Sun, 3 Feb 2019 at 01:24, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> 1. At least with raid1/10, a particular device can only be mounted
>> rw,degraded one time and from then on it fails, and can only be ro
>> mounted. There are patches for this but I don't think they've been
>> merged still.
> 
> That should be fixed since Linux 4.14.
> 

Did the patches that fixed chunk generation land too?  Last I knew, 4.14 
had the patch that fixed mounting volumes that had this particular 
issue, but not the patches that prevented a writable degraded mount from 
producing the issue on-disk in the first place.
