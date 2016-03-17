Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934742AbcCQOUM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 10:20:12 -0400
Date: Thu, 17 Mar 2016 15:19:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: subvolume functions reorg
Message-ID: <20160317141945.GU21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458137673-464-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458137673-464-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 10:14:33PM +0800, Anand Jain wrote:
> Makes few subvol related functions usable outside of subvol
> command set.
> 
> This is a preparatory patch for encryption support. The changes
> here are:
> 
> Created new file subvolume.c
> Created btrfs_get_subvol_info() from parts of cmd_subvol_show()
> Moved get_subvol_name() to subvolume.c
> Moved test_issubvolume() to subvolume.c
> Created subvolume.h to define the above functions.

Such helpers are in utils.[ch], eg. there's test_issubvolname.
get_subvol_name could be renamed,
factoring btrfs_get_subvol_info looks good.

So far the internal interfaces are not tidy, so everything goes to
utils. It should be easier for you if you need to do some code
rearrangements.
