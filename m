Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57997 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbaJXMsV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 08:48:21 -0400
Date: Fri, 24 Oct 2014 04:49:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Heavy nocow'd VM image fragmentation
Message-ID: <20141024114916.GI12554@merlins.org>
References: <5449898B.4090708@nuclearwinter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5449898B.4090708@nuclearwinter.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 23, 2014 at 06:04:43PM -0500, Larkin Lowrey wrote:
> I have a 240GB VirtualBox vdi image that is showing heavy fragmentation
> (filefrag). The file was created in a dir that was chattr +C'd, the file
> was created via fallocate and the contents of the orignal image were
> copied into the file via dd. I verified that the image was +C.
> 
> After initial creation there were about 2800 fragments, according to
> filefrag. That doesn't surprise me because this image took up about 60%
> of the free space. After an hour of light use the filefrag count was the
> same. But, after a day of heavy use, the count is now well over 600,000.
> 
> There were no snapshots during the period of use. The fs does not have
> compression enabled. These usual suspects don't apply in my case.
> 

To be honest, I have the same problem, and it's vexing:
legolas:/var/local/nobck/VirtualBox VMs/Win7# lsattr *
---------------C Logs/VBox.log.3
---------------C Logs/VBox.log.2
---------------C Logs/VBox.log.1
---------------C Logs/VBox.log
---------------C Snapshots/2014-10-24T04-37-46-247921000Z.sav
---------------C Win7.png
---------------C Win7.vbox
---------------C Win7.vbox-prev
---------------C Win7.vdi
legolas:/var/local/nobck/VirtualBox VMs/Win7# filefrag Win7.vdi
Win7.vdi: 169130 extents found

Note that I already copied this file recently to lay it out properly
but apparently it fragments again despite NOCOW.
On the plus side, at least btrfs send works again, before my last copy
of it setting it to NOCOW, btrfs send of that filesystem was taking 12H+
instead of minutes.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
