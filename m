Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLQOcM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 09:32:12 -0500
Date: Wed, 17 Dec 2014 15:32:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] BUG: use metadata_profile instead of data_profile
Message-ID: <20141217143210.GA27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418472351-5113-1-git-send-email-kreijack@inwind.it>
 <1418472351-5113-2-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418472351-5113-2-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 13, 2014 at 01:05:51PM +0100, Goffredo Baroncelli wrote:
> The function test_num_disk_vs_raid() show an error message if
> the raid profile is incompatible with the number of devices.
> 
> Unfortunately when the error is related to data profile,
> the message print the metadata profile.

Already fixed by 373110d84f3a1c5bdd305d2e6dcaeb98b5e6dbe7.
