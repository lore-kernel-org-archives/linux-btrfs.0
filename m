Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221AbbIYPu3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 11:50:29 -0400
Date: Fri, 25 Sep 2015 17:49:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
Message-ID: <20150925154931.GJ11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 10, 2015 at 10:34:13AM +0800, Qu Wenruo wrote:
>   btrfs-progs: fsck: Add check for extent and parent chunk type
>   btrfs-progs: utils: Check nodesize against features

Applied the two, thanks.

>   btrfs-progs: convert: force convert to used mixed block group
>   btrfs-progs: util: add parameter for btrfs_list_all_fs_features
>   btrfs-progs: convert-test: Disable different nodesize test
