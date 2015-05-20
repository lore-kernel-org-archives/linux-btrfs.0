Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbbETMUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 08:20:51 -0400
Date: Wed, 20 May 2015 14:20:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: WorMzy Tykashi <wormzy.tykashi@gmail.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        lukas.lueg@gmail.com
Subject: Re: [PATCH 4/4] btrfs-progs: Add extra chunk item check to avoid
 btrfs-progs crash.
Message-ID: <20150520122049.GH23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1431508536-7275-5-git-send-email-quwenruo@cn.fujitsu.com>
 <20150513161823.GQ23255@twin.jikos.cz>
 <CALOYprV-dyji_5UFm3K-qmw0K2i5u7d14rwX7OPMFS29aY9ZVA@mail.gmail.com>
 <555BD45F.6070509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <555BD45F.6070509@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 20, 2015 at 08:25:03AM +0800, Qu Wenruo wrote:
> Yes, I also find the problem and already sent the fixing patch:
> https://patchwork.kernel.org/patch/6411191/
> 
> The problem is that my previous check patch is too restrict, making DUP 
> chunk with only 1 stripe invalid.
> 
> Fixing patch will allow degraded chunk to exist and fix the bug.

Next time please mention that in the changelog or at least as a side
note that it fixes the broken test or that fixes some previous commit.
