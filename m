Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137AbaJ3OSf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 10:18:35 -0400
Date: Thu, 30 Oct 2014 15:18:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] btrfs-progs: optimize btrfs_scan_lblkid() for
 multiple calls
Message-ID: <20141030141833.GA15771@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413334270-25766-2-git-send-email-anand.jain@oracle.com>
 <1414045808-6930-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414045808-6930-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 23, 2014 at 02:30:08PM +0800, Anand Jain wrote:
>   introduce a global variable scan_done, which is set when scan is
>   done succssfully per thread. So that following calls to this function
>   will just return success.

The rest is good, I'm a bit concerned about the global variable. It
sholud be at least declared static and not visible outside of utils.c.

The function btrfs_scan_lblkid is called indirectly from various
callchains. For a moment I was thinking about declaring a variable to
hold the scanning status, but btrfs_scan_lblkid is not always called
from a scope of one cmd_something function. Eg. from btrfs_scan_fs_devices
that in turn is called from several other functions. As we're not
concerned about multi-threading, we can use the global variable.

>   Further if any function needs to force scan after scan_done is set,
>   then it can be done when there is such a requirement, but as of now there
>   isn't any such requirement.

Right, then we could introduce something like btrfs_scan_reset_status
and then btrfs_scan_lblkid would work as usual.

> --- a/utils.c
> +++ b/utils.c
> @@ -52,6 +52,8 @@
>  #define BLKDISCARD	_IO(0x12,119)
>  #endif
>  
> +int scan_done = 0;

I'll change it to the following and add to integration.

int btrfs_scan_done = 0;
