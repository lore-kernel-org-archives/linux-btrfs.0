Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522CBC433E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Feb 2021 23:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D2364EC8
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Feb 2021 23:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhBUXC6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 18:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbhBUXCy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Feb 2021 18:02:54 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779B6C061574
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2021 15:02:14 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m25so3247887wmi.3
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2021 15:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zelmu0X7omYtR8Pplums/uwYW5+cpdDgUmygN1siT6w=;
        b=kP0bNIcW/smcphOcmASIRZC5ZVugSCiyo6JQ1c0k01t4X5l5eFW7AQ99Ahbh4NOjWA
         dszS0jkWopB1w91wJ082yTLBr6DPP/9JQ2Nb8EzTrDGaxYTatut+A6gXnoD9fRwl6/JX
         gJ7pCMcp55dQaqZBLnAE79n4sJMpvQqo1UXwIVPFUXb7eft6jP7X3/iT7O+YuU30EXiO
         rM4GvO6pRJ1r5cVQJ2NwTVoUAPQs0conlyrMUnLNq+Pa53me5WqB+xXLUl9VR9aSSj2/
         q5wLYkWRgRa9+uyXFPJiKxBzufgADtx0534uSaYM9hfKsvH9FmmqVyJHGBrVIKzZbg8n
         X4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zelmu0X7omYtR8Pplums/uwYW5+cpdDgUmygN1siT6w=;
        b=kgWX8MPgb57TAfu81RMHCTjc8owqmyvsdQsugNe8fHlCxSgENvUYkgo0BMt+3Mp/89
         /+Xhtft6FB4U2ed8I1Mbk1+UM/ReerKcxm0naxfHC2z22W/Iz6E9zAhi0BVDXPp4cCJ+
         ZlFJeCqX6Mbs1hBDnHw2cQY6rB0VETVsP5+IBRkh5XGbdjDJsAiRre7stNfJdYvzhyu9
         SPGo+6zfRfhuPqijw/aFtbwM26TrFeyDBcQEJPyT923KYD54GWJLtHqK9YCyvOphQTel
         1hfXGvRMZimpRGoxaB/wgzcQAzNMnbkfxLFzG24xVrtbvGwTOSaWb2GoDdF8T1Ay8Udm
         l2nw==
X-Gm-Message-State: AOAM532UP/XpxYF0LK8Zf09JXW5LXZyD5LAYscyYv4dZu2CRulOqExRr
        hkmjwd8uTBeb4GbkmP6xnnHWcdiDwU5cXFzQk6g69FojEhI3xA==
X-Google-Smtp-Source: ABdhPJxqOLvP/WKSGUiMsxVwA7VAoUEuFPVX8Vu4no6OoNivtqw+3CjWNBL3pTJG7Ug7vHhkIlz37+jO1hevh97LCqM=
X-Received: by 2002:a1c:c6:: with SMTP id 189mr17748806wma.128.1613948533021;
 Sun, 21 Feb 2021 15:02:13 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtTT7djC+FPEeQg3mJuO75JTJUaoKuibBF+KOq0SWKt+zA@mail.gmail.com>
 <20210221082648.365F.409509F4@e16-tech.com>
In-Reply-To: <20210221082648.365F.409509F4@e16-tech.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 21 Feb 2021 16:01:57 -0700
Message-ID: <CAJCQCtQ8EJ4_eKZvzWJ1bFpfrCjDevD45-F6pRatMt3PNE=adQ@mail.gmail.com>
Subject: Re: 5.11 free space tree remount warning
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 20, 2021 at 5:26 PM Wang Yugui <wangyugui@e16-tech.com> wrote:

> 1, this warning [*1] is not loged in /var/log/messages
>     because it happened after the ro remount of /
>    my server is a dell PowerEdge T640, this log can be confirmed by
> iDRAC console.

This is a fair point. The systemd journal is also not logging this for
the same reason. I see it on the console on reboots when there's
enough of a delay to notice it, and "warning" pretty much always
catches my eye.


-- 
Chris Murphy
