Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbbJ0OVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 10:21:36 -0400
Date: Tue, 27 Oct 2015 15:20:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
Message-ID: <20151027142011.GT13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2015 at 06:29:41PM +0800, Zhao Lei wrote:
> Current code don't support dup profile in single device, except it
> is in mixed mode, because following reason:
> 1: In some ssd with deduplication function, it have no effect.
> 2: For a physical device, it the entire disk broken, -d dup can
>    not help.
> 3: Half performance comparing with single profile.
> 4: We have a workaround: Create multi-partition in single device,
>    and btefs will treat them as multi device.
> 
> Instead of refuse -d dup, we have a better choise:
> Give user a chance to select, and output a warning to notice above
> problem.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

FYI, I've queued the patch for 4.4 (or later) whenever we're ready on
the kernel side.
