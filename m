Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbbIKO50 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 10:57:26 -0400
Date: Fri, 11 Sep 2015 16:56:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
Message-ID: <20150911145638.GP8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 10, 2015 at 10:34:13AM +0800, Qu Wenruo wrote:
> Again the buggy btrfs-convert, even David tried to ban mixed-bg features
> for btrfs-convert, it will still put data and metadata extents into the
> same chunk, without marking the chunk mixed.
> 
> So in the patchset, first add fsck support for such problem, and then
> force btrfs-convert to use mixed block group.

I don't think this is a good option for now. People convert
many-terabytes filesystems. Unless there's a way how to convert such
filesystem to the split data/metadata type I don't want to force mixed
bg to convert. The bug you describe is there, but I wonder why didn't
we notice problems that arise from it.
