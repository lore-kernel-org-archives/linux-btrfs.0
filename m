Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57080 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab3BPXKZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Feb 2013 18:10:25 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so1806717eaa.30
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2013 15:10:23 -0800 (PST)
Message-ID: <512012D6.7010403@statystyka.net>
Date: Sun, 17 Feb 2013 00:14:30 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How to clone btrfs partition?
References: <510E6714.7040206@statystyka.net> <510F0AE4.4070608@cn.fujitsu.com> <51200320.4010205@statystyka.net> <20130216221709.GK28997@carfax.org.uk>
In-Reply-To: <20130216221709.GK28997@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Welcome,

I need to clone btrfs partition. Not a single snapshot, but the whole 
lot of snapshots.

I thought that send & receive can help me. Can it? When I try to use

   btrfs send /mnt/btrfs-root >/dev/null
I get "ERROR: /mnt/adama-docs is not read-only.", and I was explained that I need to use snaphot (created with the "-r" switch).

So does it mean that I need to make a recursive search for each read&write subvolume on the file system in order to make a read-only snapshot, so I can clone the whole partition? Or is there a more simple approach?



-- 
Adam Ryczkowski
+48505919892
Skype:sisteczko

