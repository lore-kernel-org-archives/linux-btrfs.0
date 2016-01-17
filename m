Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [89.248.244.226] ([89.248.244.226]:36578 "EHLO mail.kolouch.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbcAQMlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 07:41:55 -0500
Received: from localhost (unknown [127.0.0.1])
	by mail.kolouch.org (Postfix) with ESMTP id 36047E2716D
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jan 2016 12:35:32 +0000 (UTC)
Received: from mail.kolouch.org ([127.0.0.1])
	by localhost (mail.kolouch.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HNGgODgwNFtx for <linux-btrfs@vger.kernel.org>;
	Sun, 17 Jan 2016 13:35:31 +0100 (CET)
Received: from localhost.localdomain (unknown [192.168.2.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kolouch.org (Postfix) with ESMTPSA id 40E1DE27168
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jan 2016 12:35:31 +0000 (UTC)
Date: Sun, 17 Jan 2016 13:35:29 +0100
From: Lubos Kolouch <kolcon@kolcon.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send - detect if complete
Message-ID: <20160117123529.GA26322@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am building a backup system, based on btrfs incremental send/receive.

I am a bit stuck on how to detect, if the transfer has been completed
(and not interrupted during transfer).

Host A :
du --max-depth=0 home_20160117
45787768  home_20160117

btrfs send home_20160117 | ssh dest_host "btrfs receive 
/mnt/destination/"

… transfer completes without any error

on dest_host:

du --max-depth=0 home_20160117
45763984  home_20160117

Ie. the size differs, perhaps due to different compression(?)

The volume seems OK, I can use it as a parent volume for further 
transfers etc.

The question is - is there a "btrfs native" way to tell, if the two
subvolumes are really identical (and the transfer was not interrupted 
etc.)?

Or do I have to resort to costly things like checksumming all files?

Thanks,

Lubos

