Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3CTPlJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 11:41:09 -0400
Date: Wed, 20 Mar 2013 16:41:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Carey Underwood <carey@scaletech.ca>
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com, idryomov@gmail.com,
        cwillu@cwillu.com
Subject: Re: [RFC][PATCH] Btrfs: Release uuid_mutex for shrink during device
 delete
Message-ID: <20130320154105.GA31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362436626.26135.16.camel@applicati>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362436626.26135.16.camel@applicati>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 04, 2013 at 04:37:06PM -0600, Carey Underwood wrote:
> Device scanning waits on the uuid_mutex, which can result in a very long
> wait if dev delete is shrinking the device.
> 
> +	mutex_unlock(&uuid_mutex);
>  	ret = btrfs_shrink_device(device, 0);
> +	mutex_lock(&uuid_mutex);
>  	if (ret)
>  		goto error_undo;

I didn't find any problem with this change, but it's not quite clear to
me what exactly does the uuid_mutex protect, so I've tried a best-guess
approach and looked at all uses and git history. If there are multiple
device rm operations called at the same time, they'll get serialized
with the uuid mutex and the device count will be properly protected.

Consider it
Reviewed-by: David Sterba <dsterba@suse.cz>


david
