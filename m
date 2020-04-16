Return-Path: <SRS0=CVGX=6A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649AFC2BA19
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Apr 2020 01:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C80206A2
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Apr 2020 01:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=mpdesouza.com header.i=@mpdesouza.com header.b="K3t6bpfh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406045AbgDPBFJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 21:05:09 -0400
Received: from gateway33.websitewelcome.com ([192.185.147.108]:19969 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405821AbgDPBFG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Apr 2020 21:05:06 -0400
X-Greylist: delayed 1250 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Apr 2020 21:05:05 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 216B7148214
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2020 19:44:12 -0500 (CDT)
Received: from br540.hostgator.com.br ([108.179.252.180])
        by cmsmtp with SMTP
        id OsdYjuD0q8vkBOsdYjgClI; Wed, 15 Apr 2020 19:44:12 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mpdesouza.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r5VgrpcJvSO+EPjCv5pqvUeAaoQgIXO94MPE0DvrYRE=; b=K3t6bpfheYkLFDkljqyhGMDNbx
        wav3PTzcCxcXTXSBz2HK8Jx73gJwfzeRWttZzd3O6VUD/dN0OCME/tFUeVhZ85Iwm29JcmIjv7gyP
        fKTyHP2TK5wMB1/aNGUpQC1cyyuyt0Xnl93WKVP6uzvzk2jfgG2U0LEdDpyPghOgbe+jMg/4cw15M
        +YBzDeyoI68OW1CSVGJmDWm5fX7owH/NRqrNZHD8axQmtDQ7S0jk/HALDW7e5xA6sn+CM5KnbOtvl
        fFPNJYYPFjc3AWLbR3kpe/tgUwXm7GP6eg4iLnGzrkqTlHonXGKDX5ut0Iz+GuKttm9e6sZafWzRH
        e6jQhA0w==;
Received: from [177.132.129.218] (port=35128 helo=hephaestus.suse.de)
        by br540.hostgator.com.br with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <marcos@mpdesouza.com>)
        id 1jOsdX-0046UY-IP; Wed, 15 Apr 2020 21:44:11 -0300
From:   Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCHv3 0/3] btrfs-progs: Auto resize fs after device replace
Date:   Wed, 15 Apr 2020 21:46:39 -0300
Message-Id: <20200416004642.9941-1-marcos@mpdesouza.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - br540.hostgator.com.br
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mpdesouza.com
X-BWhitelist: no
X-Source-IP: 177.132.129.218
X-Source-L: No
X-Exim-ID: 1jOsdX-0046UY-IP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (hephaestus.suse.de) [177.132.129.218]:35128
X-Source-Auth: marcos@mpdesouza.com
X-Email-Count: 3
X-Source-Cap: bXBkZXNvNTM7bXBkZXNvNTM7YnI1NDAuaG9zdGdhdG9yLmNvbS5icg==
X-Local-Domain: yes
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

Changes from v2:
* Fixed the code format after moving function resize_filesystem in patch 0001
  (suggested by David)
* Sorted the resize_filesystem function prototype in patch 0001 (suggested by
  David)
* Changed the -a into long argument --autoresize in patch 0002 (suggested by
  David)
* Translate srcdev if the argument is not a devid (suggested by David)
* This also changes the way we use the ioctl, now only passing devid to the
  kernel, instead of passing the path and letting the kernel to translate
* Add tests to check the autoresize functionality

Changes from v1:
* Reworded the help message and the docs telling the user that the fs will be
  resized to it's max size (suggested by Qu)
* Added a warning message saying that the resize failed, asking the user to
  resize manually. (suggested by Qu)

Both changes were done only in patch 0002.

Anand suggested this job to be done in kernel side, atomically, but as I
received a good review from Qu I decided to send a v3 of this patchset.

Please review, thanks!

Original cover-letter[1]:
These two patches make possible to resize the fs after a successful replace
finishes. The flag -a is responsible for doing it (-r is already use, so -a in
this context means "automatically").

The first patch just moves the resize rationale to utils.c and the second patch
adds the flag an calls resize if -a is informed replace finishes successfully.

Please review!

Marcos Paulo de Souza (3):
  btrfs-progs: Move resize into functionaly into utils.c
  btrfs-progs: replace: New argument to resize the fs after replace
  btrfs-progs: tests: misc: Add some replace tests

 Documentation/btrfs-replace.asciidoc        |   5 +-
 cmds/filesystem.c                           |  58 +----------
 cmds/replace.c                              | 105 +++++++++++++-------
 common/utils.c                              |  60 +++++++++++
 common/utils.h                              |   2 +
 tests/misc-tests/039-replace-device/test.sh |  56 +++++++++++
 6 files changed, 192 insertions(+), 94 deletions(-)
 create mode 100755 tests/misc-tests/039-replace-device/test.sh

-- 
2.25.1

