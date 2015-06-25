Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33131 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbFYBpD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 21:45:03 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1Z7wDa-0002As-Uw by authid <merlin>
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 18:44:42 -0700
Date: Wed, 24 Jun 2015 18:44:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: 3.19.8: kernel BUG at fs/btrfs/extent_io.c:4548!
Message-ID: <20150625014442.GL20517@merlins.org>
References: <20150625013842.GK20517@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150625013842.GK20517@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 06:38:42PM -0700, Marc MERLIN wrote:
> Known already fixed problem, or not?
> 
> [680279.909435] kernel BUG at fs/btrfs/extent_io.c:4548!
> [680279.926208] invalid opcode: 0000 [#1] SMP

After reboot, I'm now seeing this if that helps:
[  272.826942] BTRFS info (device dm-1): bad tree block level 137
[  272.958006] BTRFS: read error corrected: ino 1 off 226779136 (dev /dev/mapper/dshelf1 sector 459312)
[  274.349430] BTRFS (device dm-1): parent transid verify failed on 229019648 wanted 99011 found 36
[  274.479700] BTRFS: read error corrected: ino 1 off 229019648 (dev /dev/mapper/dshelf1 sector 463688)
[  311.040191] BTRFS (device dm-1): parent transid verify failed on 229048320 wanted 99011 found 36
[  311.192380] BTRFS: read error corrected: ino 1 off 229048320 (dev /dev/mapper/dshelf1 sector 463744)
[  311.228687] BTRFS (device dm-1): parent transid verify failed on 229052416 wanted 99011 found 36
[  311.258980] BTRFS: read error corrected: ino 1 off 229052416 (dev /dev/mapper/dshelf1 sector 463752)
[  312.416949] BTRFS (device dm-1): parent transid verify failed on 229064704 wanted 99011 found 36
[  312.502828] BTRFS: read error corrected: ino 1 off 229064704 (dev /dev/mapper/dshelf1 sector 463776)
[  313.464054] BTRFS (device dm-1): parent transid verify failed on 229072896 wanted 99011 found 36
[  313.568913] BTRFS: read error corrected: ino 1 off 229072896 (dev /dev/mapper/dshelf1 sector 463792)
[  314.216027] BTRFS (device dm-1): parent transid verify failed on 229076992 wanted 99011 found 36
[  314.301930] BTRFS: read error corrected: ino 1 off 229076992 (dev /dev/mapper/dshelf1 sector 463800)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
