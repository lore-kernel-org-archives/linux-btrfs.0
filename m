Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33681 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750941AbdEBOZs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 10:25:48 -0400
Date: Tue, 2 May 2017 16:25:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: fssum, fix memory leak
Message-ID: <20170502142542.GG23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170426012241.29814-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170426012241.29814-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 26, 2017 at 09:22:41AM +0800, Lu Fengqi wrote:
> Free the alloced memory and close dir before exit.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks.
