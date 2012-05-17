Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:50426 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694Ab2ERGhu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 02:37:50 -0400
Date: Thu, 17 May 2012 20:31:20 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: "Sergey E. Kolesnikov" <rockingdemon@gmail.com>
Subject: Re: trim malfunction in linux 3.3.6
Message-ID: <20120517183120.GC24598@mother.jarsat.pl>
References: <4FB522EC.50305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <4FB522EC.50305@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 08:10:20PM +0400, Sergey E. Kolesnikov wrote:
> Hello.
> I've been running Ubuntu 12.04 kernel and btrfs on two partitions of
> two GPT partitioned SSDs. Rootfs was btrfs subvol "@" and homes were
> at "@home". When I was batch trimming with "fstrim /" using Ubuntu's
> standard kernel 3.2.0 - everything was fine. Then I compiled vanilla
> 3.3.6 kernel ad tried to fstrim again, fs got severely damaged.
> 
> It seems that batch trim miscalculates ranges and trims some
> occupied space. Can't say if GPT or other partitioning details
> matter.
 
  The issue was apparently fixed in 3.4-rc2:
http://lkml.indiana.edu/hypermail/linux/kernel/1204.1/00340.html

-- 
Tomasz Torcz                        To co nierealne -- tutaj jest normalne.
xmpp: zdzichubg@chrome.pl          Ziomale na ¿ycie maj± tu patenty specjalne.

