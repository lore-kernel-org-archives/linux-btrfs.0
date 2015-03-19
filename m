Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33834 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbbCSXGM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 19:06:12 -0400
Received: by obbgg8 with SMTP id gg8so66182409obb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 16:06:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Mar 2015 16:06:11 -0700
Message-ID: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
Subject: Upgrade to 3.19.2 Kernel fails to boot
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I upgrade to the 3.19.2 Kernel I get a deadlocked boot:
INFO: task mount:302 blocked for more than 120 seconds.
INFO: task btrfs-transacti:329 blocked for more than 120 seconds.

I have an LTS Kernel at 3.14.35 that also fails to boot with the same behavior.

My 3.18.6 works just fine.

-rb
