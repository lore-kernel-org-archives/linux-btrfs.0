Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389081AbeHAOko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 10:40:44 -0400
Date: Wed, 1 Aug 2018 14:55:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: backref.c: Use ERR_CAST() to return error code
Message-ID: <20180801125501.GC3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1532568195.git.misono.tomohiro@jp.fujitsu.com>
 <936a6171-4c1e-2bda-af79-9be9ebe6a8fd@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <936a6171-4c1e-2bda-af79-9be9ebe6a8fd@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2018 at 10:22:58AM +0900, Misono Tomohiro wrote:
> Use ERR_CAST() instead of void * to make meaning clear.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Added to misc-next, thanks.
