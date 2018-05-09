Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48575 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934303AbeEILpL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 07:45:11 -0400
Date: Wed, 9 May 2018 13:42:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] btrfs-progs: Some fix for fi usage
Message-ID: <20180509114232.GS6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 05:21:29PM +0900, Misono Tomohiro wrote:
> v1->v2
>   These were sent several months ago, just rebased to current devel branch.
> 
> Patch 1 and 2 aims to fix the "fi du" to include the information of "fi df"
> even when running without root privilege.
> 
> Patch 3 is an independent cleanup.
> 
> Tomohiro Misono (3):
>   btrfs-progs: fi usage: change warning message more appropriately
>   btrfs-progs: fi usage: change to output more info without root privilege
>   btrfs-progs: fi usage: cleanup unnecessary permission error check

1-2 applied, thanks.
