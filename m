Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413AbcCVKEH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 06:04:07 -0400
Date: Tue, 22 Mar 2016 11:03:37 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs, misc for 4.6
Message-ID: <20160322100337.GH8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1458585064.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1458585064.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 07:42:09PM +0100, David Sterba wrote:
> Hi,
> 
> a few low-risk patches that appeared after I sent my main pull for 4.6. I think
> they still apply to 4.6, the freezer patches help the livepatch to clean up the
> mis-use of the freezer API, the rest makes sure we don't miss an error during
> writing checksums.
> 
> I've removed Liu Bo's patch fixing the writeback_index, IMO needs moe review
> and can be merged in some later rc.
> 
> ----------------------------------------------------------------
> The following changes since commit 5e33a2bd7ca7fa687fb0965869196eea6815d1f3:
>   Btrfs: do not collect ordered extents when logging that inode exists (2016-03-01 08:23:47 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.6
> 
> for you to fetch changes up to 45147cbef21305b512a5b263e9e52f832a0df7b2:
> 
>   btrfs: transaction_kthread() is not freezable (2016-03-21 19:02:34 +0100)

FYI, I've added Filipe's reviewed-by, the top commit is now
ce63f891e1a87ae79c4325dad5f512e8d6a8a78e
