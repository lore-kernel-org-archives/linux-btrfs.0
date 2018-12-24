Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,FROM_EXCESS_BASE64,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0516C43613
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 13:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AD4820815
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 13:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaliza-cz.20150623.gappssmtp.com header.i=@metaliza-cz.20150623.gappssmtp.com header.b="DAbytiZx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbeLXNwt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 08:52:49 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:40907 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbeLXNwt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 08:52:49 -0500
Received: by mail-wm1-f50.google.com with SMTP id f188so11823517wmf.5
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2018 05:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaliza-cz.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eaewgyAfFHaaac7KetXwMls0twVLIlZJG114doUz8bc=;
        b=DAbytiZxPI2Ol49b4iQFCzxfdPGOJFzwFVaQHmigrcefArYVx3Pdvtuu+C3Q17r2xi
         uVT7YyypjJyZvXwz23K4d3fh2C+lwYy+wYhPihVdglLYIdK6r29Q0nRs8cfjACehysIV
         fPV0mp6qpOaxGYG46p80xpNdDn9tu7P6HPaU+pRPROcGxRADBO6vXDbZAD8n/54cEiTD
         CVt8hFX+1BSVw1LPvQGYwWXsVZJQCkUl7yW41V6JfBr8RoxgEMmMQqjdYfXVppecDVgo
         j0AG2C4a1q9a7dgOydPke17Pu6Fg6Rnllba4ZFy25G+KqbuMhEYKmmD41OK2JALAAJzK
         5XFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eaewgyAfFHaaac7KetXwMls0twVLIlZJG114doUz8bc=;
        b=G4k3JC/qJ/spIIg71PyZHZxMz3DlyekZOFj4SJrqJTWX3yG78O+PnLgd12861xMZA6
         cJlPsg0IwtWvphQkNrx56q8mhhuoq220oL5MA+aO/VFLt3HDnF9gopC2VqeTmZmw4kpC
         N00/h2X5KzCqoM/gi3CFXX5K87UMpVUx5ptSJ1Y0sqJejcoFaRkSoabkjNvOcTjTlV1H
         L5HP/gVvLQEyMcDxiGDltqIEC3yrz+51/RMCg22lCQdWNNBPiXM5bzRi4XTEOoVK1Sjm
         NXwUJ1t9BvBIbTzjbnwRkub/cxATIWOQrAATa3wesfT1foSu3QW7unKcMW/+iu6U9MwZ
         SxCQ==
X-Gm-Message-State: AA+aEWb10usaR7RZRh8RfPzU4k3B7nsNP6SQiddwdEonbhM/80S3HRkJ
        wR8XIOhpHAK7vfAVZtCH5PJgq/Avn48h1Q==
X-Google-Smtp-Source: AFSGD/UvlCND7dydMuNiXqFePGKtDh5XGxwirVs0ihbpQnT6fbb6/HaLPmdTLRrH8vc/xAv1Mo8zFg==
X-Received: by 2002:a1c:4108:: with SMTP id o8mr11941197wma.91.1545659566448;
        Mon, 24 Dec 2018 05:52:46 -0800 (PST)
Received: from ?IPv6:2a00:1028:96c8:10a2:6031:a913:d419:3220? (dynamic-2a00-1028-96c8-10a2-6031-a913-d419-3220.ipv6.broadband.iol.cz. [2a00:1028:96c8:10a2:6031:a913:d419:3220])
        by smtp.gmail.com with ESMTPSA id t5sm21021329wmd.15.2018.12.24.05.52.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Dec 2018 05:52:45 -0800 (PST)
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Peter Chant <pete@petezilla.co.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
 <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
From:   =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Message-ID: <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
Date:   Mon, 24 Dec 2018 14:52:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 24. 12. 18 14:02, Qu Wenruo wrote:
> btrfs check --readonly output please.
> 
> btrfs check --readonly is always the most reliable and detailed output
> for any possible recovery.

This is very weird because it prints only:
ERROR: cannot open file system

I've tried also "btrfs check -r 75152310272" but it only says:
parent transid verify failed on 75152310272 wanted 2488742 found 2488741
parent transid verify failed on 75152310272 wanted 2488742 found 2488741
Ignoring transid failure
ERROR: cannot open file system

I've tried that because:
	backup 3:
  backup_tree_root:	75152310272	gen: 2488741 level: 1

> Also kernel message for the mount failure could help.

Sorry, my fault, I should start from this point:

Dec 23 21:59:07 tisc5 kernel: [10319.442615] BTRFS: device fsid 
be557007-42c9-4079-be16-568997e94cd9 devid 1 transid 2488742 /dev/loop0
Dec 23 22:00:49 tisc5 kernel: [10421.167028] BTRFS info (device loop0): 
disk space caching is enabled
Dec 23 22:00:49 tisc5 kernel: [10421.167034] BTRFS info (device loop0): 
has skinny extents
Dec 23 22:00:50 tisc5 kernel: [10421.807564] BTRFS critical (device 
loop0): corrupt node: root=1 block=75150311424 slot=245, invalid NULL 
node pointer
Dec 23 22:00:50 tisc5 kernel: [10421.807653] BTRFS error (device loop0): 
failed to read block groups: -5
Dec 23 22:00:50 tisc5 kernel: [10421.877001] BTRFS error (device loop0): 
open_ctree failed


So i tried to do:
1) btrfs inspect-internal dump-super (with the snippet posted above)
2) btrfs inspect-internal dump-tree -b 75150311424

And it showed (header + snippet for items 243-248):
node 75150311424 level 1 items 249 free 244 generation 2488741 owner 2
fs uuid be557007-42c9-4079-be16-568997e94cd9
chunk uuid dbe69c7e-2d50-4001-af31-148c5475b48b
...
   key (14799519744 EXTENT_ITEM 4096) block 233423224832 (14247023) gen 
2484894
   key (14811271168 EXTENT_ITEM 135168) block 656310272 (40058) gen 2488049
   key (1505328190277054464 UNKNOWN.4 366981796979539968) block 0 (0) gen 0
   key (0 UNKNOWN.0 1419267647995904) block 6468220747776 (394788864) 
gen 7786775707648
   key (12884901888 EXTENT_ITEM 24576) block 816693248 (49847) gen 2484931
   key (14902849536 EXTENT_ITEM 131072) block 75135844352 (4585928) gen 
2488739


I looked at that numbers quite a while (also in hex) trying to figure 
out what has happened (bit flips (it was on SSD), byte shifts (I 
suspected bad CPU also ... because it has died after 2 months from 
that)) and tried to guess "correct" values for that items ... but no idea:-(

So this why I have asked about that log_root and whether there is a 
chance to "log-replay things":-)


Thanks
M.
