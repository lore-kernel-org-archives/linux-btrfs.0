Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:64889 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3KXNr6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 08:47:58 -0500
Received: by mail-vb0-f50.google.com with SMTP id 10so2185190vbe.9
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 05:47:56 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 24 Nov 2013 14:47:56 +0100
Message-ID: <CAD_cGvHFg11+RhqYDcu=zcUWpRAi85WqW7Wm5K040J_+h_mcGw@mail.gmail.com>
Subject: The state of btrfs RAID6 as of kernel 3.13-rc1
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

What is the general state of btrfs RAID6 as of kernel 3.13-rc1 and the
latest btrfs tools?

More specifically:
- Is it able to correct errors during scrubs?
- Is it able to transparently handle disk failures without downtime?
- Is it possible to convert btrfs RAID10 to RAID6 without recreating the fs?
- Is it possible to add/remove drives to a RAID6 array?

Regards,

Hans-Kristian
