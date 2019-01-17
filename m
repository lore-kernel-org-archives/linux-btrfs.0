Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PLING_QUERY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B7AC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 08:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3EA20657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 08:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nig-ac-jp.20150623.gappssmtp.com header.i=@nig-ac-jp.20150623.gappssmtp.com header.b="WaShV4ZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfAQIf4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 03:35:56 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42673 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfAQIf4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 03:35:56 -0500
Received: by mail-pl1-f193.google.com with SMTP id y1so4403452plp.9
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 00:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nig-ac-jp.20150623.gappssmtp.com; s=20150623;
        h=date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vvn/4vd7HprdeIXiEc1SJqNNisoH2JS4P9FGCBZrlWQ=;
        b=WaShV4ZAXjR2FJejetyAEN/6Nob+03E1PYUiXSdT4eFJLg4hRGLvFuSmaelOj4dbIh
         spc8mcN7KIIxqsMzPsxAib9EZ4wF8kfA5tmaCDnRV0D2zpOqzaZ9PzOqKQF0OkY7emDt
         YIWZZwaxVGTReAWgvYGLxN+JXjGEYZp6H+Og72Iqfn+lWo4rgOaFhf/u+/ifJBTxyK1w
         WskyBLEMpxa9eH9P8Y3Ve/J+tUDhXZQjVLZ/2PWxnml5K1s7eOqjLOGKjXbAPcjYxaGW
         SPPHfvqGyLXao6zaL5sj+q8Xz8+icScn7fZ/2U8xrICnHF4fz2H9eiD/9QRZmMdJOw6G
         2pnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:to:cc:subject:from:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vvn/4vd7HprdeIXiEc1SJqNNisoH2JS4P9FGCBZrlWQ=;
        b=LO6f6grqskkp588vf6zaQS3HYSNyq2DHY3KIFnsLVq5p+qbdOfiKjzDpEOtnfmlPXt
         ZvTAfm7g06SRcSPK+0iu9/wmG8Qrr6wQvm1e0JCHAmuYpP4n/etM3zZiM0Ge+PEZGEir
         Wf66WVbaNexrPXilKUgFEoCpXn2D7XVsvPO/fSeQiRpLNIHt+dSEXJQmsqGcDiwR7V9L
         5WS6IfgzFrpp7Yd3Ycb2UKk2qM8PoUioWVsRH8BC8VTfcIrkRmnIOr0WcIjuuTKBRvw1
         byQT8FHg4VVMPJKB0QEC3UqYq/fs6A8ocOIvcBGx3nQN0G0pBylFE9mGBRrPDndCXXuX
         vxrg==
X-Gm-Message-State: AJcUukeU8zMFzsw5Y5Bd8xH1CNkttRVN7gem6qzYFXa6i+ub6C8corNf
        0kKiGXHEStt67KMWUsmwJlFqJa1QUOg=
X-Google-Smtp-Source: ALg8bN5SkcSvmbwLiORpt347YCeOs/qJ9TDd63BYiqb3z+B78Cq+Z5OgeLKVHBZIhlYXrn4IMjrWvA==
X-Received: by 2002:a17:902:5a4d:: with SMTP id f13mr14460730plm.49.1547714155823;
        Thu, 17 Jan 2019 00:35:55 -0800 (PST)
Received: from localhost (Plcd1.lab.nig.ac.jp. [133.39.89.231])
        by smtp.gmail.com with ESMTPSA id u70sm2472589pfa.176.2019.01.17.00.35.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 00:35:55 -0800 (PST)
Date:   Thu, 17 Jan 2019 17:35:49 +0900 (JST)
Message-Id: <20190117.173549.2034136740368556491.hhiraki@nig.ac.jp>
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org, hhiraki@nig.ac.jp
Subject: Re: How to repair "btrfs_chunk_readonly: BUG_ON `!ce` triggered,
 value 1"?
From:   HIRAKI Hideaki <hhiraki@nig.ac.jp>
In-Reply-To: <20190115.225317.1036041048727530368.hhiraki@nig.ac.jp>
References: <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>
        <6520ff6f-c406-b0c2-a640-55d33883b5b8@gmx.com>
        <20190115.225317.1036041048727530368.hhiraki@nig.ac.jp>
X-Mailer: Mew version 6.6 on Emacs 26 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

At Tue, 15 Jan 2019 22:53:17 +0900 (JST), HIRAKI Hideaki wrote:
> Dear Qu,
> 
> At Tue, 15 Jan 2019 20:55:38 +0800, Qu Wenruo wrote:
>> On 2019/1/15 7:47, HIRAKI Hideaki wrote:
<snip>
>>> The second question is about btrfs-restore. It doesn't restore subvolumes
>>> even when the destination path is in a BTRFS file system.
>> 
>> I had a plan to support snapshot/subvolume creation for btrfs-restore if
>> destination is btrfs, or supports reflink.
>> 
>> But that feature will be too late for your use case anyway.
>> 
>>> "btrfs restore -l"
>>> is to list subvolumes but the output lacks the path (relative to the top
>>> level subvolume) information.
>> 
>> You could try my experimental patch:
>> https://patchwork.kernel.org/patch/10738583/
>> 
>> It provides kernel equivalent of btrfs-restore, using 'ro,skip_bg' mount
>> option.
>> 
>> If everything goes OK, then you should be able to get 'btrfs subv list'
>> working.
>>
> 
> I'll try this later.

With the patch, 'btrfs subv list' worked! Thank you very much.

As the read-only mount was succeeded, I thought btrfs-send/receive might
be useful, but it didn't work because the subvolume was NOT read-only.
Your plan to improve btrfs-restore is just awesome.

Apparently 7 files (ERROR: cannot map block logical ...) and 88 directories
(Reached the end of the tree searching the directory) couldn't be restored.
I'll move to docker's side to see what were lost.

Regards,

Hideaki
