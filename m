Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbbH1Rb3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:31:29 -0400
Date: Fri, 28 Aug 2015 19:30:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: Introduce subvolume sync test
Message-ID: <20150828173052.GJ11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0375c5ddbbc6f00df7f67265df81d71cfd2ab0f8.1440733313.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0375c5ddbbc6f00df7f67265df81d71cfd2ab0f8.1440733313.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 11:42:11AM +0800, Zhao Lei wrote:
> Current code have following bug for subvolume sync:
> 1: If there are more than 1 subvolume to sync, the program will
>    infinitely loop.
> 2: return !0 in exit
> 
> This patch add misc-tests/007-subvolume-sync for above case.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
