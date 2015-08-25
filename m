Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbbHYRRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:17:22 -0400
Date: Tue, 25 Aug 2015 19:16:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, marc@merlins.org
Subject: Re: [PATCH 1/2] btrfs-progs: find-root: Output matched root when
 searching all roots
Message-ID: <20150825171646.GQ10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440470697-21177-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440470697-21177-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 10:44:56AM +0800, Qu Wenruo wrote:
> [Bug]
> When given '-a' option, btrfs-find-root will output all possible tree
> roots but the exact matched one.
> 
> [Reason]
> Result printing skipes the exact match one, as it will normally be shown
> before the alternative ones.
> But when '-a' is given, that's not the case.
> 
> [Fix]
> Just show the exact match one for search all case.
> 
> Reported-by: Marc Merlin <marc@merlins.org>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
