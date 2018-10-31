Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919A9C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 04:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B1820685
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 04:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="GYefdtD9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21B1820685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbeJaNwb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 09:52:31 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:33835 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbeJaNwa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 09:52:30 -0400
Received: by mail-lj1-f180.google.com with SMTP id g8-v6so10692321ljk.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 21:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=cWGWjly9uaVpr93iU4CuRGRq9LTTZ/rHMmWFcwV+gsM=;
        b=GYefdtD9OdzAPpVGO134WBobEE2drlgbEoxmPK7GlBfbyEhTh3nFLcaD2GGZws/MVE
         UjpLhzWZZQ+BYRJqATrSdb0bQA52EmA/wrvDvE2Np80f3F8SpC3LM0ACofTV2QWR+8lJ
         pNSYF3lLJ2017H1vY8Xo89QF1CaO+CD+f4cmrRZPz9M46WDxRhwR3fZpUdFxl8UaAbx7
         Ew4X7AEUK97ubNUprVlICIU5ewhaL9y34H874wdozRPHHaKNExGIV7i/dIjU/aKvaFfr
         b1+tWmipLMIRGbVpU5TnNBJDUBr7CKSn20cZyQrOanftpbh1jfUArNgnQBc3bBrQq0z8
         CF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=cWGWjly9uaVpr93iU4CuRGRq9LTTZ/rHMmWFcwV+gsM=;
        b=oSUiFoKXe++bfwYyED3vikBHcoDwymmr2FdCyrmG+Q0zr9fyWHfJ/9y4eQRBPvZrmN
         xipSC/l8Y6gnlGOLecbW15FGb5mLghpbr4TXrqwX10hvoM5LkEXAUr/gqaIvU5H0r6eX
         q0sa2BuH6a76aiFTlcKh39RLQLuk4eaAwadcGtc6QYVXCiqBSfB939SCh5TwcSTspLcd
         cK+VlkIgy0afz0AwrSyanRsDQl8+6OLov5odyzEfkOXDk8FrAPQcvIkHvE+5OXl/pHI7
         M3Zr7UCaCLxHZELxu3d6c99jlCmCmNIwCZj/jN+C2lAFdDe8G9z/c5YOMYIT8C1XsT6z
         wDbA==
X-Gm-Message-State: AGRZ1gKut4NKqBbo7jeQI2LVo8DzWyefITc03VXVInzFER3zOY85w495
        RitTC9+lNH69hs5WU6vOBPZ4L5l7GAJcleNARZmhHA==
X-Google-Smtp-Source: AJdET5dDV1tCVRgAjIQNfJ2MY5QJ/LZ6CPfKS7/S8Zly9/ZsvgK9tOI9qrh6KM1//A5d/t7NH6YpLGbpLv2jsdhYHHg=
X-Received: by 2002:a2e:2e1a:: with SMTP id u26-v6mr1027256lju.8.1540961762067;
 Tue, 30 Oct 2018 21:56:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:4f11:0:0:0:0:0 with HTTP; Tue, 30 Oct 2018 21:56:01
 -0700 (PDT)
X-Originating-IP: [192.240.97.84]
In-Reply-To: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 31 Oct 2018 00:56:01 -0400
X-Google-Sender-Auth: iKXymZQ9QKIOJD3BDaO_SBJ2flw
Message-ID: <CAJCQCtRT=C2TjTncf=QJFOiSHQ8HCfM3sLqPbByGCn2MZY-0Tg@mail.gmail.com>
Subject: Re: Salvage files from broken btrfs
To:     Mirko Klingmann <m.klingmann@gmx.de>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 4:11 PM, Mirko Klingmann <m.klingmann@gmx.de> wrote:
> Hi all,
>
> my btrfs root file system on a SD card broke down and did not mount anymore.

It might mount with -o ro,nologreplay

Typically an SD card will break in a way that it can't write, and
mount will just hang (with mmcblk errors). Mounting with both ro and
nologreplay will ensure no writes are needed, allowing the mount to
succeed. of course any changes that are in the log tree will be
missing so recent transactions may be unrecoverable but so far I've
had good luck recovering from broken SD cards this way.




-- 
Chris Murphy
