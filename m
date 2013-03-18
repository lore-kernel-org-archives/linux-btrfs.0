Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51839 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CRTSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 15:18:18 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B014C9A04E9
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 13:18:17 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Kyle <lists@lolwut.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <514759B5.5000507@lolwut.org>
In-Reply-To: <514759B5.5000507@lolwut.org>
Message-ID: <20130318191815.15073.49770@localhost.localdomain>
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
Date: Mon, 18 Mar 2013 15:18:15 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Kyle (2013-03-18 14:15:17)
> Hi,
> 
> After reading through the btrfs documentation I'm curious to know if 
> it's possible to ever securely erase a file from a btrfs filesystem (or 
> ZFS for that matter). On non-COW filesystems atop regular HDDs one can 
> simply overwrite the file with zeros or random data using dd or some 
> other tool and rest assured that the blocks which contained the 
> sensitive information have been wiped. However on btrfs it would seem 
> any such attempt would write the zeros/random data to a new location, 
> leaving the old blocks with the sensitive data intact. Further, since 
> specifying NOCOW is only possible for newly created files, there seems 
> to be no way to overwrite the appropriate blocks short of deleting the 
> associated file and then filling the entire free filesystem space with 
> zeros/random data such that the old blocks are eventually overwritten. 
> What's the verdict on this?

We don't do this now for other reasons mentioned in the thread.  The
best path to get here is to use trim, and to find a device that supports
a secure erase trim (I don't know if this even exists, sorry).

Outside of that, the only way to do this securely is to delete the
files, rotate in new drives, rotate out the old drives, and run a full
drive secure delete (not very practical).

-chris
