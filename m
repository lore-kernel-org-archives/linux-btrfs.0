Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaACRNK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 12:13:10 -0500
Date: Fri, 3 Jan 2014 18:13:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de
Subject: Re: [PATCH v2 03/11] btrfs: Add nocheck_int mount option.
Message-ID: <20140103171308.GQ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1388729434-19799-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388729434-19799-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 02:10:26PM +0800, Qu Wenruo wrote:
> Add nocheck_int mount option to disable integrity check with
> remount option.
> 
> +	nocheck_int disables all the debug options above.

I think this option is not needed, the integrity checker is a
deveoplment functionality and used by people who know what they're
doing. Besides this would need to clean up all the data structures that
the checker uses (see eg. btrfsic_unmount that's called only if the
mount option is used). I see little benefit compared to the amount of
work to make sure that disabling the checker functionality in the middle
works properly.

david
