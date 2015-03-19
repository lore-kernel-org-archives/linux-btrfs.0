Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbbCSS67 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 14:58:59 -0400
Date: Thu, 19 Mar 2015 19:58:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/26 v4] provide framework so that sysfs attributs from
 the fs_devices can be added
Message-ID: <20150319185858.GI20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 10, 2015 at 06:38:18AM +0800, Anand Jain wrote:
> This patch set will provide a framework and help to create attributes
> from the structure btrfs_fs_devices which are available even before
> fs_info is created. So by moving the parent kobject super_kobj from
> fs_info to btrfs_fs_devices, it will help to create attributes
> from the btrfs_fs_devices as well.

FYI, I'm going to test this patchset and prepare a pull for Chris if
everything goes fine.
