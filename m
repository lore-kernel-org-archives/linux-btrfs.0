Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbaFWNof (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 09:44:35 -0400
Date: Mon, 23 Jun 2014 15:44:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Properly size the leafsize field in the mdrestore_struct
 struct.
Message-ID: <20140623134433.GD1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1402613853-14956-1-git-send-email-abuchbinder@google.com>
 <53A12B3C.7020606@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A12B3C.7020606@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 03:01:32PM +0900, Satoru Takeuchi wrote:
> (2014/06/13 7:57), Adam Buchbinder wrote:
> > It's 32 bits as defined in ctree.h, but the struct had it as 64 bits.
> > 
> > Found using MemorySanitizer.
> > 
> > Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> 
> It looks good to me.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Sidned-off? Did you mean Reviewed-by ?
