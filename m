Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbbKZPCa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 10:02:30 -0500
Date: Thu, 26 Nov 2015 16:00:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: mkfs: Enable -d dup for single device
Message-ID: <20151126150044.GU31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <71e6ba091cdb43b7d0d5f73fb3dd2daa2929ec41.1447925407.git.zhaolei@cn.fujitsu.com>
 <564E3BA8.9020909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <564E3BA8.9020909@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 19, 2015 at 04:14:16PM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-19 04:36, Zhao Lei wrote:
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Seeing as I forgot to reply to the previous version after testing it, 
> I'll just reply here now that I've run this version through the same 
> tests I did on the last one.
> 
> I threw everything I could think of at it, and nothing broke, so you can 
> add:
> Tested-by: Austin S. Hemmelgarn

Thanks.

Patch added to devel as it's not code-intrusive, will be probably
released within 4.4.
