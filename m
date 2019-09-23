Return-Path: <SRS0=yEAK=XS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB93C432C1
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Sep 2019 21:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1432053B
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Sep 2019 21:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="bl8BPpbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390760AbfIWVxC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 17:53:02 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37533 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbfIWVxC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Sep 2019 17:53:02 -0400
Received: by mail-wm1-f46.google.com with SMTP id f22so3714856wmc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2019 14:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bnQUESRCzyQB9Pf4KI/Vc1GEoSG0MFDq4J5AB80W0KI=;
        b=bl8BPpbmsi5Q3tn5z/Xbb2NN8q8YqGsVbDNO8p6G8OMMhDfEIc3s7nl5XxOZtXQIX0
         BxC0Q5OL18LTuo3RToyclxj3qbvyiwXmKF12dL+KS36Q9cfUl84dHseQsvfMfLYp+yy+
         jtWTHhdvjGkmhamTZSv50ghpBxgF9PIiVLu4pN5jgSV/wUf8bkoS0/VHPeqyhu9FK7oh
         xeYGlRVWOeL132rP4ME9RQOwrjZQO7WpYEkbQQcYHyLLvKJzngiQS+95UIEcyUoTY00v
         mxwPsQGA4GI5lWZqBgFF0Bot9YuoYiE1XlA1FFxYIJTkhlBadqVUuvoOH4pDTMrk9aBP
         Orlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bnQUESRCzyQB9Pf4KI/Vc1GEoSG0MFDq4J5AB80W0KI=;
        b=jsTga4WXYL9efsmItbN5+G0cip/83WamwXsWb2u2Hiunl4FeikTtd696Le3gALSTBY
         3UKITgB4PHPwJtL20llQFnD0d60bscRR3vYdSxDXDGTZhDO5elSigT0F9maiDlTzNc6A
         dWwxT6xEEGf4NcyyELQc43gdSuTeJttPHLNSqCXKFedBxYsHZ5hkZLucFnV6z//gVMYd
         zuTCkhovkYg2gIizC6wmj3Q2CyiW+xQSGuMVX4YGNr/28+AEn+jhztGoyk2wb8TUtZgq
         9U7e5uTnITnKIOmPH0hgmnPUWAx/5C6kCJBOGtnOxADdD4nb9Dx3vlKH7YJpg8SsoIOu
         vLXQ==
X-Gm-Message-State: APjAAAXPYznM80c64YieINZS/tJt8JiIjbnVQASafM/wz2a3P1ocSux/
        yG3ZpbaGTC+I44cHnSmse/qINW3huIwkIDcx3cskOA==
X-Google-Smtp-Source: APXvYqyqvTHgNgU+7Xn7xX7vo1zzXiFo0qoU4MtDAndtKH6KTXk5T6GTJvCDdSM4hAf9H8JbTLf2yhWKNbaF8fOVjp4=
X-Received: by 2002:a1c:5942:: with SMTP id n63mr1227404wmb.65.1569275578821;
 Mon, 23 Sep 2019 14:52:58 -0700 (PDT)
MIME-Version: 1.0
References: <94ebf95b-c8c2-e2d5-8db6-77a74c19644a@petezilla.co.uk>
 <CAJCQCtRAnJR+Z8Z8Bq91YXiMpfmwOiHK0tQ+9zAJvSVvexHnxg@mail.gmail.com>
 <54fa8ba3-0d02-7153-ce47-80f10732ef14@petezilla.co.uk> <CAJCQCtQLk1m8yAxPPDLVZBr3MehdDD3EpNZ6O_OCRsO-FFzRNw@mail.gmail.com>
 <eb9fdaee-ec76-5285-4384-7a615d3cd5c1@petezilla.co.uk> <00be81e2-bca2-3906-c27d-68f252a6ffe1@petezilla.co.uk>
In-Reply-To: <00be81e2-bca2-3906-c27d-68f252a6ffe1@petezilla.co.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 23 Sep 2019 15:52:47 -0600
Message-ID: <CAJCQCtRbjz138p_DVX4=v0e38rtDFjpqrOhBTc4o7Mc=s_zcEw@mail.gmail.com>
Subject: Re: Balance ENOSPC during balance despite additional storage added
To:     Peter Chant <pete@petezilla.co.uk>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

What features do you have set?

# btrfs insp dump-s /dev/
