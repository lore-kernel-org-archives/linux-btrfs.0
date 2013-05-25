Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38395 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab3EYL4J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 07:56:09 -0400
Received: from merkaba.localnet (ppp-93-104-137-191.dynamic.mnet-online.de [93.104.137.191])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 0D69DB9
	for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 13:55:55 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support ("N-way mirror code")
Date: Sat, 25 May 2013 13:56:08 +0200
Message-ID: <1570666.3pXJkQoCA4@merkaba>
In-Reply-To: <pan$d29fc$4ed9f39b$c95e9df6$a135bf3e@cox.net>
References: <518CFE3A.3080900@chinilu.com> <1823670.hMFQUu2mCu@merkaba> <pan$d29fc$4ed9f39b$c95e9df6$a135bf3e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 24. Mai 2013, 06:13:04 schrieb Duncan:
> > 2) Due to snapshots I know have well snapshots for my backup. And even
> > on SSD for my /home. I am not yet creating those in an automated way,
> > but well I do use them.
> 
> As I already mentioned the warning on the wiki, do be aware of the 
> limitations of snapshots.  They're NOT the same as separate backups.  I 
> believe you know that already and just didn't mention it, but I'm worried 
> about others who might come across your comment.

Well, a snapshot is not a backup. Just like a RAID is also not a backup.

:)

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
