Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37075 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbbFPQnZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 12:43:25 -0400
Received: by wifx6 with SMTP id x6so25478282wif.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 09:43:23 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Jun 2015 18:43:23 +0200
Message-ID: <CAOQP4cG2344VZYT8eZ4=MJzi_KsdzH7pxFJ+ZpOTXtdDOrXRyQ@mail.gmail.com>
Subject: Replacing a drive from a RAID 1 array
From: Arnaud Kapp <kapp.arno@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Consider the following situation: I have a RAID 1 array with 4 drives.
I want to replace one the drive by a new one, with greater capacity.

However, let's say I only have 4 HDD slots so I cannot plug the new
drive, add it to the array then remove the other one.
If there a *safe* way to change drives in this situation? I'd bet that
booting with 3drives, adding the new one then removing the old, non
connected one would work. However, is there something that could go
wrong in this situation?

Thanks,

-- 
Kapp Arnaud - Xaqq
