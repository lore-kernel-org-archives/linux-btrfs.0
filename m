Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbbEDQIH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 May 2015 12:08:07 -0400
Date: Mon, 4 May 2015 18:08:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix superblock csum type check.
Message-ID: <20150504160805.GA5099@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430183163-10870-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150429172307.GD4996@twin.jikos.cz>
 <55417856.5060207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55417856.5060207@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 30, 2015 at 08:33:26AM +0800, Qu Wenruo wrote:
> >> -				csum_type);
> >> +		       csum_type);
> >
> > Please avoid unrelated changes.
> Thanks for reviewing.
> 
> Do I need to send a newer version to discard this format change?

Yes please.
