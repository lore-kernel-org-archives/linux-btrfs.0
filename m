Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbcANQAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 11:00:34 -0500
Date: Thu, 14 Jan 2016 17:00:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH v5 0/2][PULL REQUEST] Unify 'norecovery' bahavior with
 other filesystems
Message-ID: <20160114160031.GB4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1452564313-22007-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452564313-22007-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2016 at 10:05:11AM +0800, Qu Wenruo wrote:
> 'Norecovery' mount option is almost a standard for all other
> filesystems, including f2fs, ext4, gfs2, nilfs2, and xfs.
> And since current 'recovery' mount option for btrfs is too generic, it's
> better to change btrfs 'recovery' to 'usebackuproot' and then we can
> safely add 'norecovery' and 'nologreplay' mount option for btrfs.
> 
> The patch itself is not huge and already tested by others since v2.
> Only mount option name is changing during all these version changes.

So we have some kind of consensus about the options, but I think you
need to split the patches further.

* the new option 'nologreplay'
* keep 'usebackuproot' as a new alias for 'recovery' (with the
  deprecation warning)
* new 'norecovery' that switches on 'nologreplay' and 'nousebackuproot'
  (ie. the desired "no writes")

There is a case in remount, when we start with 'ro,nologreplay' then
remount with just 'ro', the log should be replayed. The other
combinations should be easy. I haven't looked at the patch if it's
implemented that way though.
