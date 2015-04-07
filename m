Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbbDGPoS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 11:44:18 -0400
Date: Tue, 7 Apr 2015 17:44:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Message-ID: <20150407154416.GD25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1428045793-11511-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428045793-11511-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 03, 2015 at 03:23:13PM +0800, Qu Wenruo wrote:
> Although btrfs-convert can rollback converted btrfs, it still has some
> limitation to ensure rollback.
> 
> Add a warning on the limitations.
> 
> Also add a note for users who decides to go on with btrfs and don't need
> the rollback ability.
> 
> Reported-by: Vytautas D <vytdau@gmail.com>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
