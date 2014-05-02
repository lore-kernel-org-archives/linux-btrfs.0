Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaEBQNn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 12:13:43 -0400
Date: Fri, 2 May 2014 18:13:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not increment on bio_index one by one
Message-ID: <20140502161342.GQ5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1398748078-5832-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1398748078-5832-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 29, 2014 at 01:07:58PM +0800, Liu Bo wrote:
> 'bio_index' is just a index, it's really not necessary to do increment
> one by one.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
