Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaE1Qxg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 12:53:36 -0400
Date: Wed, 28 May 2014 18:53:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: provide better error message for raid
 profile mismatch
Message-ID: <20140528165333.GQ5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5375CA68.4090808@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5375CA68.4090808@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 16, 2014 at 05:20:56PM +0900, Hidetoshi Seto wrote:
> Current error messages are like following:
>   Error: unable to create FS with metadata profile 32 (have 2 devices)
>   Error: unable to create FS with metadata profile 256 (have 2 devices)
> 
> Obviously it is hard for users to interpret "profile XX" to proper
> meaning, such as "raidN". So use recongizable string instead of
> internal numerical value. In case of "dup", use an explicit message.
> 
> Plus this patch fix a bug that message mistake metadata profile
> for data profile.
> 
> After applying this patch, messages will be like:
>   Error: dup is not allowed when FS have multiple devices
>   Error: unable to create FS with metadata profile RAID6 (have 2
>   devices but 3 devices are required)

Nice, thanks.

Moving the group_profile_* functions to utils.c was done in "Enhance
the command btrfs filesystem df", so your patch ends up a bit shorter.

I've modified the 'dup' to be 'DUP' in the error message and changelog
so it's consistent with spelling of the RAIDx names.
