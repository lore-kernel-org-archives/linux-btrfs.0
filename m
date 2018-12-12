Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD074C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 06:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E9D820851
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 06:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="GEL3QysZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E9D820851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbeLLGQd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 01:16:33 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:36033 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbeLLGQc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 01:16:32 -0500
Received: by mail-lf1-f50.google.com with SMTP id a16so12637962lfg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2018 22:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SRYbgFKGhz/AYDs/UzwTjfjJ//7OKPgo01QMeevWDyE=;
        b=GEL3QysZP0MVZyqvyjbdHu5UKQGyZC7yS3OYk6d8m9DFzVPOkL3MD1SPPuv8Xxdydv
         AKttazvES5yt8W08Jzljz/Xh7xkNnx1shSxGJdR+Ss8v6EUHhV6ohuRsI2MzXP8Hitc4
         TM/hK8u+mTW9wwqvSbREfB+YV9redHVm8fov4StSM/qAaL9rVf/vY1T0Fuw4i1vZV+W6
         1+X5nVTbfL+IIa/267cZgSy+VSGaIeT4X2SRJNkTcx4CovNCDlZboTrmP4I/bygzuf2k
         XpT2XWVuetfYFGYhgiurokMTBFX8Y1aX+xJlMOPbdjcg0cfW9hVvr7AOCunK3SFUs0P5
         RRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SRYbgFKGhz/AYDs/UzwTjfjJ//7OKPgo01QMeevWDyE=;
        b=I6IoS1x2Tz82QxegWv3l8SKTeGNO1ls3NvXcEVdXk1yHM2AQ+uTFc0rPI9r/w7N5nf
         gdIZ8VdNwdYoZwev6Uouf5XKxUZQbSBEe0nMiaOoDSjY/ov0aPW/rgQoK3qE9QxEnM0w
         dW70NL1UPJKNXpgG/Ql9C3gdgLSQMd53voJuyjgpBus6bvtAkIQD2MFO4JBv+9Lp4P//
         eXTdstNIeWQk4/0keXtEL80e+ep+HA6DXeory4Dp5JaZ+q0Y1jV+sLwI9epkBRZwmCKA
         nOQwYkQe6wtsZQeCA5J0kStcAGBOWEyvh90Ilx7Wbh469f/Lnao4KSJASRP/PuKM0U4V
         I6eg==
X-Gm-Message-State: AA+aEWZnANacWQHyo1FEAKEid9GPZCnBwbNLsGFBq8PVv9amW7MOHw4T
        pPf15maqlePPw3HBwt0HPxwMNqckiO0sD0oQi3aQPQ==
X-Google-Smtp-Source: AFSGD/V/hO5I+Fu9Ird6qWL5ZI549XXpKRQYq0kw0d0radiBq5gGn3fMoo3K+73/TJn4EDoPdlf0/cGpOqiVxKRGqac=
X-Received: by 2002:a19:2755:: with SMTP id n82mr10383418lfn.94.1544595390179;
 Tue, 11 Dec 2018 22:16:30 -0800 (PST)
MIME-Version: 1.0
References: <20181210120514.GA14828@cuci.nl> <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
In-Reply-To: <20181211115226.GA20157@cuci.nl>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 11 Dec 2018 23:16:17 -0700
Message-ID: <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
Subject: Re: Kernel traces
To:     "Stephen R. van den Berg" <srb@cuci.nl>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Also, what scheduler are you using? And do you get different results
with a different one (better or worse)?


Chris Murphy
