Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19E8C25B0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Aug 2022 08:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345210AbiHSIky (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Aug 2022 04:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347244AbiHSIkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2022 04:40:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513C26171B;
        Fri, 19 Aug 2022 01:40:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C5BBF5C96E;
        Fri, 19 Aug 2022 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660898408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rO5Ck8o5RLGr1DaVgAzt1QcFzm1NbtX/asTpCmXl85M=;
        b=Z4khjLcE+yg3+AINlOSkiPn4oL2lSIACw9NnBDs2X1wmzcsoB8NqGgaI+gbwKxH6DU+41M
        PpZYSi466Pk4rkb5AxMkw6+tooL7WUvVmWRGnkENrNfBhZB2e2gYt5SI1lUrlzIcaKoPTb
        H3TZpCnwiGjDaFIl5esj0QaDaOFMvXM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BD3CF13AE9;
        Fri, 19 Aug 2022 08:40:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4GSgH2dM/2LDagAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 19 Aug 2022 08:40:07 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH STABLE 5.15 0/2] btrfs: raid56: backports to reduce corruption
Date:   Fri, 19 Aug 2022 16:39:48 +0800
Message-Id: <cover.1660898037.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is the backport for v5.15.x stable branch.

The full explananation can be found here:
https://lore.kernel.org/linux-btrfs/Yv85PTBsDhrQITZp@kroah.com/T/#t

Difference between v5.15.x and v5.18.x backports:

- btrfs_io_contrl::fs_info and btrfs_raid_bio::fs_info refactor
  In v5.15 and older kernel, btrfs_raid_bio and btrfs_io_control both
  have fs_info member, and the new rbio_add_bio() function utilizes
  btrfs_io_ctrl::fs_info.

  Unfortunately that rbio->bioc->fs_info is not always initialized in
  v5.15 and older kernels.
  Thus has to use rbio->fs_info instead.

  If not properly handled, can lead to btrfs/158 crash.

Qu Wenruo (2):
  btrfs: only write the sectors in the vertical stripe which has data
    stripes
  btrfs: raid56: don't trust any cached sector in
    __raid56_parity_recover()

 fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
2.37.1

