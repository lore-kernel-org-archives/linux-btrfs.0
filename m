Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35278 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab2I3XbI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 19:31:08 -0400
Date: Mon, 1 Oct 2012 01:31:03 +0200
From: David Sterba <dave@jikos.cz>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH 1/2] btrfs: remove unused function
 btrfs_insert_some_items()
Message-ID: <20120930233103.GP14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348906067-9348-1-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348906067-9348-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 29, 2012 at 04:07:46PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> The function btrfs_insert_some_items() would not be called by any other functions,
> so remove it.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Ok from me, thanks.

david
