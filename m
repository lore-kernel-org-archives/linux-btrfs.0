Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbbCILUf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 07:20:35 -0400
Date: Mon, 9 Mar 2015 12:20:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs-progs: fsck-test: Add check_sudo to check valid
 root/sudo privilege
Message-ID: <20150309112033.GC5841@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425267710-416-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425267710-416-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 02, 2015 at 11:41:50AM +0800, Qu Wenruo wrote:
> New '_sudo' command will do credential check if needed to avoid such
> problem.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Add support for old sudo.
>   Remove 'have_root_helper' variant
>   Integrate 'check_root' into root_helper function.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Since I can't reproduce the NOPASSWD setting with 'sudo -v -n' failure,
> so only UID==0 and need_validate==1 case, would you please test the
> need_validate==0 case? 

Works for me, thanks. I'll do some cleanups (separate patch) so the
variables are capitalized and clearly visible in the scripts.
