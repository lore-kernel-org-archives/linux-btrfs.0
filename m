Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbcG1MDi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 08:03:38 -0400
Date: Thu, 28 Jul 2016 14:03:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@libero.it>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [BTRFS-PROGS][PATCH][V2] Add two new commands: 'btrfs insp
 physical-find' and 'btrfs insp physical-dump'
Message-ID: <20160728120318.GU30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469641398-3879-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 27, 2016 at 07:43:13PM +0200, Goffredo Baroncelli wrote:
> Hi all,
> 
> the following patches add two new commands: 
> 1) btrfs inspect-internal physical-find
> 2) btrfs inspect-internal physical-dump
> 
> The aim of these two new commands is to locate (1) and dump (2) the stripe elements
> stored on the disks. I developed these two new command to simplify the
> debugging of some RAID5 bugs (but this is another discussion).
[...]

Overall it looks good to me, I'll consider the series for 4.8 release
but I won't have time to review it closely in following weeks. Qu's
comments go in the same direction I'd comment so please address them in
the next patch iteration. Thanks.
