Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53532 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaGJSVb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 14:21:31 -0400
Received: by mail-qa0-f49.google.com with SMTP id dc16so1028990qab.8
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 11:21:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 Jul 2014 14:21:29 -0400
Message-ID: <CAMXuLLoeHPkX+Ym9a-HjVv=5ccqx9wo9tkbMLsySmgC=YJxgZQ@mail.gmail.com>
Subject: [Question] disk_bytenr with multiple devices
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a btrfs has multiple devices (e.g. /dev/sdb, /dev/sdc), how
should I interpret disk_bytenr in btrfs_file_extent_item?

Does it depend on the striping config? Say I used raid0, then
disk_bytenr 0~64K will be on /dev/sdb, and 64K~128K on /dev/sdc?

Thanks,
Zhe
