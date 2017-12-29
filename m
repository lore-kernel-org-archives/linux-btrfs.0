Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:45653 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdL2QdP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 11:33:15 -0500
Received: from h06.hostsharing.net (h06.hostsharing.net [83.223.95.25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 15F381032A75F
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:33:14 +0100 (CET)
Received: from mail.home.lxtec.de (HSI-KBW-5-56-176-248.hsi16.kabel-badenwuerttemberg.de [5.56.176.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h06.hostsharing.net (Postfix) with ESMTPSA id C32616173A28
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:33:13 +0100 (CET)
Received: from localhost ([127.0.0.1])
        by mail.home.lxtec.de with esmtp (Exim 4.90_RC4 4 (LXTEC))
        id 1eUxar-0000v1-1K
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:33:13 +0100
Received: from mail.home.lxtec.de ([127.0.0.1])
        by localhost (baumbart.home.lxtec.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X4ZxA1FKRCWq for <linux-btrfs@vger.kernel.org>;
        Fri, 29 Dec 2017 17:33:12 +0100 (CET)
Received: from galadriel.home.lxtec.de ([192.168.200.207])
        by mail.home.lxtec.de with smtp (Exim 4.90_RC4 4 (LXTEC))
        id 1eUxaq-0000uv-OZ
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:33:12 +0100
Date: Fri, 29 Dec 2017 17:33:12 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: linux-btrfs@vger.kernel.org
Subject: WARNING: CPU: 1 PID: 3016 at fs/btrfs/ctree.h:1564
 btrfs_update_device+0x189/0x190 [btrfs]
Message-ID: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I get warnings as seen in attached dmesg.log. This is on 4.14.9.
4.9.72 runs flawless so far.

##########
Linux toy 4.14.9-toy-lxtec-amd64 #7 SMP Fri Dec 29 10:43:28 CET 2017 x86_64 GNU/Linux
--
btrfs-progs v4.13.3
--
Label: 'TOY-RAID1'  uuid: 32fc4ea0-0b26-478c-9b2e-b299d6289270
	Total devices 2 FS bytes used 560.98GiB
	devid    1 size 3.62TiB used 566.03GiB path /dev/sda3
	devid    2 size 3.62TiB used 566.03GiB path /dev/sdb3
--
Data, RAID1: total=563.00GiB, used=559.43GiB
System, RAID1: total=32.00MiB, used=96.00KiB
Metadata, RAID1: total=3.00GiB, used=1.55GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
#########

I want to run this machine as a 24/7 server with the latest
LT-KERNEL. So please investigate.

Many thanks in advance
Elimar
-- 
  355/113: Not the famous irrational number pi,
           but an incredible simulation!
	                -unknown
