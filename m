Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zixgateway01.papersolve.com ([71.125.1.135]:21717 "EHLO
	sw-email.stardatecomputer.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753138AbaCGORj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 09:17:39 -0500
Received: from sw-email.stardatecomputer.com (127.0.0.1) id h37ag60171si for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 09:17:38 -0500 (envelope-from <mike@PaperSolve.com>)
From: Mike Russo <mike@PaperSolve.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: ENOSPC errors during raid1 rebalance
Date: Fri, 7 Mar 2014 14:17:37 +0000
Message-ID: <DF16C10AFF7F394A8C8A09C9405478890BCCC2EB@EXHOST.stardatecomputer.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
 <20140303183911.GL13899@carfax.org.uk>
 <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
 <73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com>
 <loom.20140305T190503-404@post.gmane.org>
 <pan$23ceb$3bedfe62$bfb976de$e16d8fde@cox.net>
 <loom.20140307T021006-737@post.gmane.org>
 <20140307080213.GC6318@carfax.org.uk>
In-Reply-To: <20140307080213.GC6318@carfax.org.uk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Hugo, that makes sense, and maybe leads to a possible way to fix the issue in future versions of btrfs-convert or a way to handle it in the balance code. 
What I did to find files with extents:

cd /mymedia
find . -type f -print0 | xargs -0 filefrag | grep -v 1\ extent | grep -v 0\ extent | awk -F: '{print $1}' > /tmp/extent
cat /tmp/extent | while read file; do mv -v "$file" /dev/shm; f2=`basename "$file"`; mv -v "/dev/shm/$f2" "$file"; done

I no longer care that even after doing this I still have a file with multiple extents, I just don't want them inside those block groups with >1GB extents. (BTW my terminology may be all off here, I just know that in my syslog btrfs tries to relocate two particular "block groups" and gets 2 enospc errors for them.)

But since I'm still getting the errors the files I care about probably aren't in this list so I'll do it for all the files on the system (since I can't find out what files are in those block groups).  


-----Original Message-----
From: Hugo Mills [mailto:hugo@carfax.org.uk] 
Sent: Friday, March 07, 2014 3:02 AM
To: Mike Russo
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during raid1 rebalance

   The defrag operation, by its nature, _doesn't_ preserve extents, and thus can act to break up the large extents, making it possible to balance the chunks that the offending extents live on.

   Hugo.

--
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- If the first-ever performance is the première,  is the ---     
                  last-ever performance the derrière?                   
