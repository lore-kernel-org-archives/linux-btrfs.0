Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:40590 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaBJW0t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 17:26:49 -0500
Message-ID: <52F95222.1010403@libero.it>
Date: Mon, 10 Feb 2014 23:26:42 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>,
        "lin >> \"linux-btrfs@vger.kernel.org\""
	<linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com>
In-Reply-To: <52F9014F.6070901@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2014 05:41 PM, Josef Bacik wrote:
> ===== New and improved btrfs fi df =====
> 
> Since people using this tool are already going to be better informed
> and since we are already given the block group flags we can go ahead
> and do the raid multiplier in btrfs-progs and spit out the adjusted
> numbers rather than the raw numbers we get from the ioctl.  This will
> just be a progs thing and that way we can possibly add an option to
> not apply the multipliers and just get the raw output.

In the past [1] I proposed the following approach.

$ sudo btrfs filesystem df /mnt/btrfs1/
Disk size:		 400.00GB
Disk allocated:		   8.04GB
Disk unallocated:	 391.97GB
Used:			  11.29MB
Free (Estimated):	 250.45GB	(Max: 396.99GB, min: 201.00GB)
Data to disk ratio:	     63 %

The space was given in terms of "disk space" and in terms of 
"filesystem space". Other that there is an indication of an estimation of
the free space, with the pessimistic and optimistic values.

[1] See "[PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support" 
dated 03/10/2013 01:17 PM

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
