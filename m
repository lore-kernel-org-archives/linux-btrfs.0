Return-Path: <SRS0=jbNX=Q6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE02FC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 22:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7CA9206B6
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 22:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfBWWKi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 Feb 2019 17:10:38 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38783 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfBWWKi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Feb 2019 17:10:38 -0500
Received: by mail-wm1-f66.google.com with SMTP id v26so4891491wmh.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Feb 2019 14:10:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RY6LX+W3dKeLe/PX+jhD5Ti5Xky3jZeydZVIVxS3zxs=;
        b=VF5yu3NHdB6Ax4nYWAuF+mhoH/uQHT8cuV+5zHuefqiJNvTEjWAW5JbRrOnMDztxeL
         /8ZwFPcni1Fkhk36SESmflkCsws1i1EclOyub2HhAHSeRKaJrDfPSgfmDGwy+sva+yUj
         PXyAxqSiX5HjB1uSXgNfP333Ve5iQ32aslxh+QpTdcefFILQAbKiFkCiGleXAY83gElj
         7rsJOylwY+KjpupiImJb+n4Syla8tWhjLvN2iMQ///LH/7bZjLDi4oSD2sAyCyXVxgz7
         zU9Xet5X75xr2EW5UfkJGRY+dTtMdWGO++ban1vm1lOu9KlzTi5RWysuRjLnOIW2fGCG
         CQHA==
X-Gm-Message-State: AHQUAubWdVer5PIPyHARMPkNA8wqcsmkhZkzB7bMRkoEtGdMbqMEsEN5
        1jmKuOHTTDRsdYkbYpAP0uDynsWVyWrC4vf1DZkePVQPr0U=
X-Google-Smtp-Source: AHgI3IZB1SFXhcL0rirnlzuEJro+ekPUeLxM278mplNDJvoBnLoxlmieFWDHJAPwTOSqWne7/fTbIzpBbQ7K3w/LQ7Y=
X-Received: by 2002:a1c:3d84:: with SMTP id k126mr6348369wma.60.1550959836452;
 Sat, 23 Feb 2019 14:10:36 -0800 (PST)
MIME-Version: 1.0
From:   Ross Boylan <rossboylan@stanfordalumni.org>
Date:   Sat, 23 Feb 2019 14:10:25 -0800
Message-ID: <CAK3NTRCvq17-OaaCPujreveURnyL7NzWP_XBm5FMu=czh9YxZQ@mail.gmail.com>
Subject: limits on number of snapshots
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Various sources (https://btrfs.wiki.kernel.org/index.php/Status,
https://wiki.debian.org/Btrfs) warn that "too many" snapshots,
possibly as few as 12, can degrade performance.  OTOH, Marc Merlin's
talk identified snapshots as one of btrfs's killer features.  And the
status page https://btrfs.wiki.kernel.org/index.php/Status doesn't
note any performance issues with subvolumes/snaphshots.

As a practical matter, do I need to limit the number of snapshots?
Does it matter what kernel version I'm running?  I have a VM running
4.0.9 and am looking to install Debian Buster which is 4.19 at the
moment (4.18 on my first install).

Thanks.  I'd appreciate if you'd cc me on replies.

Ross Boylan
