Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730869AbeHGSzE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 14:55:04 -0400
Date: Tue, 7 Aug 2018 18:39:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] undelete subvolume online version
Message-ID: <20180807163950.GP3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 05, 2018 at 06:39:57PM +0800, Lu Fengqi wrote:
> This patchset will add the BTRFS_IOC_SUBVOL_UNDELETE ioctl for online
> btrfs subvolume undelete.
> 
> And btrfs subvolume undelete subcommand was added to btrfs-progs.
> 
> So user can use the following command to recover all the subolume that
> is left on the device. The recovered subvolume will be link to <dest> dir
> named to <name_prefix><subvol_id>.

Hm, I don't agree with the proposed interface - to recover all deleted
subvolumes. IMO this should recover just one subvolume of a given id a
to given directory.

The ioctl structure has to be reworked, I've skimmed the code and saw
some suspicious things but will have a look after the interface is
settled.
