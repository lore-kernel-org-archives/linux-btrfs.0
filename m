Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbbAPKvd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Jan 2015 05:51:33 -0500
Date: Fri, 16 Jan 2015 11:51:31 +0100
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix typo of variable in scrub_stripe
Message-ID: <20150116105131.GL3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201501090837.AA00007@WIN-R1VKH1IH438.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201501090837.AA00007@WIN-R1VKH1IH438.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 05:37:52PM +0900, Tsutomu Itoh wrote:
> The address that should be freed is not 'ppath' but 'path'.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com> 

Chris, please add this patch to the next 3.19-rc, the code has been
introduced during this merge window.
