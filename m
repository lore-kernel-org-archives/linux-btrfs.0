Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbcCKLXM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 06:23:12 -0500
Date: Fri, 11 Mar 2016 12:22:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Fix device scan to interpret its argument
 properly
Message-ID: <20160311112250.GO18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E210A5.8030100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E210A5.8030100@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 11, 2016 at 09:26:13AM +0900, Satoru Takeuchi wrote:
> Fix the following bug.
> 
>   ================================
>   # btrfs device scan -- /dev/sdb
>   ERROR: not a block device: --
>   ================================
> 
> It should work as follow.
> 
>   ================================
>   # ./btrfs device scan -- /dev/sdb
>   Scanning for Btrfs filesystems in '/dev/sdb'
>   ================================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, thanks.
