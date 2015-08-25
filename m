Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbbHYPe4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:34:56 -0400
Date: Tue, 25 Aug 2015 17:34:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: cleanup: remove unnecessary check before
 btrfs_free_path is called
Message-ID: <20150825153420.GH10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201508190844.AA00004@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201508190844.AA00004@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 05:44:53PM +0900, Tsutomu Itoh wrote:
> We need not check path before btrfs_free_path() is called because
> path is checked in btrfs_free_path().
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Applied, thanks.
