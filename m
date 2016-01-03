Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35804 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbcACQY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 11:24:57 -0500
Received: from merkaba.localnet (host-188-174-217-67.customer.m-online.net [188.174.217.67])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id AEF0B274
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Jan 2016 17:24:55 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unrecoverable fs corruption?
Date: Sun, 03 Jan 2016 17:24:55 +0100
Message-ID: <3682129.ZmNZ4hatg3@merkaba>
In-Reply-To: <pan$11cfd$9e78008a$67e09cd4$7017ff54@cox.net>
References: <pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net> <CAPmG0jb1HF6Mnfi3ObqUfPHs4RNLCDvsnuncvX-=LGZazDHnYg@mail.gmail.com> <pan$11cfd$9e78008a$67e09cd4$7017ff54@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 3. Januar 2016, 15:53:56 CET schrieben Sie:
> [1] Fat-fingering a deletion:  My own brown-bag "I became an admin that 
> day" case was running a script, unfortunately as root, that I was 
> debugging, where I did an rm -rf $somevar/*, with $somevar assigned 
> earlier, only either the somevar in the assignment or the somevar in the 
> rm line was typoed, so the var ended up empty and the command ended up as 
> rm -rf /*. ...
> 
> I was *SO* glad I had a backup, not just a raid1, that day!

Epic.

Thats the one case GNU rm doesn´t cover yet.

It refuses to rm -rf . or rm -rf .. and rm -rf / (unless you give special 
argument, but there is not much it can do about rm -r /*, as the shell expands 
this before handing it to the command.

Thanks,
-- 
Martin
