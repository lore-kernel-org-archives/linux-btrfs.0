Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CC5C46475
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 01:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84F982089D
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 01:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84F982089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fullpliant.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbeJGIPN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 04:15:13 -0400
Received: from dc2.fullpliant.org ([213.186.44.166]:34322 "HELO
        dc2.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725873AbeJGIPN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 04:15:13 -0400
Date:   Sun, 7 Oct 2018 03:08:54 +0000
From:   Hubert Tonneau <hubert.tonneau@fullpliant.org>
To:     linux-btrfs@vger.kernel.org
Subject: btrfs-progs 32/64 bits mode unconsistency
Message-ID: <hubert_tonneau/G8NOZ9TJ/0IECWMC@hubert-tonneau.storga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

If the 'btrfs' executable is 32 bits and the kernel is 64 bits,
then 'btrfs replace status' and 'btrfs replace start' commands will fail with error message:
ERROR: ioctl(DEV_REPLACE_STATUS) failed on "/mnt/data1":Inappropriate ioctl for device

Other commands seem to work properly.

Regards,
Hubert Tonneau
