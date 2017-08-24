Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48069 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752563AbdHXRUB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 13:20:01 -0400
Date: Thu, 24 Aug 2017 19:18:35 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: fix option handling for some commands
Message-ID: <20170824171835.GH2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 02:18:25PM +0900, Misono, Tomohiro wrote:
> I found some btrfs commands options are not working because of 
> inappropriate getopt_long() setting.
> 
> This fixes "btrfs check -Q/-E"
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Patches 1-3 and the doc fix applied with some changelog updates, thanks.
