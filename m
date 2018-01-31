Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38037 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752337AbeAaPXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 10:23:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DCDB9AD93
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 15:23:05 +0000 (UTC)
Date: Wed, 31 Jan 2018 16:20:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 1/2] btrfs: Refactor __get_raid_index() to
 btrfs_bg_flags_to_raid_index()
Message-ID: <20180131152054.GD18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180130102046.10586-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180130102046.10586-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 06:20:45PM +0800, Qu Wenruo wrote:
> Function __get_raid_index() is used to convert block group flags into
> raid index, which can be used to get various info directly from
> btrfs_raid_array[].
> 
> Refactor this function a little:
> 
> 1) Rename to btrfs_bg_flags_to_raid_index()
>    Double underline prefix is normally for internal functions, while the
>    function is used by both extent-tree and volumes.
> 
>    Although the name is a little longer, but it should explain its usage
>    quite well.
> 
> 2) Move it to volumes.h and make it static inline
>    Just several if-else branches, really no need to define it as a normal
>    function.
> 
>    This also makes later code re-use between kernel and btrfs-progs
>    easier.
> 
> 3) Remove function get_block_group_index()
>    Really no need to do such a simple thing as an exported function.

Agreed on this kind of cleanups. Patches added to next, thanks.
