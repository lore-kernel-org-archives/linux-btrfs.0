Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41217 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751957AbeCNPiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:38:05 -0400
Date: Wed, 14 Mar 2018 16:35:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: check for SB checksum when scanned
Message-ID: <20180314153541.GJ32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180313150637.3913-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180313150637.3913-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 11:06:37PM +0800, Anand Jain wrote:
> We aren't checking the SB csum when the device scanned,
> instead we do that when mounting the device, and if the
> csum fails we fail the mount. How if we check the csum
> when the device is scanned, I can't see any reason for
> why not? any idea?

I think we should do some minimal checks of the sb also during scanning,
as btrfs_open_one_device accesses a few items from unchecked
'disk_super' directly. So at least magic number and checksum plus
validate the checksum type.
