Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220AbcDYMC5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 08:02:57 -0400
Date: Mon, 25 Apr 2016 14:02:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: prop: remove an unnecessary condition on
 parse_args
Message-ID: <20160425120246.GF23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57172290.1030005@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57172290.1030005@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 20, 2016 at 03:32:48PM +0900, Satoru Takeuchi wrote:
> >From commit c742debab11f ('btrfs-progs: fix a regression that
> "property" with -t option doesn't work'), the number of arguments
> is checked strictly. So the following condition never be
> satisfied.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, thanks.
