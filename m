Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc1-s5.bay0.hotmail.com ([65.54.190.16]:21503 "EHLO
	bay0-omc1-s5.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794Ab3EIUrh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 May 2013 16:47:37 -0400
Message-ID: <BAY172-DS142AB5E40D200CC3946388B0A40@phx.gbl>
From: "Kyle Gates" <kylegates@hotmail.com>
To: <linux-btrfs@vger.kernel.org>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com>
In-Reply-To: <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com>
Subject: nocow 'C' flag ignored after balance
Date: Thu, 9 May 2013 15:41:49 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll preface that I'm running Ubuntu 13.04 with the standard 3.8 series 
kernel so please disregard if this has been fixed in higher versions. This 
is on a btrfs RAID1 with 3 then 4 disks.

My use case is to set the nocow 'C' flag on a directory and copy in some 
files, then make lots of writes (same file sizes) and note that the number 
of extents stays the same, good.
Then run a balance (I added a disk) and start making writes again, now the 
number of extents starts climbing, boo.
Is this standard behavior? I realize a balance will cow the files. Are they 
also being checksummed thereby breaking the nocow flag?

I have made no snapshots and made no writes to said files while the balance 
was running.

Thanks,
Kyle 

