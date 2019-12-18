Return-Path: <SRS0=fY3M=2I=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612E2C43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D6721775
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:17:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1T3I4uH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLRBRH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 20:17:07 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:53506 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfLRBRH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 20:17:07 -0500
Received: by mail-wm1-f52.google.com with SMTP id m24so101703wmc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 17:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1dW0EZ3t3h+5kPOELNcAo3OQFCBYuhAA+qezRZC+fzk=;
        b=A1T3I4uHLUuHe2CMtXqzmAfqhtkJ3SHAMNJDWULnGQSlffB1KLpd3Y2CiW8AQkDoLZ
         Ojy4alj6q/tKhf5KMoXyhXF1tGWClxFiqZO8XDHxLmEcjG+XBwH8t6VXGH/KpjabyizA
         3kUGt30lCHN/NtIQaoUZR7Xe8g2JU0pxwdcgFynUDXbCb8ZGtMav9ReQH9YtFLTVwlyb
         UAo5blsDtB70w2q18P7QpanHWYdJUrG3tQZYLM1IZa9vfJ6iDflwiAyCJzBh3emmgCnf
         zfVUsDBKGCLlGE6KJavZxtyOldRiWmAG0E1SlvyyVO0Jx8ZIqakldCw1XqfCzcy4IUZl
         /hZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1dW0EZ3t3h+5kPOELNcAo3OQFCBYuhAA+qezRZC+fzk=;
        b=j1XLu9/echdub4hurc51id5e7xq64DQFS3drF3iIbMfHvHF8a0tq4IGY8c8X8owMcs
         Gqdi3a1szbaEagjbDvxmN1WUeacxkrFezBtMV4TnIAtBgbZDhk8tX+5GoaKEdEkh4rYD
         NXd1QRGcfBL6WmapI69KHnqbiSsSEyBf0TFm+vxTsZee4hu8IH9wjBHWJI902xGL+waG
         Wtv0CJs/jv7DhA2gaSy7wQBmSVCyaZDAzPf+9kqFltEF5CWRO2e5bBykP1z+Sxz+Jyhu
         d2rq3cNLjf/76BOaR3i0aq2P2JxsdxBd0yaikCJVCA+PwU8VNOUNE4oiaj003+bDYUy9
         bMRA==
X-Gm-Message-State: APjAAAXJ2PtLgn8Wlnfpb684GUqDh+L+5vjiP/1RLi1ZFvcj5o4DoTC0
        XAwSKJCoAEN0Ch7M6h9iaJLc/0ln
X-Google-Smtp-Source: APXvYqwmEiHSNy+PKhXAW4a9M04Nyc0Th6qIRV/PTOZmKoq/hfN5SsI9NelYIUGHg3VILj+mwjCZsw==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr17280wme.151.1576631825272;
        Tue, 17 Dec 2019 17:17:05 -0800 (PST)
Received: from hephaestus.suse.de ([179.185.209.78])
        by smtp.gmail.com with ESMTPSA id g25sm4782854wmh.3.2019.12.17.17.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 17:17:04 -0800 (PST)
From:   Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>, wqu@suse.com
Subject: [btrfs-progs PATCHv2 0/4] tests: do not fail if dm-thin is missing
Date:   Tue, 17 Dec 2019 22:19:21 -0300
Message-Id: <20191218011925.19428-1-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

Hi there,

This is a v2 of the patches which basically changes the first patch and adds
Reviewed-by to other reviewed patches. The change in the first patch was to
remove the SUDO_HELPER variable from check_dm_target_support, since nowadays
everyone executes these tests using root.

Original message:

these patchset is trying to fix the issue 192[1] by checking if dm-thin exists,
and if it's not available, skip the test. In the last patch, the same is done
for dmsetup. Feel free to ignore the last patch if you think we should stop the
tests if dmsetup isn't available.

Thanks!

[1]: https://github.com/kdave/btrfs-progs/issues/192

Marcos Paulo de Souza (4):
  tests: common: Add check_dm_target_support helper
  tests: mkfs: 017: Use check_dm_target_support helper
  tests: mkfs: 005: Use check_dm_target_support helper
  tests: Do not fail is dmsetup is missing

 tests/common                                   | 18 ++++++++++++++++++
 .../005-long-device-name-for-ssd/test.sh       |  2 +-
 .../test.sh                                    |  2 +-
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.23.0

