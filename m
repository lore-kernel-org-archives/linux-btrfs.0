Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:56034 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3EULxc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 07:53:32 -0400
Received: by mail-we0-f171.google.com with SMTP id t59so290661wes.2
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 04:53:30 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Fortini <matteo.fortini@gmail.com>
Date: Tue, 21 May 2013 13:53:10 +0200
Message-ID: <CAC_9p+9mBbLfPjuL0Rqf=8A0pdqm3LTuxto04H=F--XL6eR+6w@mail.gmail.com>
Subject: Regression in kernel v3.9.3
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I just built and installed kernel v3.9.3 (was using v3.9.0 before) and
if I do a git fetch on a quite small (<1MB) directory, the system
starts thrashing and I can't even kill -9 git.
It's a btrfs partition with no fancy mount options (just relatime) on
a core i7 with 8GB RAM, Debian testing.

Please tell me if there's any test I can do to help.

Thank you
Matteo
