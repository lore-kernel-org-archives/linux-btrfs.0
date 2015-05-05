Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422672AbbEEMI4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 08:08:56 -0400
Date: Tue, 5 May 2015 14:08:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Fix superblock csum type check.
Message-ID: <20150505120854.GC5099@suse.cz>
Reply-To: dsterba@suse.cz
References: <1430794395-5846-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430794395-5846-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 05, 2015 at 10:53:15AM +0800, Qu Wenruo wrote:
> Old csum type check is wrong and can't catch csum_type 1(not supported).
> 
> Fix it to avoid hostile 0 division.
> 
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
