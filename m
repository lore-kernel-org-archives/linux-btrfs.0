Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbaHYP2J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 11:28:09 -0400
Date: Mon, 25 Aug 2014 17:28:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum
 mismatches even generation is less than 10.
Message-ID: <20140825152807.GI29981@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403599753-4072-1-git-send-email-quwenruo@cn.fujitsu.com>
 <53E2E9A3.6060206@cn.fujitsu.com>
 <53F3A9F7.9070709@fb.com>
 <53F4094D.2060606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F4094D.2060606@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 20, 2014 at 10:34:53AM +0800, Qu Wenruo wrote:
> Although as mentioned in the reply to David,
> the main problem is that I found two disk images with crazy values in
> superblock and wrong csum,
> but generation is still 4, and ignoring the csum error caused kernel BUG.

Can you please share the dump of the broken superblock
(btrfs-show-super)?  Thanks.
