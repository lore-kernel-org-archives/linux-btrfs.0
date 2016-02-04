Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbcBDOUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 09:20:41 -0500
Date: Thu, 4 Feb 2016 15:20:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: describe btrfs-send requires read-only
 subvolume
Message-ID: <20160204142024.GD9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56B2DB56.6070104@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56B2DB56.6070104@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 04, 2016 at 02:02:14PM +0900, Satoru Takeuchi wrote:
> Both man btrfs-send(8) and usage message don't describe
> btrfs-send needs read-only snapshot as its argument.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, thanks.
