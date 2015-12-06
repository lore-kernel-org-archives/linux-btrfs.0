Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36735 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbbLFTPz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 14:15:55 -0500
Received: by iofh3 with SMTP id h3so162407906iof.3
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 11:15:54 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 6 Dec 2015 13:15:54 -0600
Message-ID: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
Subject: Scrub on btrfs single device only to detect errors, not correct them?
From: Jon Panozzo <jonp@lime-technology.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just to confirm, is the sole purpose of supporting scrub on single btrfs
devices to detect errors, but not to correct them?

Best Regards,

Jonathan Panozzo
Lime Technology, Inc.
