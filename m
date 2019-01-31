Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380A8C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 14:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09FF420869
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 14:06:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NIVM4qXN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733009AbfAaOGn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 09:06:43 -0500
Received: from mail-io1-f52.google.com ([209.85.166.52]:35404 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfAaOGm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 09:06:42 -0500
Received: by mail-io1-f52.google.com with SMTP id f4so2728263ion.2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 06:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XCXOqZXa6zd07RPieVSrkV2ty9WZeGtnzM5AxCKyxsY=;
        b=NIVM4qXNrlzi2nrzhqFFlXGZ+WJssmI5pl8cG+RstEsBPSbsI+GBmIGgasHgfBku8L
         6L8uopPGiBidD5CtlsCz/ynSzoXkTgLxSWf/Azryy4jnfoCXhfB+vCrsuKSzT40Z6sgK
         WKOYAqf0RxgIlSSwvEvvx7IzjhcH5Pzqz8d+uP7RYFrjLRY/QRx2XWpmsA2msrFg66N2
         hXGrjOZkP5OZF4OB9jcKKm+c9wmJnbCKaMNdVIro5ljHDnjtF80dFCFPXK15HcYsuiTM
         FJ6TZQmALg5IA/+yR2r4FKz9b809YArJPO6E9mBvsOtIdPBn+OJYd7qR04NIga/CSslt
         bfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XCXOqZXa6zd07RPieVSrkV2ty9WZeGtnzM5AxCKyxsY=;
        b=VOeLUP+RmMBnjfTXJdMQN4OLXFuypmlH6IXaFQnYMjrTIe0f+vUxmHvL2+1+it3StI
         8mFuvU3Kk641eyfg24hRdSbTElj6lA0qwfyoZltCkcgdKPJGpHh32tDo7TcbLIGKwJ5L
         MaBb0mahhLN3EWKJB/FQNvRq/sV9KqW93Bh5JT3Hj6RPwfrqZQr2o1w1F+LxzA2G9eOq
         4QcC014ZO0Ogj0hzpy8Et48vJPmwq/B5aS14juwt6b4r+16xHNry1MN98ik1ZjZUdYGA
         TSA5H3HudeVYUZyMumMkJTFDgyLvR1k1Cl55FbtEsUZET+XwQiVIXuwNE5wfe0wojWGN
         Q0kg==
X-Gm-Message-State: AHQUAuYJdady9+v+sbiDpCBE3OMxWU6KMPCccNjeXytGYuVu5ZdZ5CZv
        YfWZGOK/SOoqSiKuunr6Z+4rXS+4kEA=
X-Google-Smtp-Source: AHgI3IZfm5KZpTMRejZM7lpCQTcyJ2CE2gdeuQU6dRK5Gtdnk2qWu0GBkXK1bN+gQcgF1SIlFkv8qA==
X-Received: by 2002:a5d:9650:: with SMTP id d16mr3134328ios.289.1548943601014;
        Thu, 31 Jan 2019 06:06:41 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id x79sm3102088ita.34.2019.01.31.06.06.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Jan 2019 06:06:40 -0800 (PST)
Subject: Re: File alteration events?
To:     Ronald Schaten <ronald@schatenseite.de>,
        linux-btrfs@vger.kernel.org
References: <20190131123832.yqhp4fqavv6xjdif@shell.intra.scheunentor.de>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d3a7b5d2-9281-16bc-2c87-18cf371985c1@gmail.com>
Date:   Thu, 31 Jan 2019 09:06:36 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190131123832.yqhp4fqavv6xjdif@shell.intra.scheunentor.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-31 07:38, Ronald Schaten wrote:
> Hello everybody...
> 
> This is my first mail to this list, and -- as much as I'd like to be --
> I'm not a kernel developer. So please forgive me if this isn't the right
> place for questions like this. I'm thankful for any pointer into the
> right direction.
> 
> 
> The question:
> 
> I'm looking for a solution to track file changes on a fairly large
> filesystem. Many thousands of directories, millions of files.
> 
> The volume is shared to other computers, changes can come from different
> sources (NFS, Samba, local access...). So I think the kernel or the
> filesystem itself are the definitive source of information.
> 
> Does BTRFS have any mechanism that could be used to track every event?
> Or do you happen to know if the kernel does?
> 
> 
> What I tried till now:
> 
> - inotify: Doesn't work for a full volume, just for single inodes.
> 
> - fanotify: That's almost the solution, but I need to see rename and
>    delete events, too.
> 
> - btrfs subvolume find-new: As far as I know that only finds changes
>    between snapshots. I need something a little more real-timey, and I
>    have to know if the file has been changed once or several times.
> 
> 
BTRFS does not, anything like this is going to be in the VFS layer.

Given what you've said above, I'd suggest asking the VFS developers 
about the possibility of getting rename and delete events in fanotify, 
as that's likely to be the best option long-term.
