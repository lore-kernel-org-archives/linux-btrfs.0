Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbbFBPRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jun 2015 11:17:17 -0400
Date: Tue, 2 Jun 2015 17:17:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: use function is_block_device() instead
Message-ID: <20150602151716.GI6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433139918-820-1-git-send-email-anand.jain@oracle.com>
 <1433139918-820-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433139918-820-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 02:25:18PM +0800, Anand Jain wrote:
> Here the delete code as below, is trying to check if the provided device
> is a block device, there is a function for it. use it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks.
