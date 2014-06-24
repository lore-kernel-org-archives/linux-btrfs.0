Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaFXIuP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 04:50:15 -0400
Date: Tue, 24 Jun 2014 10:50:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: dsterba@suse.cz, Adam Buchbinder <abuchbinder@google.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Properly size the leafsize field in the mdrestore_struct
 struct.
Message-ID: <20140624085013.GS1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1402613853-14956-1-git-send-email-abuchbinder@google.com>
 <53A12B3C.7020606@jp.fujitsu.com>
 <20140623134433.GD1553@twin.jikos.cz>
 <53A8B45E.7020809@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A8B45E.7020809@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 24, 2014 at 08:12:30AM +0900, Satoru Takeuchi wrote:
> (2014/06/23 22:44), David Sterba wrote:
> >On Wed, Jun 18, 2014 at 03:01:32PM +0900, Satoru Takeuchi wrote:
> >>(2014/06/13 7:57), Adam Buchbinder wrote:
> >>>It's 32 bits as defined in ctree.h, but the struct had it as 64 bits.
> >>>
> >>>Found using MemorySanitizer.
> >>>
> >>>Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> >>
> >>It looks good to me.
> >>
> >>Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> >
> >Sidned-off? Did you mean Reviewed-by ?
> 
> Oops, sorry.
> 
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks, patch updated.
