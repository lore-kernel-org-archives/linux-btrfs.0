Return-Path: <SRS0=471q=2K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4D1C43603
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Dec 2019 21:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39602146E
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Dec 2019 21:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geWjGK2L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfLTVv5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 16:51:57 -0500
Received: from mail-yw1-f41.google.com ([209.85.161.41]:41336 "EHLO
        mail-yw1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfLTVv4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Dec 2019 16:51:56 -0500
Received: by mail-yw1-f41.google.com with SMTP id l22so4285463ywc.8
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2019 13:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OgSsbm+ws3KoqpvsLA4LtMz7uvNcre3wW2Zmeicx3MI=;
        b=geWjGK2L2GL1sWZBtO91PlyGWo3AXDHydABU0iLBGEdh+k9h91l0JXHdKw+CCYfOrl
         0vcRmYTito2VGFdwrar47Cdar6MO0M/RmzDPSfW6LGD5iWRl4sNgdROunMnjOvB70E0y
         12cyU8X2F3B/xXnIHOMM9v87QoljpxEI41pyBtn8mf+97BAjgtAW7bd/haD8C8v3EkP1
         H4P8b9u1JDSuV6oPASPsxTTSGGdn9D13A39XXjUw8akewFewvlOr5cZ64DUC6Hk9e8xJ
         Xq1PSO+c9ZmeoxOsl081HfSfEnyUesKtnZj02sbtW4PQZlmwg/ZjyUNp9W+vf+Yh9BCE
         AZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OgSsbm+ws3KoqpvsLA4LtMz7uvNcre3wW2Zmeicx3MI=;
        b=iHNF+T4uL7zlSttv1aMvvslqYjEE8M+r3fUipgW3qcDv1xLf4vs7cZwSVtViqjMihJ
         0+NXuK26mqDSXfTY9LN2ozCYDTYi7TnKNV21OPPxN4f8dfDxGT+z5TYVfRepPAEqVmm3
         M636G/TIDkYA1XFf/PBva6y0ZRNK/6Jd7m7Z/NJ8uirWy3uiLiVK/1BsUvZyh5R8z8z+
         QHDYZbiFBrcHPGQbEPspYZscKeevPm2Hmhc/z9zcCrwWfSDlR6Ppe+9qESXcc4kIiREi
         M2Jki9RTq1wc89kc7ecC8iTGzLDbo4LQdX+BpqPWHX2sh7e15lbu7G3B4LW1L3s4N3pU
         c5Lw==
X-Gm-Message-State: APjAAAXT2RvN5tCwaJ6qUbLSOQgrqtM9JyUEPNyvjyacxHq9Cv9Ga2Vz
        EZGzY6D6PrvZ/IdsQ2d1LIWV71bekEJ/MbXd8jvZow==
X-Google-Smtp-Source: APXvYqxh4d+iVgDmCSTAt07NvBBUjmmVSpb6h0SggTn9yeYBegSayf74Nq36cDEBUxB6brjss1G1w2ey8SAx8ONvqno=
X-Received: by 2002:a81:2847:: with SMTP id o68mr13013188ywo.245.1576878715569;
 Fri, 20 Dec 2019 13:51:55 -0800 (PST)
MIME-Version: 1.0
From:   James Courtier-Dutton <james.dutton@gmail.com>
Date:   Fri, 20 Dec 2019 21:51:19 +0000
Message-ID: <CAAMvbhEidM73zS-tRrtq0eYq_W-TY0BEnFumENkFaqVAwHmruA@mail.gmail.com>
Subject: Finding out where a file is stored on the disk
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

If I have a file on the disk that is using btrfs.
Is there an API call, IOCTL call that I can make to get from filename
to which sectors it is stored in?
If there is a command line tool, that would be ok too, because I could
find out the API calls from looking at the source code.
I have 100k files that I need to scan regularly on a HDD.
If I knew where they were on the disk, I could order the files in such
a way as to reduce seeks on the disk to read the files.
I.e. Read files from the lowest sector to the highest sector.
This would speed up the task of reading the files.

Kind Regards

James
