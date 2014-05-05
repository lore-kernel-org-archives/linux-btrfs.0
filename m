Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f196.google.com ([74.125.82.196]:57352 "EHLO
	mail-we0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbaEEUvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 16:51:47 -0400
Received: by mail-we0-f196.google.com with SMTP id k48so1151753wev.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 May 2014 13:51:46 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 5 May 2014 22:51:46 +0200
Message-ID: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
Subject: btrfs on software RAID0
From: john terragon <jterragon@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.
I'm about to try btrfs on an RAID0 md device (to be precise there will
be dm-crypt in between the md device and btrfs). If I used ext4 I
would set the stride and stripe_width extended options. Is there
anything similar I should be doing with mkfs.btrfs? Or maybe some
mount options beneficial to this kind of setting.

Thanks
John
