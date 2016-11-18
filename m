Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33864 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752174AbcKRMvf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 07:51:35 -0500
Received: by mail-wm0-f68.google.com with SMTP id g23so5936352wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 04:51:34 -0800 (PST)
Received: from ?IPv6:2001:620:600:6000:4988:8c9f:9b07:da45? ([2001:620:600:6000:4988:8c9f:9b07:da45])
        by smtp.gmail.com with ESMTPSA id h2sm8670666wjy.40.2016.11.18.04.51.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Nov 2016 04:51:32 -0800 (PST)
From: =?utf-8?Q?Heiri_M=C3=BCller?= <phlomos@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: BCache
Message-Id: <BBAB70CE-327F-47C1-B6BD-CD58FA11476A@gmail.com>
Date: Fri, 18 Nov 2016 13:51:32 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


I „BCache“ a BTrFS RAID with 4 hard drives.
Normal use seems to work good. I have no problems.
I have the BTrFS RAID mounted through „/dev/bcache3“.
But when I remove a disk (simulating it’s broken), BTrFS doesn’t inform me about a „missing disk“:

# btrfs fi show

Label: 'RAID'  uuid: d0e2e2eb-2df7-454f-8446-5213cec2de3c
	Total devices 4 FS bytes used 12.55GiB
	devid    1 size 465.76GiB used 6.00GiB path /dev/bcache3
	devid    2 size 931.51GiB used 6.00GiB path /dev/bcache1
	devid    3 size 596.17GiB used 6.00GiB path /dev/bcache2
	devid    4 size 465.76GiB used 6.00GiB path /dev/bcache0


One of these (actually „/dev/bcache3“ or „/dev/sde“) should be broken or missing.
I can’t make a „btrfs device delete missing“ either. It replies „ERROR: not a btrfs filesystem:“. It doesn’t matter, if I use „/dev/bcacheX“ or „/dev/sdX“ for that. And if I make a „btrfs device delete missing /mnt/raid“, it replies: „ERROR: error removing device 'missing': no missing devices found to remove“.
It looks to me, as if BCache hides these informations from BTrFS. Is this possible? What do you think?


Thanks

