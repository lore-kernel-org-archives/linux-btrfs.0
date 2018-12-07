Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDD5C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 12:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 579D2208E7
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 12:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UA8hhL7O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 579D2208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbeLGMZG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:25:06 -0500
Received: from mail-it1-f176.google.com ([209.85.166.176]:52857 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbeLGMZF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 07:25:05 -0500
Received: by mail-it1-f176.google.com with SMTP id g76so6581653itg.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Dec 2018 04:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FGZf/4ANsGJuFZCb6bKNJaSwkK4XFqDLGEKkvaKJRcY=;
        b=UA8hhL7OhDsMifBfWsWmG14DiXiAL7dOVWvBebyCr36k2D3hnZ6ukiZ4c/hTSSCjdu
         o0K7zRDEal4qfePruY+ZSSupbVqS4wgNuR41xMb0c1k03TQbhTnSdejG8uZ3ErB/UYrK
         SB3QqWX871W9yAdzLQgfJKQ36VhepE0iA+x/uOf+ZPekjg2OjzKm79mlcKUEwBHJDvcd
         AWAI5y86tEkdr4ZU/oL9N+s3dz/U96qliK/t7zd2v/d8WCGLYrfwUgMo3GLEa4C/uoNh
         9EGs2+rP+QUoNWSUbjoj8T3GVmhxtAt5PD+qauSXw1lR8vyQBal0EWsjFW9FdFlCtbkl
         yxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FGZf/4ANsGJuFZCb6bKNJaSwkK4XFqDLGEKkvaKJRcY=;
        b=IGXQRiEZOP/yJiZbtpJ2Fb7uaQa26nJbvm7YoMWNf9ikpYjxqe7boRKpmudEVyWdxs
         HWt6YbVqg957Ur5fywHEopEUwj2HRr7cVP6KtSGeHXcgr5Zp3YAFKbwIwAs7a1jBloqS
         sCbtT73Gb9hGxBfcU5QRQCCR/pc8Hc0HjqZqvehY7WwN5kucUbb1vHj7HhCyf3cixTq3
         5+hqr6MWroZXh7YhTSvtYZcCQwKQK50XswKqyhs0MFvwtsbIaDJ36a25F+dBKvmBzDjt
         SiQ2vcVs8iewX8lPDLSZtDtUSSkLPI2wuCpGo7AkX6ySKywNTcabm2DUhDXqlgzWOkak
         rikw==
X-Gm-Message-State: AA+aEWaWxboOFPlQB5gcysYEC5W2Y5cAl2XE0CVqMDitgsuIj4iYR9fb
        5X5jTKtwjQnxAdE5QwUV/JOQVEmEyFE=
X-Google-Smtp-Source: AFSGD/XOZrNH/kuqLMQ1xXPfsQK1L6m39xIE2A59k+/bYaW/Y/LaQQKpEKySt3z1YZnB2DxrpezGlg==
X-Received: by 2002:a02:5ec9:: with SMTP id h192mr1531027jab.112.1544185504495;
        Fri, 07 Dec 2018 04:25:04 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id j1sm1133432ioq.85.2018.12.07.04.25.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 04:25:03 -0800 (PST)
Subject: Re: System unable to mount partition after a power loss
To:     Doni Crosby <doni.crosby1995@gmail.com>, lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
References: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
 <CAJCQCtSiYk4RMRWRoaAFchzvinQ4tq1wC_Ru9d8gJWRsebvbTw@mail.gmail.com>
 <CAJkMDByx_H3xjJmN4gO+L0pxpkd7sWLTmTxRfNjUp06r8o3E7w@mail.gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2426b6a2-5c6e-481e-650a-e4559c7c57a1@gmail.com>
Date:   Fri, 7 Dec 2018 07:24:58 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAJkMDByx_H3xjJmN4gO+L0pxpkd7sWLTmTxRfNjUp06r8o3E7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-07 01:43, Doni Crosby wrote:
>> This is qemu-kvm? What's the cache mode being used? It's possible the
>> usual write guarantees are thwarted by VM caching.
> Yes it is a proxmox host running the system so it is a qemu vm, I'm
> unsure on the caching situation.
On the note of QEMU and the cache mode, the only cache mode I've seen to 
actually cause issues for BTRFS volumes _inside_ a VM is 'cache=unsafe', 
but that causes problems for most filesystems, so it's probably not the 
issue here.

OTOH, I've seen issues with most of the cache modes other than 
'cache=writeback' and 'cache=writethrough' when dealing with BTRFS as 
the back-end storage on the host system, and most of the time such 
issues will manifest as both problems with the volume inside the VM 
_and_ the volume the disk images are being stored on.
