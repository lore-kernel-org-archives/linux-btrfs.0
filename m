Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33443 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2LFE42 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2012 23:56:28 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5937501oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2012 20:56:27 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 5 Dec 2012 23:56:27 -0500
Message-ID: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
Subject: Question about btrfs snapshot delay and rm -rf delay
From: Sylvain Alain <d2racing911@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone, I'm running btrfs since octobre 2012 and I would like to
understand 2 behavior that I noticed.

1. When I delete a big directory, sometimes it can hang my box for 1
minutes or so, it seems that's the btrfs lock my SSD.

2. Sometimes when I run btrfs subvolume snapshot @root @backup, it can
run the command in a split seconde, and sometimes the command can last
for about 3 minutes.

My SSD installation is about 3.1 gigs of data.

My main question is this : Is there any log about the btrfs filesystem
that I can look at to see why and what is going on.

I'm running the vanilla-souces 3.6.9. with btrfs-prog 0.20-rc1

For more detail about my box  :
https://gentooquebec.org/gwiki/index.php/Utilisateur:D2_racing

Thanks :P
