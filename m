Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56645 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaLRPCg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 10:02:36 -0500
Received: by mail-lb0-f180.google.com with SMTP id l4so1088377lbv.39
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 07:02:35 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 18 Dec 2014 23:02:34 +0800
Message-ID: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
Subject: Extra info
From: Daniele Testa <daniele.testa@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, did not read the guidelines correctly. Here comes more info:

root@s4 /opt/drives/ssd # uname -a
Linux s4.podnix.com 3.2.0-4-amd64 #1 SMP Debian 3.2.46-1+deb7u1 x86_64 GNU/Linux

root@s4 /opt/drives/ssd # btrfs --version
Btrfs Btrfs v0.19

root@s4 /opt/drives/ssd # btrfs fi show
Label: none  uuid: 752ed11b-defc-4717-b4c9-a9e08ad64ba6
        Total devices 1 FS bytes used 404.74GB
        devid    1 size 410.50GB used 410.50GB path /dev/md3

Regards,
Daniele
