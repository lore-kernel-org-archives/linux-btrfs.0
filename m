Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbbCWXiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 19:38:05 -0400
Date: Tue, 24 Mar 2015 00:38:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] btrfs-progs: qgroup related enhance.
Message-ID: <20150323233803.GP20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 27, 2015 at 04:26:32PM +0800, Qu Wenruo wrote:
> Qu Wenruo (7):
>   btrfs-progs: Update qgroup status flags and replace qgroup
>     level/subvid     calculation with inline function.
>   btrfs-progs: Allow btrfs-debug-tree to print human readable qgroup    
>     status flag.
>   btrfs-progs: Move parse_qgroupid() to utils.c
>   btrfs-progs: Allow parse_qgroupid() to resolve subvolume path into    
>     qgroupid.
>   btrfs-progs: Add stack get/set functions for btrfs_qgroup_status_item.
>   btrfs-progs: Print warning message if qgroup data is inconsistent.

All of the above merged.

>   btrfs-progs: Schedule quota rescan if qgroup assign caused    
>     inconsistence.

The rescan can be a long running operation and touches a lot of
metadata, so I'd rather avoid starting the rescan automatically. Right
now the user may start rescan manually, or please add an commandline
option (eg. --rescan) to do the rescan in one go with the 'assign'
command. Thanks.
