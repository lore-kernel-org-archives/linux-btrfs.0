Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbbLNQrC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 11:47:02 -0500
Date: Mon, 14 Dec 2015 17:44:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use linux/sizes.h to represent constants
Message-ID: <20151214164458.GM4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1450111330-2944-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450111330-2944-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2015 at 01:42:10AM +0900, Byongho Lee wrote:
> We use many constants to represent size and offset value.  And to make
> code readable we use '256 * 1024 * 1024' instead of '268435456' to
> represent '256MB'.  However we can make far more readable with 'SZ_256MB'
> which is defined in the 'linux/sizes.h'.
> 
> So this patch replaces 'xxx * 1024 * 1024' kind of expression with
> single 'SZ_xxxMB' if 'xxx' is a power of 2 then 'xxx * SZ_1M' if 'xxx' is
> not a power of 2. And I haven't touched to '4096' & '8192' because it's
> more intuitive than 'SZ_4KB' & 'SZ_8KB'.
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
