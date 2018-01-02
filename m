Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37849 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbeABRRw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 12:17:52 -0500
Date: Tue, 2 Jan 2018 18:15:45 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: cleanup unnecessary string dup in
 btrfs_parse_options()
Message-ID: <20180102171545.GX3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0530ed22-f85e-ad17-58f3-9f4d147f8430@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0530ed22-f85e-ad17-58f3-9f4d147f8430@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 14, 2017 at 05:28:00PM +0900, Misono, Tomohiro wrote:
> Long ago, commit edf24abe51493 ("btrfs: sanity mount option parsing and
> early mount code") split the btrfs_parse_options() into two parts
> (btrfs_parse_early_options() and btrfs_parse_options()). As a result,
> btrfs_parse_optins no longer gets called twice and is the last one to parse
> mount option string. Therefore there is no need to dup it.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
