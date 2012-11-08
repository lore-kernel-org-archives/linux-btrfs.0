Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33856 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab2KHWod (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 17:44:33 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so2369570pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2012 14:44:33 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 23:44:33 +0100
Message-ID: <CAAMcf8Di_BWEzON2EuY1vYRq_HF+5vJKDy88TnC9Z8QePFbCJA@mail.gmail.com>
Subject: error checking mount status
From: vj <vicencb@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
when executing "mkfs.btrfs fs_file" as unprivileged user I'm getting this error
"error checking fs_file mount status"
where fs_file is a regular file, not a device
This problem is only reproducible when "/dev/loop0" is busy

mkfs.btrfs --version
mkfs.btrfs, part of Btrfs Btrfs v0.19

Regards,
  Vicente Bergas
