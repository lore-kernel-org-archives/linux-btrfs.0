Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaLRRQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 12:16:27 -0500
Date: Thu, 18 Dec 2014 18:16:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
Message-ID: <20141218171625.GE27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <548E7AFE.5010001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <548E7AFE.5010001@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 15, 2014 at 02:09:02PM +0800, Qu Wenruo wrote:
> It seems the second patch, which about 225K including a btrfs-image 
> dump, can't pass the ml's size limit.

I've cherry-picked the commit with the test image.
