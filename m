Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbbLNReG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 12:34:06 -0500
Date: Mon, 14 Dec 2015 18:32:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
Message-ID: <20151214173200.GO4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 10:34:06AM +0800, Qu Wenruo wrote:
> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
> option to get real readonly mount, like "norecovery" in ext* and xfs.
> 
> Since the new parse_options() need to check new flags at remount time,
> so add a new parameter for parse_options().
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

I've read the discussions around the change and from the user's POV I'd
suggest to add another mount option that would be just an alias for any
mount options that would implement the 'hard-ro' semantics.

Say it's called 'nowr'. Now it would imply 'nologreplay', but may cover
more options in the future.

 mount -o ro,nowr /dev/sdx /mnt

would work when switching kernels.
