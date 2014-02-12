Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:41034 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBLVMQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 16:12:16 -0500
Message-ID: <52FBE3A3.6040205@libero.it>
Date: Wed, 12 Feb 2014 22:12:03 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Kostia Khlebopros <kkhlebopros@netgear.com>,
        Sandy McArthur <sandymac@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com> <CAPs0BigohtKrGW9MKGZzPrc_rUxkHDhtS-XcL-TzxEQgE-qZ4Q@mail.gmail.com> <C4D5B07324A04D4784C9F6D0FB2B0C336FFA9CA2@PERSES.netgear.com>
In-Reply-To: <C4D5B07324A04D4784C9F6D0FB2B0C336FFA9CA2@PERSES.netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kostia,

On 02/12/2014 04:09 AM, Kostia Khlebopros wrote:
> Any plans on having "brtfs fi df" report more precise values rather
> then rounded off to the nearest hundredth of a unit. full
> kilobytes(1024 bytes =1Kib) or in bytes would be nice> 
> Current output:
> 
> # btrfs fi df /data
> Data, single: total=1.37TiB, used=1.35TiB
> System, DUP: total=8.00MiB, used=192.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=3.00GiB, used=1.62GiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> Better would be:
> 
> # btrfs fi df /data
> Data, single: total=14123412341 bytes, used=1342343 bytes
> ...etc you know what I mean...
> 

My patches have a switch '-b' which set the units in byte. 

$ sudo ./btrfs fi df /
Disk size:		138.05GiB
Disk allocated:		 25.04GiB
Disk unallocated:	113.01GiB
Used:			 21.36GiB
Free (Estimated):	105.61GiB	(Max: 114.68GiB, min: 58.17GiB)
Data to disk ratio:	     92 %

$ sudo ./btrfs fi df -b /
Disk size:		      148229656576
Disk allocated:		       26881294336
Disk unallocated:	      121348362240
Used:			       22939594752
Free (Estimated):	      113402084997	(Max: 123134189568, min: 62460008448)
Data to disk ratio:	              92 %


> I wish there was more you know.
> 
> Kind Regards,
> 
> Kostia

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
