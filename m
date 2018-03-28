Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45532 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752169AbeC1Oz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 10:55:28 -0400
Date: Wed, 28 Mar 2018 16:53:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: build: modify cscope/ctags rules to include
 directories such as check
Message-ID: <20180328145300.GL30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180328060738.23896-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180328060738.23896-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2018 at 02:07:38PM +0800, Lu Fengqi wrote:
> Modify cscope/ctags rule to include directories such as check/
> libbtrfsutil/kernel-lib/kernel-shared.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks.
