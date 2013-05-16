Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60878 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3EPPk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 11:40:28 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1Uczny-0000KB-BW
	for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2013 08:09:18 -0700
Date: Thu, 16 May 2013 08:09:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: kernel 3.8.8: btrfs still crashes on boot when it can't replay a log
Message-ID: <20130516150918.GB26762@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've reported this bug a few times over different kernel versions over the
last year now, and unfortunately it's still not fixed as of 3.8 (yes, I know
3.9 is out, I'm just about to switch).

What happens as far as I know:
I have btrfs on top of dmcrypt on an SDD.

The SSD on occasion seems to just hang, so I have to power cycle my laptop.
I can't say how much the SSD did and did not write before stopping to work.

Then, maybe one time out of 2 or 3, btrfs crashes when I reboot and it tries 
to replay the log.

I'm then forced to do this from emergency boot media:

gandalfthegreat:~# btrfs-zero-log /dev/mapper/root                                                        
Check tree block failed, want=64855564288, have=14954667565421255623                                      
Check tree block failed, want=64855564288, have=14954667565421255623                                      
Check tree block failed, want=64855564288, have=7474503720151340134                                       
Check tree block failed, want=64855564288, have=14954667565421255623                                      
Check tree block failed, want=64855564288, have=14954667565421255623                                      
read block failed check_tree_block   

The last bits of the crash before I zero the log:
http://marc.merlins.org/tmp/btrfs-3.8.8.jpg

Still issues with btrfs_numb_copies.

This has been going on for over a year now, not very pleasant :)

Is there no way you can corrupt logs in a test lab and reproduce this?

Or is it still known to happen due to missing code that decides whether a log is corrupt 
and whether to discard it before the code reads it and crashes?

If so, could you add this to the list of things to fix to make btrfs a bit
less scary to others? :)
(and of course more production ready, this repeated problem would kill any
server it happens on)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
