Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbCYMPQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 08:15:16 -0400
Date: Wed, 25 Mar 2015 13:15:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs test for incremental send with directory
 renames
Message-ID: <20150325121514.GF20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425157490-24776-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425157490-24776-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 28, 2015 at 09:04:50PM +0000, Filipe Manana wrote:
> Test for incremental send where the difference between the parent and
> child snapshots is that a directory A was renamed and a directory B was
> renamed to the name directory A had before (in the parent snapshot),
> but directory A's rename must happen before some other directory C is
> renamed.
> 
> This issue was fixed by the following linux kernel btrfs patch:
> 
>   Btrfs: incremental send, don't rename a directory too soon
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

and tested with 4.0-rc5
