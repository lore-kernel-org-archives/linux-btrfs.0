Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33425 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbbEVWPO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 18:15:14 -0400
Received: by wgez8 with SMTP id z8so29389472wge.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 15:15:13 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 May 2015 00:15:13 +0200
Message-ID: <CAOQP4cGzX6knmXjaYcO=JB=VycidG7LS0GWA+N2x+f680ATGnA@mail.gmail.com>
Subject: Removing a device from a metadata raid1 - data raid0
From: Arnaud Kapp <kapp.arno@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've setup a filesystem with 2 devices. The metadata are in raid1.
Data is in raid0.

I wish to remove one of this device from the filesystem (to use for an
unrelated purpose) but I am not able to do so.
It *seems* that attempting to balance metadata to dup is not allowed
(btrfs -mconvert=dup) because they currently are raid1.
The metadata in raid1 prevents me from removing the device because the
filesystem can't go below one device in raid1.

Could someone please advise me about my options here?

Thank you,

-- 
Kapp Arnaud - Xaqq
