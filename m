Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbcAKPxd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 10:53:33 -0500
Date: Mon, 11 Jan 2016 16:51:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs-progs: Format change for btrfs fi df
Message-ID: <20160111155108.GH4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
 <568B23E4.5040809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <568B23E4.5040809@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On Tue, Jan 05, 2016 at 10:01:08AM +0800, Qu Wenruo wrote:
> Would you please consider merge this patch?
> 
> As current output is already quite confusing for a lot of users who are 
> not familiar with btrfs.

I understand it's confusing but as there's some history behind this
option I need to think about the consequences. I'd rather keep it in the
output, removing stuff is likely to cause breakage in scripts etc. OTOH,
the 'fi df' was supposed to be a debugging helper but not everybody is
used to 'fi usage' yet.
