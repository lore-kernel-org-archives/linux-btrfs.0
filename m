Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6C9C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Feb 2022 00:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiB1AvG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiB1AvF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Feb 2022 19:51:05 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FE840A1D
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Feb 2022 16:50:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0399B1F891
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Feb 2022 00:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646009427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=170EA1/dFoyrdZE+bRG2gqzSxHzSYuhYHuIixcfFoQY=;
        b=ZNqudE+ulNMaOCtY5yPhIzRWU1ZuwJP1vBoDsuR1/tPUtDYEfOBD8tz9iROVS0kMQ5W3sB
        e5m8bf7dr92vUTl+4N3kwlwm56uoFaEkNmPF2cBBdkajSzsb3tNet6D6X1/cAf9jWLaqz3
        wpNrXu/CJS15292B15WACcrxiW1Hcyg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4DB79139BD
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Feb 2022 00:50:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Bf8MBlIcHGJ3OwAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Feb 2022 00:50:26 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: add check and repair ability for super num devices mismatch
Date:   Mon, 28 Feb 2022 08:50:06 +0800
Message-Id: <cover.1646009185.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/super_num_devs

The 2nd patch contains a compressed raw image, thus it may be a little
too large for the mail list.

This patchset will allow btrfs check to detect and repair super num devices
mismatch.

The detect part is to iterate through chunk tree to grab the correct
number of devices.
This is more reliable than counting devices in fs_devices, since seed
device is in another fs_devices.

The repair is more straightforward, just reset the value in superblock
and commit a transaction.

Qu Wenruo (2):
  btrfs-progs: check: add check and repair ability for super num devs
    mismatch
  btrfs-progs: tests/fsck: add test case for super num devs mismatch

 check/main.c                                  |   1 +
 check/mode-common.c                           |  88 ++++++++++++++++++
 check/mode-common.h                           |   2 +
 .../default.raw.xz                            | Bin 0 -> 22028 bytes
 4 files changed, 91 insertions(+)
 create mode 100644 tests/fsck-tests/054-super-num-devs-mismatch/default.raw.xz

-- 
2.35.1

