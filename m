Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:56387 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbbDJB0D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 21:26:03 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 63E70EC4B
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2015 11:26:00 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: du accuracy
Date: Fri, 10 Apr 2015 11:25:57 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201504101125.58088.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm copying an image of a 2G microSD card to a BTRFS filesystem.  The SD card 
is from an Android phone and is almost full of Android packages and photos, 
there's very little space on the filesystem and what space there is probably 
isn't filled with zeros.

# ls -l
total 888000
-rw-r--r--. 1 root root 1043529728 Apr 10 11:20 2gsd

While doing it I run ls commands to see the progress and get output like the 
above.  Why is the file size according to ls not matching the total used?

# du -h
886M    .

When I ran du immediately afterwards it also reported that there was less than 
1G used.

# du -h
1.2G    .
# du -h
1.2G    .
# du -h
1.1G    .
# du -h
1.1G    .
# du -h
1.1G    .
# du -h
1.2G    .
# du -h
1.2G    .

Above are some consecutive du runs.  Why does the space used go from 1.2G to 
1.1G before going up again?  The file was created by "cat /dev/sde > 2gsd" so 
it definitely wasn't getting smaller.

What's going on here?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
