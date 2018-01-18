Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44433 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932066AbeARPRT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 10:17:19 -0500
Date: Thu, 18 Jan 2018 16:15:08 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 2/2] btrfs: remove unused arg from parse_subvol_options()
Message-ID: <20180118151508.GM13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
 <557567d8-1557-389b-81b6-bb269c147320@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557567d8-1557-389b-81b6-bb269c147320@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 17, 2018 at 05:38:31PM +0900, Misono, Tomohiro wrote:
> Remove unused arg 'holder' from parse_subvol_options(), which has been
> forgotten to be cleaned in the commit b99beb110e2d ("btrfs: split
> parse_early_options() in two").
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Thanks, added to the rest of mount patches.
