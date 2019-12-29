Return-Path: <SRS0=hNl+=2T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A926CC2D0C0
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Dec 2019 22:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73D3920748
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Dec 2019 22:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="aUz8qzWw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfL2Wcn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 29 Dec 2019 17:32:43 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53139 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfL2Wcn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Dec 2019 17:32:43 -0500
Received: by mail-wm1-f45.google.com with SMTP id p9so12702234wmc.2
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2019 14:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ARaDtWkq09dnS7x6Uu2BSVOHcYe/fT5+XhkRuhsQs6A=;
        b=aUz8qzWwadJJgZjyBNuA+Ujfz5i/3IzGjmyAorHV5VDbzXO1jr2V46TMMkD4iwewF4
         AAJbd8BuKovdZmZzERgaL+eH5iE0cs2jO3LplgOUIBXSkCtbltoYWJgmt6KijRVT9Nrz
         8sPjGecFDUxCs+Y6/w7fg649+tf6f4vIpG3Icv3L4fdmQepMYUIp1u5WQPoZbGD2OMup
         FIHLiGWdjGHXbJVUcRyp2ey7AwewP2pQPg9cJ8zecK2S2QBMg+VemmZBoBBRPXdv38K8
         D3haYQTDjJZ8tC1RaOOoDOPZ0COrpmblwOnXxXc5yL+xc39FAS+GpdgHC3jyF8Jvsdzv
         kZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ARaDtWkq09dnS7x6Uu2BSVOHcYe/fT5+XhkRuhsQs6A=;
        b=lVJRrau5OTwP41UrSjaSRbEe74GGSula1jVAaOKoNQVdetd7Q/rZ7I6+ftRE02aMDv
         qJITIDYs36ZhhTNq3FyCEIjQvcuasUi9xD5Hz5qtTyOQMSvOV7nE6HPcSx+kqnPRMxe7
         cocUmdrT/+O7eVbbT8fR821cMG92Xp4beKwm8B4BWyIm7SWOBTexto/2t1gq61Y4R1aN
         oLLSctd/9Z8RCOaM4njcepK953TSpVRwrrkDCnSivAxj2yxUMjLOTaYhN0XB1UevY7Ub
         d870HzI5j3pae/S6+EZRXOIkeUI37lW5ApDjHf37ZhYhQmP0BYrurWKIx1gDr2D6Xrq5
         bR8w==
X-Gm-Message-State: APjAAAV1JGEPUMIJrSTbSFuKuuoKKQZZYGdPtZO6FhHAa26HiCb/conW
        OMidmTqod/lbtE4q3z1gJEpilkxckz/m3pW1uQ7/l1mkscs=
X-Google-Smtp-Source: APXvYqzmogkmzfXR0DBFYH5qzVwn33tarHnv5GCY/FF6VCa/2upydTDUsh7AE45c/QX6EXxoqrHfcnnKzqIjqR9tJ1I=
X-Received: by 2002:a7b:cfc2:: with SMTP id f2mr29584169wmm.44.1577658760956;
 Sun, 29 Dec 2019 14:32:40 -0800 (PST)
MIME-Version: 1.0
References: <CAOB=O_jxu5JOe=JiYVW_VZ1rgs9+mdHpAHkscXkc4MVRLrBKDw@mail.gmail.com>
 <CAJCQCtQwLrZxfc7xb8FpVcV9r9rpEpD0SRPebRtRpS5SPYM_3A@mail.gmail.com> <CAOB=O_hLvVaSdnvXwFeC5h6=AySnb4Fh9Fzx-zjFmw92odSLzQ@mail.gmail.com>
In-Reply-To: <CAOB=O_hLvVaSdnvXwFeC5h6=AySnb4Fh9Fzx-zjFmw92odSLzQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 29 Dec 2019 15:32:25 -0700
Message-ID: <CAJCQCtQogopy56foRdqb6+3ejYL=gofVyYKwoAWFjYRgyaVZew@mail.gmail.com>
Subject: Re: read time tree block corruption detected
To:     Patrick Erley <pat-lkml@erley.org>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Dec 29, 2019 at 3:28 PM Patrick Erley <pat-lkml@erley.org> wrote:
>
> Should I --force it while mounted, or run the checks from RO mount status?

Check isn't reliable when the volume is mounted rw so I personally
wouldn't bother trying.


-- 
Chris Murphy
