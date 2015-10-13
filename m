Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603AbbJMQUX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 12:20:23 -0400
Date: Tue, 13 Oct 2015 18:19:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: mkfs: Fix different mixed type by
 argument sequence
Message-ID: <20151013161913.GL27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2015 at 08:52:16PM +0800, Zhao Lei wrote:
> Given a 200G vdd1 and 1G vdd2:
> 
> In current code:
>  mkfs.btrfs -f /dev/vdd1 /dev/vdd2
>  and
>  mkfs.btrfs -f /dev/vdd2 /dev/vdd1
>  will create different "mixed" type.

I think combining large and small devices was not intended use for the
mixed-bg, nevertheless current behaviour is not right.

Chandan is working on dropping the forced mixed-bg completely. We've
discussed that on IRC, I'm ok with it but this needs more testing. So
far it looks fine, small filesystems get created and usable, though some
tuning might be needed.

My intentions for 4.3 is to take Chandan's work provided that we test it
enough. There are like 3 weeks left. In case of problems, I'll take this
patchset so at least we get the inconsisten behaviour fixed.
