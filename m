Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51365 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbF0OSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 10:18:16 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Send/Receive Use Case
Date: Sat, 27 Jun 2015 16:18:11 +0200
Message-ID: <2261769.FUJI4BnnUt@zafu>
In-Reply-To: <F2771637-3D78-4332-AB96-993069114030@up4.com>
References: <F2771637-3D78-4332-AB96-993069114030@up4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le samedi 27 juin 2015 10:04:28 Vincent Olivier a écrit :
> 
> There are 4 things I’m not sure about re:send/receive.
> 
> 1) Is it possible to first copy things on a file system using rsync and then
> use send-receive ?

NO. You need to start with a BTRFS snapshot send/receive to be able to 
continue with differential send/receives.

> And to subsequently mix rsync and send-receive ?

NOPE.

> 2) Is possible to “send" a snapshot diff to disk and then “receive" it from
> the said disk into a remote filesystem ?

YES.

> 3) How are “conflicts” handled by send-receive if at all ?

No way. Incremental send/receive are possible only if you have the exact 
(binary) (read-only) "parent" snapshot on both filesystems. There cannot be 
"conflicts" and incremental send/receive is not possible in any other 
situation.

> 4) If a file is created, modified and then deleted in-between two snapshots
> is it ignored by send/receive or does send/receive "re-enacts” the journal
> exactly ?

If anything is created/modified/deleted, the medatata being COW, will differ. 
Incremental send/receive, being the "binary diff" between filesystem states, 
will reflect this difference.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

