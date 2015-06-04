Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33158 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbbFDImt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 04:42:49 -0400
Date: Thu, 4 Jun 2015 17:42:45 +0900
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: counting fragments takes more time than defragmenting
Message-ID: <20150604084245.GR23272@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

After our quick chat, I gave it a shot on 3.19.6, and things are better
than last time I tried.

legolas:/var/local/nobck/VirtualBox VMs# lsattr Win7/
---------------C Win7/Logs
---------------C Win7/Snapshots
---------------C Win7/Win7.vdi
---------------C Win7/Win7.png
---------------C Win7/autotune1.png
---------------C Win7/new_autotune2.png
---------------C Win7/Win7.vbox-prev
---------------C Win7/Win7.vbox

But I have snapshots of that subvolume, so obviously that gets
in the way of disabling COW.

I had a look, and I have 100K fragments. That took 10mn to figure out:

legolas:/var/local/nobck/VirtualBox VMs/Win7# filefrag Win7.vdi
Win7.vdi: 104306 extents found

This first filefrag run took about 10mn to count all the fragments on my
SSD. That feels a bit slow, but maybe the userland tool is doing things
in suboptimal ways.

Defrag actually worked (mostly) and wasn't too slow. It used to take hours
not to finish, and now it worked in 3mn:
legolas:/var/local/nobck/VirtualBox VMs/Win7# time btrfs fi defrag Win7.vdi 
real	3m43.807s
user	0m0.000s
sys	0m44.044s

This is defintely better than before.
Note that it's not fully defragged, but close enough. Each subsequent
run, filefrag is faster, and defrag is still faster than filefrag:

legolas:/var/local/nobck/VirtualBox VMs/Win7# time filefrag Win7.vdi
Win7.vdi: 11428 extents found
real	2m42.090s
user	0m0.000s
sys	2m37.308s

legolas:/var/local/nobck/VirtualBox VMs/Win7# time btrfs fi defrag Win7.vdi 
real	0m7.483s
user	0m0.000s
sys	0m2.672s

legolas:/var/local/nobck/VirtualBox VMs/Win7# time filefrag Win7.vdi
Win7.vdi: 11132 extents found
real	0m22.525s
user	0m0.000s
sys	0m22.264s

It's a bit unexpected that I still have 10k fragments after 2 defrag
runs, but it's better than 100k :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
