Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:33958 "EHLO
        cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732373AbeHWSOp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 14:14:45 -0400
Received: from cc-smtpin1.netcologne.de (cc-smtpin1.netcologne.de [89.1.8.201])
        by cc-smtpout2.netcologne.de (Postfix) with ESMTP id 26A9F129E1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:44:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by cc-smtpin1.netcologne.de (Postfix) with ESMTP id 2399011EC4
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:44:42 +0200 (CEST)
Received: from [209.85.213.45] (helo=cc-smtpin1.netcologne.de)
        by localhost with ESMTP (eXpurgate 4.6.0)
        (envelope-from <s.schumacher@netcologne.de>)
        id 5b7ec85a-5f8a-7f0000012729-7f000001df40-1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:44:42 +0200
Received: from mail-vk0-f45.google.com (mail-vk0-f45.google.com [209.85.213.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by cc-smtpin1.netcologne.de (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:44:41 +0200 (CEST)
Received: by mail-vk0-f45.google.com with SMTP id b78-v6so2703684vka.12
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 07:44:41 -0700 (PDT)
MIME-Version: 1.0
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Date: Thu, 23 Aug 2018 16:44:40 +0200
Message-ID: <CAA3ktq=N-k+it4jJDxJ8-mZXwdbu1pEGRcaJLZcCFcqHrMWjtg@mail.gmail.com>
Subject: Device Delete Stalls - Addition
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

I think this might be useful:

root@mars:~# btrfs dev usage /mnt/btrfs-raid/
/dev/sda, ID: 1
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID1:              7.00GiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             3.63TiB

Yours sincerely
Stefan
