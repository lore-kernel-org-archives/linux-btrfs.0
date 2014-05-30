Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51246 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbaE3N11 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 09:27:27 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 9A703206E3
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 23:27:23 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: optimising metadata location
Date: Fri, 30 May 2014 23:27:17 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201405302327.18068.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am I correct in believing that BTRFS has no support for locating metadata near 
the data it refers to?  The way it allocates 256M chunks for metadata and 1G 
chunks for data seems to work against the possibility of locating metadata 
near the data it refers to.

If this is correct then would it be possible to pre-allocate metadata chunks 
on the fastest sections of the disk?  On most disks the lower sector numbers 
correspond to the outer tracks which have the fastest contiguous IO rates and 
also should give shorter seek times (as seeking accross a given amount of data 
would involve a shorter head movement).

One example of where this could really help is mail servers.  For email that I 
personally receive the average file size of the message files in Maildir 
format is 22K for messages I've received in the last year.  For a mail server 
that I run for a client the average size of stored mail is about 92K.

When the average size is 22K it seems that with compression most files will 
fit in metadata when they are compressed and the filesystem has a 16K leaf 
size (note that the average size would be a lot larger than the median size 
due to the presence of a small number of very large messages).

Even for the server with an average size of 92K there will still be a good 
portion of the stored mail that would fit in a 16K leaf and the metadata 
operations for Maildir servers are intensive (lots of file renames).  So 
having this on the fastest part of the disk would be a good thing.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
