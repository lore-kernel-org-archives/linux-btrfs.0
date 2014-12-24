Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:40820 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaLXQ4O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 11:56:14 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so7203289igb.17
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 08:56:13 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 24 Dec 2014 20:26:13 +0330
Message-ID: <CABvhJLgvP+sg57r8LrweLXDV48QMCqCLnveK3WLLKqrRSLDu6g@mail.gmail.com>
Subject: making btrfs on raw images
From: Ali AlipourR <alipoor90@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Do inserting images in loop device before using mkfs.btrfs on them is necessary?

I ask this because mkfs.btrfs gives warnings when I make btrfs on
images directly without inserting them into loop device, do this has
any drawbacks?


Thanks,
Ali
