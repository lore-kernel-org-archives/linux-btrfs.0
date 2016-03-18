Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbcCRNcD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 09:32:03 -0400
Date: Fri, 18 Mar 2016 14:31:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: subvolume functions reorg
Message-ID: <20160318133136.GY21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458137673-464-1-git-send-email-anand.jain@oracle.com>
 <20160317141945.GU21722@twin.jikos.cz>
 <56EBC240.40306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56EBC240.40306@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2016 at 04:54:24PM +0800, Anand Jain wrote:
> 
> 
> On 03/17/2016 10:19 PM, David Sterba wrote:
> > On Wed, Mar 16, 2016 at 10:14:33PM +0800, Anand Jain wrote:
> >> Makes few subvol related functions usable outside of subvol
> >> command set.
> >>
> >> This is a preparatory patch for encryption support. The changes
> >> here are:
> >>
> >> Created new file subvolume.c
> >> Created btrfs_get_subvol_info() from parts of cmd_subvol_show()
> >> Moved get_subvol_name() to subvolume.c
> >> Moved test_issubvolume() to subvolume.c
> >> Created subvolume.h to define the above functions.
> >
> > Such helpers are in utils.[ch], eg. there's test_issubvolname.
> 
>   You meant to move them/it to subvolume.c/h right ?

No, please keep using utils.[ch] for now.
