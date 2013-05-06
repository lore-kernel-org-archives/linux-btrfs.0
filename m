Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:45690 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab3EFGPf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 02:15:35 -0400
Message-ID: <51874A85.1050608@jan-o-sch.net>
Date: Mon, 06 May 2013 08:15:33 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient
 backups
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx>
In-Reply-To: <mjnh5a-mcf.ln1@hurikhan.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 05, 2013 at 12:07 (+0200), Kai Krakow wrote:
> I'm using an bash/rsync script[1] to backup my whole system on a nightly 
> basis to an attached USB3 drive into a scratch area, then take a snapshot of 
> this area. I'd like to have these snapshots immutable, so they should be 
> read-only.

Have you considered using btrfs send / receive for that purpose? You would just
save the dedup step.

-Jan
