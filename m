Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbbHER33 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 13:29:29 -0400
Date: Wed, 5 Aug 2015 19:29:08 +0200
From: David Sterba <dsterba@suse.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/6] sysfs-part2 Add seed device representation on the
 sysfs
Message-ID: <20150805172908.GI31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 08, 2015 at 03:32:48PM +0800, Anand Jain wrote:
> This patch adds the support to show seed device on the btrfs sysfs.
> This is a revamped version of the previously single patch 6/6, and plus
> incorporates David suggestion to add seed fsid under the 'seed' kobject.
> 
> Since this adds new patches and to bring in seed kobject it needed
> quite a lot of revamp I am resetting the patch set version to 1.
> 
> Anand Jain (6):
>   Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
>   Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
>   Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
>   Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
>   Btrfs: rename super_kobj to fsid_kobj
>   Btrfs: sysfs: support seed devices in the sysfs layout

Sorry for late reply, the patches look good. I'm going to prepare a
branch for pull into 4.3. Thanks.
