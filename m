Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:38860 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaBJWPE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 17:15:04 -0500
Message-ID: <52F94F5D.6000908@libero.it>
Date: Mon, 10 Feb 2014 23:14:53 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Josef Bacik <jbacik@fb.com>,
        "lin >> \"linux-btrfs@vger.kernel.org\""
	<linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com> <20140210170606.GK6490@carfax.org.uk>
In-Reply-To: <20140210170606.GK6490@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2014 06:06 PM, Hugo Mills wrote:
>    Biggest multiplier leads to the pessimistic estimate, which is what
> I'd prefer to see here, so that's good. Agree with this.

I would prefer to use as "raid multiplier" the ratio 

 total data block groups + total metadata block group
--------------------------------------------------------------
    disk space allocated for data and metdata block group

I hope that this would work better when we have a filesystem composed 
by small (inlined) files or when we will have per-subvolume RAID levels.

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
