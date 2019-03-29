Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59764C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 03:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19A6721850
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 03:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="W3Ca5d3G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfC2DVQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 23:21:16 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:42168 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbfC2DVP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 23:21:15 -0400
Received: by mail-lf1-f43.google.com with SMTP id b7so413541lfg.9
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2019 20:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hIqgjRQc+jy92nTIbKQwWQycDZX1oluhO7XgvkfUxHU=;
        b=W3Ca5d3G+MZC3Um5CDJq7M96CmoAPLGfn9COuJ6o9X4LR0OIoPKnDTCyq+IFYTZ9O7
         +orIIOmvgWDvi3gNKIwllokjWO8nGHx4pOGTZj/KNxIFpqa7c/1mSfORhDSj5PmuH/rT
         VlMjI9xN96yBImez/F9dyPfsmR06kdVtJfP8s+LdQFDX31IbPKl2BtBnRE0ptT7ZRTwU
         POJt6hgvu9ZF6brC0DP/7tNJifJoOfWQrqUh0gptcyxANhbtXZ/yYj1p4X+H+gTb+Qft
         sz2saOEQQak86uOjB2/YoNLlOvRKy3YJrFl4mhPb67/3S9zLQkxs3Fc/Kr9SKx8Wh9C1
         WzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hIqgjRQc+jy92nTIbKQwWQycDZX1oluhO7XgvkfUxHU=;
        b=YTBzsGd2Ri3O91PIRD0rL6qQKBbhtT0Wp5SN27//C10F3kQNa+4qg03M1Tha4Rfn4b
         AClAPyvf4iOtEjeYcoqu4cnleVPNruqiPuuQ3yG8GGwHyUPAT9ME40ZRq/JEocPPZJNG
         KhksjQR1Rl74JHrraRGUBVbVZ5hVlrvlUUY6c72+4WgCGkssDkAwDdg6uNhFNFTgPWND
         EuZ6vpzBmX+DvFoFk4fT2xtFoeFCvOXeZ3grbcbfw3ikO5dPjtccGYnrVq7dKiDBvPcO
         jjwUZrp07mapsvV0A0/ilv7g+OAF2IG+amr305wJjXaonSY/zCcVeyXdhZ1hvbesPa4P
         D48w==
X-Gm-Message-State: APjAAAWqabUY+233qYlXl3kO/i40dEUJvt8YIX213oclbHg1N1jj5K9T
        UJyC53QUDhfAcQQ9HkZihzMjqfQtg/sWpcSZVQv0h4l6uIg=
X-Google-Smtp-Source: APXvYqzL2aGMsuyl7LCUrqcdJJq01NWgWTx3ax7LGj/si+JLFOfemkH10pcqIR5hAwXeYWb3BPrBdJt67Lt532NWxFE=
X-Received: by 2002:ac2:5638:: with SMTP id b24mr9972601lff.18.1553829673596;
 Thu, 28 Mar 2019 20:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
In-Reply-To: <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 28 Mar 2019 21:21:02 -0600
Message-ID: <CAJCQCtQSv5t9UuGOLmBqxC66WoDzcR4gcQ8K_Yqs0-K_b8yxrg@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Glenn Trigg <ggtrigg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 8:27 PM Chris Murphy <lists@colorremedies.com> wrote:
>>So I suggest 5.0.4, or 4.19.32, or you can be brave and
> download this, image it to a USB stick (dd if=file of=/dev/ bs=1M
> oflag=direct) which of course will erase everything on the stick.
>
> https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20190327.n.0/compose/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-Rawhide-20190327.n.0.iso
>
> That might have 5.1rc2 on it, or something in between rc1 and rc2.

Oh yeah, in case you go this route, at the bootloader menu, choose the
troubleshooting submenu and then choose to rescue a system. When you
get to the text installer there will be an option to get dropped to a
shell, at which point the installer quits. ~600MB


-- 
Chris Murphy
