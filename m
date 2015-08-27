Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbbH0Lvo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 07:51:44 -0400
Date: Thu, 27 Aug 2015 13:51:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fixed dsize and last_off declarations
Message-ID: <20150827115107.GD11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150823160142.GA4041@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150823160142.GA4041@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 23, 2015 at 04:01:42PM +0000, Alexandru Moise wrote:
> The return values of btrfs_item_offset_nr and btrfs_item_size_nr are of
> type u32. To avoid mixing signed and unsigned integers we should also
> declare dsize and last_off to be of type u32.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
