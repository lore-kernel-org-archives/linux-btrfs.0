Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbcCPPuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 11:50:09 -0400
Date: Wed, 16 Mar 2016 16:49:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] btrfs: rename save_error_info to set_fs_error
Message-ID: <20160316154943.GN21722@suse.cz>
Reply-To: dsterba@suse.cz
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
 <20160316100535.GH21722@twin.jikos.cz>
 <56E962B3.2000700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E962B3.2000700@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 09:42:11PM +0800, Anand Jain wrote:
> On 03/16/2016 06:05 PM, David Sterba wrote:
> > On Wed, Mar 16, 2016 at 04:43:05PM +0800, Anand Jain wrote:
> >> @@ -171,7 +171,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
> >>   #endif
> >>
> >>   	/* Don't go through full error handling during mount */
> >> -	save_error_info(fs_info);
> >> +	set_fs_error(fs_info);
> >
> > The helper is too trivial, can you please drop it and replace by the
> > it's code here
> In fact I was thinking that too, but comments below stop me doing that,
> potentially this function might provision persistent FS state.

Yeah I saw it too of course, but the whole feature "save error state on
disk"  would need more work, the helper does not seem too useful. The
comment can be moved as well to keep it as a reminder.

> 
> ----
>          /*
>           * today we only save the error info into ram.  Long term we'll
>           * also send it down to the disk
>           */
> -----
