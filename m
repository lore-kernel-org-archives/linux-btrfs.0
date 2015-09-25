Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbbIYR6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 13:58:47 -0400
Date: Fri, 25 Sep 2015 19:57:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert: Print different error message if
 convert partly failed.
Message-ID: <20150925175749.GQ11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433836660-1163-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433836660-1163-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 09, 2015 at 03:57:40PM +0800, Qu Wenruo wrote:
> When testing under libguestfs, btrfs-convert will never succeed to fix
> chunk map, and always fails.
> 
> But in that case, it's already a mountable btrfs.
> So better to info user with different error message for that case.
> 
> The root cause of it is still under investigation.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

I've adjusted wording of the error message and applied, thanks. What are
the consequences of the unfinished conversion process when such
filesystem is mounted?
