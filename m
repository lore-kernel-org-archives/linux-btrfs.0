Return-Path: <SRS0=8sAC=CD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D67DC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A8B72075F
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHYPCk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 11:02:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:52224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgHYPCi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 11:02:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8058EADDB
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2020 15:03:08 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] btrfs: Enumerate and export exclusive operations
Date:   Tue, 25 Aug 2020 10:02:31 -0500
Message-Id: <20200825150233.30294-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch series enumerates the exlcusive operation currently being
perfomed by the current filesystem and exports it in the sys filesytem
at /sys/fs/btrfs/<fsid>/exclusive_operation.

This would enable our tools to specify precisely which operation is
running on why starting an exclusive operation failed. The series also
adds a sysfs_notify() to alert userspace when the state changes, so
userspace can perform select() on it to get notified of the change.
This would enable us to enqueue a command which will wait for current
exclusive operation to complete before issuing the next exclusive
operation. This has been done synchronously as opposed to a background
process, or else error collection (if any) will become a nightmare.

For backward compatibility, the tools continue working as before if the
sys file is not present.

Changes since v1:
 - Corrected call for btrfs_start_exop() in btrfs_ioctl_dev_replace()
 - Use fsid_str[] instead of fsid[] to save on uuid_parse()

Changes since v2:
 - Dropped patch to add additional balance information
 - modified (simplified) progs patches accordingly


