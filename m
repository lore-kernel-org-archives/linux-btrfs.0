Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934262AbcLLRTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 12:19:33 -0500
Date: Mon, 12 Dec 2016 18:19:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] recursive defrag cleanup
Message-ID: <20161212171927.GY12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161206043938.3249-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161206043938.3249-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2016 at 12:39:37PM +0800, Anand Jain wrote:
> The command,
>    btrfs fi defrag -v /btrfs
>  does nothing, it won't defrag the files under /btrfs as user
>  may expect. The command with recursive option
>    btrfs fi defrag -vr /btrfs
>  would defrag all the files under /btrfs including files in
>  its sub directories.
> 
>  While attempting to fix this. The patch below 1/1 provides
>  a cleanup. And the actual fix is pending, as to my understanding
>  of nfwt() it does not provide the list of file without
>  files under its sub directories.

What kind of fix do you mean? We could detect if there's a directory in
the list of arguments and assume the recursive mode. I think this is
what most users expect.

Currently passing a directory will defragment the extent tree, but I
think we should extend the defrag ioctl flags to explictly ask for that.
At minimum, a directory without -r could print a warning about what it's
really doing. But I'm open to other ideas.
