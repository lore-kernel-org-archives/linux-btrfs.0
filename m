Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35947 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbcAGTLp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jan 2016 14:11:45 -0500
Received: by mail-lf0-f52.google.com with SMTP id z124so333371369lfa.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jan 2016 11:11:45 -0800 (PST)
To: The development of GNU GRUB <grub-devel@gnu.org>,
        linux-btrfs@vger.kernel.org
From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: btrfs trim erases bootloader area
Message-ID: <568EB86F.7070800@gmail.com>
Date: Thu, 7 Jan 2016 22:11:43 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As discussed on opensuse-factory list, running fstrim on btrfs erases
bootloader area, rendering system unbootable. See

https://lists.opensuse.org/opensuse-factory/2016-01/msg00067.html
https://lists.opensuse.org/opensuse-factory/2016-01/msg00090.html

and follow-ups that demonstrate that beginning of device gets zeroed out.

Not sure what we can do, but from GRUB side I can only see disabling
embedding support on btrfs entirely.


