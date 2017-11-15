Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40555 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933200AbdKORFu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:05:50 -0500
Date: Wed, 15 Nov 2017 18:03:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] factor __btrfs_open_devices()
Message-ID: <20171115170355.GW28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171109154526.23181-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171109154526.23181-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 09, 2017 at 11:45:22PM +0800, Anand Jain wrote:
> This is in preparation to help bring the missing device back to the
> alloc list dynamically. As of now if we run 'btrfs dev scan </dev/missing>'
> on a mounted FS, nothing happens, there is no code which handles this
> condition. So the idea is to fix it by running through the device open
> process for the reappeared missing device.
> 
> So this patch separates device open steps into a separate function so that
> it can be called for a device, instead of for all the devices in the
> dev_list. As this function is in the critical mount section, and to show
> the src code changes as clearly as possible, I have created 4 no-functional
> changes patches, which can be merged together if needed.

The splitting is fine, I've only merged 2 and 4 to one, but otherwise
it's clear from each patch if there are no functional changes. 1,3,2+4
added to next, thanks.
