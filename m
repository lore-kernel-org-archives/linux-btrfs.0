Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145B3C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D90DA20651
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfAOLfO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:35:14 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:40018 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbfAOLfO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 06:35:14 -0500
Received: from relay7-d.mail.gandi.net (unknown [217.70.183.200])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 98E0E3A066B
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 12:28:31 +0100 (CET)
X-Originating-IP: 217.233.237.245
Received: from localhost (pD9E9EDF5.dip0.t-ipconnect.de [217.233.237.245])
        (Authenticated sender: leonard@lausen.nl)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id D8A3F20017
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 11:28:29 +0000 (UTC)
From:   Leonard Lausen <leonard@lausen.nl>
To:     linux-btrfs@vger.kernel.org
Subject: BTRFS critical corrupt leaf bad key order 
Date:   Tue, 15 Jan 2019 11:28:28 +0000
Message-ID: <87d0oyw46b.fsf@lausen.nl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi everyone,

I just found my btrfs filesystem to be remounted read-only with the
following in my journalctl [1]:

  Jan 15 08:56:40 leonard-xps13 kernel: BTRFS critical (device dm-2): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
  Jan 15 08:56:40 leonard-xps13 kernel: BTRFS: error (device dm-2) in __btrfs_free_extent:6831: errno=-5 IO failure
  Jan 15 08:56:40 leonard-xps13 kernel: BTRFS info (device dm-2): forced readonly
  Jan 15 08:56:40 leonard-xps13 kernel: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2978: errno=-5 IO failure
  Jan 15 08:56:40 leonard-xps13 kernel: BTRFS info (device dm-2): delayed_refs has NO entry

Following Qu Wenruo's comment from 4th Sep 2018, I have generated the
following tree-dumps:

  sudo btrfs inspect dump-tree -t root /dev/mapper/vg1-root > /tmp/btrfsdumproot
  sudo btrfs inspect dump-tree -b 1350630375424 /dev/mapper/vg1-root > /tmp/btrfsdump1350630375424

The root dump is at https://termbin.com/lz0l and the block dump at
https://termbin.com/oev5 . The number 1350630375424 does not occur in
the root dump. The root dump has 16715 lines, the block dump only 645.

Would this imply that the corrupt tree block was not yet commited? What
actions do you recommend to take next?

My kernel version is 4.20.2. I am writing this email via ssh from the
affected system on some working server. Besides the error message above
and the fact that the filesystem is readonly, I have not yet found any
issues on the affected system. Note that the error was occuring under
high system load while compiling a bunch of software on a tmpfs (and the
compilation was successful, but installation failed in the end due to
trying to copy to the by then read-only btrfs root filessytem).

Does this suggest a hardware issue?

Thank you for your help and taking the time to read this.

Best regards
Leonard

[1]: For unknown reason, the dmesg output does not reach back to the
time of the error, but only contains log messages from after the
filesystem was mounted ro.
