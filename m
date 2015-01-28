Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbbA1UyE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:04 -0500
Date: Wed, 28 Jan 2015 19:27:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Better btrfsck tree corruption report and automatic
 csum tree rebuild.
Message-ID: <20150128182740.GI3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 13, 2015 at 10:04:43AM +0800, Qu Wenruo wrote:
> Although btrfsck can rebuild the csum tree, but has the following
> problems for end users or sysadmins who is not familiar with btrfs.
> 1) No brief info on which tree is corrupted.
>    In fact, after extent and chunk tree check, we iterate all the
>    extents and should have a brief view about which tree is corrupted.
>    We can info user the fact to give them a clear view about what to do
>    next
> 
> 2) No automatically csum tree rebuild.
>    If btrfsck can rebuild csum tree when needed and possible, why not
>    rebuild it?

> This patchset handles this 2 problems:
> Patch 1 will handle problem 1) and patch 2~3) to handle problem 2).
> Now csum tree will be automatically rebuilt if and only if csum tree is
> broken but all other tree is OK.

I don't agree here, rebuilding the csum tree should be user's decision.
Point 1) is good, giving more information to the user certainly helps to
make that decision.
