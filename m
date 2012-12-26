Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:49018 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2LZNi4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Dec 2012 08:38:56 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20121226133855.FQPP2891.eastrmfepo101.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 26 Dec 2012 08:38:55 -0500
Message-ID: <50DAFDEE.3030204@czarc.net>
Date: Wed, 26 Dec 2012 08:38:54 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Determining subvolumes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I know that I can find out what btrfs "volumes" are on a system with the 
command:
      btrfs  fi  show

I can also check if a partition of disk is a btrfs volume with the command:
      blkid  -o value -s TYPE /dev/<disk|partition>

And, if I mount that btrfs volume with something like:
      mount -t btrfs /dev/<btrfs>  /mnt/btrfs

The, I can get a list of btrfs subvolumes on that volume with the command:
      btrfs  subvolume  list  /mnt/btrfs

My question:  Is there a way of finding out what subvolumes are defined 
on a btrfs volume without mounting the volume?

Gene
