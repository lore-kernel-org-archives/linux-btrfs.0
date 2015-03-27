Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbbC0QoR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 12:44:17 -0400
Date: Fri, 27 Mar 2015 17:44:05 +0100
From: David Sterba <dsterba@suse.cz>
To: nick <xerofoify@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: How to do Header Dependency  Check Properly for Kernel Patch
Message-ID: <20150327164405.GA5758@suse.cz>
Reply-To: dsterba@suse.cz
References: <55149A03.4040807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55149A03.4040807@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26, 2015 at 07:45:07PM -0400, nick wrote:
> I have a patch for moving over the rcu-string header file for btrfs to
> the standard include headers in include/linux
> as you stated this on a to do on the brtfs to do page for the
> project's wiki page.

The wiki page states that the task is already assigned
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Move_rcu_string_out_of_btrfs_to_lib.2F

besides that there were 8 iterations of the patchset, acked by the
respective people.

http://thread.gmane.org/gmane.linux.kernel/1862689

> index de5e4f2..df8e981 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -15,11 +15,13 @@
>   * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>   * Boston, MA 021110-1307, USA.
>   */
> +#pragma once
>  
>  #ifndef __BTRFS_I__
>  #define __BTRFS_I__

the pragmas are not used in kernel AFAIK, the ifndef right below the
line serves the exact purpose.
