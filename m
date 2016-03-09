Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbcCIQeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 11:34:13 -0500
Date: Wed, 9 Mar 2016 17:33:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 13/13] btrfs: optimize check for stale device
Message-ID: <20160309163352.GI738@suse.cz>
Reply-To: dsterba@suse.cz
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-14-git-send-email-anand.jain@oracle.com>
 <20160218151348.GY4374@twin.jikos.cz>
 <56DFF2E6.4020300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56DFF2E6.4020300@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 05:54:47PM +0800, Anand Jain wrote:
> > the dereference happens at offset 0x68 which matches bdev in
> > btrfs_device, so this patch is my best guess at the moment. I'm not able
> > to reproduce it directly so I need to wait for a rebuild and repeat.
> 
> 
>   As of now,
>   There is nothing that tells me the above crash is due to this patch.

That was my suspicion but so far does not point to this patch.

>   By any chance were you running multiple instance of fstests ? If that's
>   possible ?

No, just a single instance.
