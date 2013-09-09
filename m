Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab3IIOkX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 10:40:23 -0400
Date: Mon, 9 Sep 2013 16:40:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs-progs:free strdup()s that are not freed
Message-ID: <20130909144021.GP32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1378348738-14451-6-git-send-email-guihc.fnst@cn.fujitsu.com>
 <52282BF7.6040605@giantdisaster.de>
 <52282E7B.6010309@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52282E7B.6010309@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 05, 2013 at 09:10:51AM +0200, Stefan Behrens wrote:
> Just noticed that you had already sent a V2 with the things fixed that I
> have commented, but you sent the 5/5 as a 1/5 and added the changelog
> v1->v2 "none" which made it difficult to recognize :). But maybe David
> Sterba is smart enough when he picks up the patches.

I watch out for updates and replace the patches with the latest version.
V3 of "free strdup()s that are not freed" has been merged.

Thanks for the pointer anyway.
david
