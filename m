Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48203 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbA3QlM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 11:41:12 -0500
Received: by mail-we0-f172.google.com with SMTP id q59so28119347wes.3
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2015 08:41:11 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 30 Jan 2015 16:41:11 +0000
Message-ID: <CAO5K3OefHFj6sQx9ZwNcDJWWTTaRf62U4eDp0Gxyf+kFk4Wyew@mail.gmail.com>
Subject: rolling back to ext4 doesn't work if rebalanced
From: Vytautas D <vytdau@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it possible to automate btrfs-convert so that it would defrag and
balance the disk without loosing ability to roll back to ext4
partition ?

i.e:
btrfs-convert /dev/sda3
# I can still rollback using btrfs-convert -r /dev/sda3

btrfs filesystem defrag -r /
# I can still rollback using btrfs-convert -r /dev/sda3

btrfs balance start /
# I can no longer rollback to ext4

-Vytas

P.S.
btrfs version
Btrfs v3.17
