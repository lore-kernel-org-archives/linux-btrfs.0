Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbcEIP4X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 11:56:23 -0400
Date: Mon, 9 May 2016 17:56:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs-progs: prop: convert error messages to use
 error()
Message-ID: <20160509155601.GL29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57303A21.9070308@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57303A21.9070308@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 09, 2016 at 04:20:01PM +0900, Satoru Takeuchi wrote:
> props.c uses 'fprintf(stderr, "ERROR: ...")' as its error messages,
> however we have generic error() function.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

All applied, thanks. I did some minor tweaks to the messages in 1/3 to
be consistent with the rest.
