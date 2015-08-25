Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36523 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbbHYNZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 09:25:26 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empty directory pretending it is not empty
Date: Tue, 25 Aug 2015 15:25:12 +0200
Message-ID: <1474026.LQOmDW8fG5@tethys>
In-Reply-To: <pan$d4557$9c42de4e$12e74017$2f692aea@cox.net>
References: <2017000.AEG9PyVY17@zafu> <4755396.RFUxGNmK6p@tethys> <pan$d4557$9c42de4e$12e74017$2f692aea@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le mardi 25 août 2015 08:37:46 vous avez écrit :
> The errors 200 flags are reasonably common, and I believe
> btrfs check --repair handles them well.

Uh, I've started it hours ago, and it has been eating 100% CPU on one of my 
cores since, without apparently yet finding a single error. It seems that 
without the --repair flag, btrfs check goes relatively fast, but with this 
flag (and even on an half-full 500GB SSD), it seems to take forever.

I've started it (just for checking) on another machine which FS looked clean 
in use, and on this other machine it has displayed that it was correcting a 
huge number of apparently more serious errors. However on this 2nd machine as 
well, it's taking houuuuurs...

> I already stressed the admin rule that no backups means you don't care if
> it's lost

I'm a white-haired long-beared sysadmin. Nobody ever had more backups than I 
do ;-))) -- which tends to show that I care about my data. However restoring a 
complete machine with complex filesystems and snapshots remains a tedious 
process...

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

