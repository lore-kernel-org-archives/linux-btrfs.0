Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab3DPMP4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 08:15:56 -0400
Date: Tue, 16 Apr 2013 14:15:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/11 v2] a bunch of miscellaneous bug fixes
Message-ID: <20130416121554.GK18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Apr 15, 2013 at 02:38:06PM +0800, Anand Jain wrote:
> Anand Jain (11):
>   btrfs-progs: root_item generation_v2 is out of sync after btrfsck
>   btrfs-progs: no pending balance is not an error
>   btrfs-progs: mkfs should first check all disks before writing to a
>     disk
>   btrfs-progs: cmd replace should check target-dev fully
>   btrfs-progs: mkfs stdout print to match chronology
>   btrfs-progs: check if btrfs kernel module is loaded
>   btrfs-progs: delete unused function get_mountpt
>   btrfs-progs: btrfs-select-super output is confusing when it fails
>   btrfs-progs: fix btrfs scrub start help
>   btrfs-progs: avoid ioctl for multipath-dev with its non-multipath path
>   btrfs-progs: a copy of superblock is zero may not mean btrfs is not
>     there

I've merged some of the patches from this series, ones that apply
without dependencies (mostly the device scan rework which I'll process
next).  No need to resend patches that do not change, the easy ones get
merged and I'm trying to review the rest.

david
