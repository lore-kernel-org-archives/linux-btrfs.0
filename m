Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbbJGJJH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 05:09:07 -0400
Date: Wed, 7 Oct 2015 11:08:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] Btrfs: optimize check for stale device
Message-ID: <20151007090801.GE7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444035437-9442-1-git-send-email-anand.jain@oracle.com>
 <5614DEF7.3050202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5614DEF7.3050202@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 07, 2015 at 04:59:35PM +0800, Anand Jain wrote:
> > @@ -620,7 +620,8 @@ static noinline int device_list_add(const char *path,
> >   	 * if there is new btrfs on an already registered device,
> >   	 * then remove the stale device entry.
> >   	 */
> > -	btrfs_free_stale_device(device);
> > +	if (ret > 0)
> > +		btrfs_free_stale_device(device);
> >
> >   	*fs_devices_ret = fs_devices;
> 
>   I have to withdraw this. The ret is 0 when there is new fsid on a
>   previously known device that means we need to clear the stale. v.sorry.

Ah, right.
