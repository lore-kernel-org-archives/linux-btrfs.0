Return-Path: <SRS0=jJu9=25=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D95DC282DD
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 21:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E516E20692
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 21:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="eVjaLas6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgAHVrg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 16:47:36 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:39365 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgAHVrc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2020 16:47:32 -0500
Received: by mail-wr1-f45.google.com with SMTP id y11so5074477wrt.6
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jan 2020 13:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CfxD1Ym4avvVFnKL01DU6QZfU0qlU9yc+47yRMEj5QU=;
        b=eVjaLas6oTI7BGxqDShMXDNxxRK+dy4vFeCmrZtcw3FcKou+B9A5O7EyhpCeorSRjx
         ePmLTEL3BtLwfnThtG9yW65jWSEP1fJsbgaVcwEmpL6rVKyaMGxqyGITgYcP0NNfER1y
         KD9Gs5uuxZorkEQGbqw/YHCVhOU7OivBmS4CJ+cUGO5JlkkYUY45DJBzEJsaSdt0Tk1D
         XidOkI7nK3di6VCqVCqN+tsjkBYUltBU7W4VvfveC233h7uFNdBIicmXpjx4vV4KIRui
         jDxmFag8cFI0W8Zx1mQXofMRGYM3JjLrpMfHLaMd1tb1ZLX1V4wQoGpiwHdohrBcA6kB
         PSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CfxD1Ym4avvVFnKL01DU6QZfU0qlU9yc+47yRMEj5QU=;
        b=J0NZU/DI8u7srOW79iR/Tyj5hTL7EFXVRhn1ZLxALO8o2ZeIGLJWjwRSkCQhEHYwHH
         uwG2oyymbr6qGZs9cp1nL/eqXeQiwYnXTJyTFNZyWZ8erEd6uF07KRVkOb977foE2QRu
         GJSnPV4trSPnHL+Nf4akyGBKOVmu1VB6P/jEcTaL475J775KJhR05s5hYSNjHbJeMWhM
         Hv9/vtjjRu2CJ/YDIUauYlt3RHhOdwyb9C261NCz75KkrTX7tfcrq8ZXhI+xNfKkTHrT
         IMiV0/4NAIBTWRxdbrcj3soS+S9OLFxBZ628eOXRnn2gImA628Jz1gdrqvP0R1e9qwkt
         yzNw==
X-Gm-Message-State: APjAAAV2zNRCIvzLPmSdX1F9tnv/rzyw9G3uvh8hdIQJRQY/audtHRkV
        jaR9mjNag2mqeuxlyM3K8NFTvfoXKD/ObcRJFLDgU+ImQklRcA==
X-Google-Smtp-Source: APXvYqylu05w5ZRx3B6rD9NLYIcG/Zmbv5Zy9SgslSMdT5+ihrbE8x5grPJw0g9x1raZJu1Y746TbbWvDlhFzXtO2lE=
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr6885778wrp.167.1578520050444;
 Wed, 08 Jan 2020 13:47:30 -0800 (PST)
MIME-Version: 1.0
References: <3283de40c2750cd62d020ed71430cd35@philip-seeger.de>
In-Reply-To: <3283de40c2750cd62d020ed71430cd35@philip-seeger.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 8 Jan 2020 14:47:14 -0700
Message-ID: <CAJCQCtQ-+h36QgOk5ZohLdNwEhzWwqpU=ZjsGXnDLNAPTmwv1w@mail.gmail.com>
Subject: Re: Monitoring not working as "dev stats" returns 0 after read error occurred
To:     philip@philip-seeger.de
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 8, 2020 at 10:47 AM <philip@philip-seeger.de> wrote:
>
> # uname -sr
> Linux 5.2.7-100.fc29.x86_64

Unrelated to your report, but you need to update your kernel. The one
you're using has a pernicious bug that can result in unrepairable
corruption of the file system. Use 5.2.15 or newer.

https://lore.kernel.org/linux-btrfs/20190725082729.14109-3-nborisov@suse.com/


--
Chris Murphy
