Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:50700 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaHXOJt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 10:09:49 -0400
Message-ID: <53F9F22B.4040109@floga.de>
Date: Sun, 24 Aug 2014 16:09:47 +0200
From: =?ISO-8859-1?Q?Florian_Gamb=F6ck?= <ml@floga.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: superblock checksum mismatch after crash, cannot mount
References: <53F7BD8E.10308@floga.de> <pan$a4556$243aa48a$bd2898a8$c2006893@cox.net> <53F85317.8060900@floga.de> <pan$16219$d960b649$52ed1e6$33540704@cox.net> <20140823163803.GA9149@hungrycats.org> <pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net> <20140824110853.GB22693@apia.perrit.net>
In-Reply-To: <20140824110853.GB22693@apia.perrit.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 24.08.2014 13:08, schrieb Leen Besselink:
> tip for basically any Linux filesystem, especially on Flash-based storage and also btrfs:
> - use noatime (if you aren't doing that already, don't know if that is the default in btrfs)

Yeah, I use this option per standard since I don't really need access times.

> How bad is it ? Well, look at this presentation:
>
> https://www.youtube.com/watch?v=CPEzLNh5YIo

Wow, this really surprised me. I never thought that SD cards are that 
unreliable. Maybe on my Pi I'll use the card only for booting from now 
on and move the system to an external hard drive ...
