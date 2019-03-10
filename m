Return-Path: <SRS0=V0ug=RN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA0AC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 23:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 989A2206BA
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 23:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="sHQPnLbI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfCJXJP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 19:09:15 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:35455 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfCJXJP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 19:09:15 -0400
Received: by mail-lf1-f43.google.com with SMTP id h6so2017551lfc.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2019 16:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=sTWmLA3AP0DjERCXDSduN5vjM29TRJM8P36QtqJKfEQ=;
        b=sHQPnLbIrKrKLCrKucLOAmueHxq1mKAfrqHoiI6OcLlR0GluwhyH6XL3vHtORc9Zmf
         5/Kw1iNmo4Sw+KjU8LXGMMO3H0J7fOX0PCjbGmjrVs5bVzQIENwK6G0oFjzQtEFYoeih
         9gYZPf/AwdB8kojgfg3kszw1nXudVP2IDCo0TOmfr1yhPkjSkjfV50zkAT+gv6mJSmqn
         of7LtNYrrcMpF8ymaOH6b8i9muvjgCeVx0mVevSHi1fXTRg4VY/alv/H0yFFS4+PAI6l
         I3Shwt2JxNRvl6atfBfRs4A8mV1MYlJOnzXBYW1QbY2o7n1iHH8TosAt2iOy5yZBVeJk
         1Ubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sTWmLA3AP0DjERCXDSduN5vjM29TRJM8P36QtqJKfEQ=;
        b=Keee1e8Mo6IWmDK5u3SPRBSsPWiIr2eLCPs9dZ+17RGU1brZX6PkEGBhhb9kvGXcZR
         7l/O/ia5sOiIL00lM/dKoV18jKc20NmuNQZvhD6ABxWnBJJSCqjtsiPOb851Lk6xr5tG
         NLiUEvRBUjX3odS0/PNOOYCeU10bJ3J3B2fknV23lbnCOg2f9LvUwyIEHVVb1PAbuKmP
         Z6lWhmCCCqGR8sHs9/ga4M6jQZPtRupwQTPShYi9aBF71SzMWUPLw1sM8nFrYRFLHVGW
         5q8oUvJvQZdWv9o9WetU0V2MnjQA8ru5+g89NavhwIQ94i2gezbNGTrSbxO1ONYqgeYR
         T4PQ==
X-Gm-Message-State: APjAAAWRIKu/UXvCBkfV9dLUCWKoffVD+IZfuYVEGum9PNtN6czxBqjj
        dRSLY+u30h5xNd/W6/ncNHYxDWAq5KaqoR4EKKdUrasvY3s=
X-Google-Smtp-Source: APXvYqxWSDalRsFs4GmQfht+6ecPg7T2rOjYbePlbV5Wgpgf8TVXtOwUP4GhzYZeRBRWK0UW1DSOLSoWtU/dVaCqpDE=
X-Received: by 2002:ac2:518d:: with SMTP id u13mr15130952lfi.133.1552259352767;
 Sun, 10 Mar 2019 16:09:12 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 10 Mar 2019 17:09:01 -0600
Message-ID: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
Subject: confusing behavior when supers mismatch
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In the case where superblock 0 at 65536 is valid but stale (older than
the others):

1. btrfs check doesn't complain, the stale super is used for the check
2. when mounting, super 0 is used, no complaints at mount time, fairly
quickly the newer supers are overwritten

Is this expected? In particular, in lieu of `btrfs rescue super`
behavior which considers super 0 a bad super, and offers to fix it
from the newer ones, and when I answer y, it replaces super 0 with
newer information from the other supers.

I think the `btrfs rescue` behavior is correct. I would expect that
all the supers are read at mount time, and if there's discrepancy that
either there's code to suspiciously sanity check the latest roots in
the newest super, or it flat out fails to mount. Mounting based on
stale super data seems risky doesn't it?

-- 
Chris Murphy
