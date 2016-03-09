Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbcCINfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 08:35:45 -0500
Date: Wed, 9 Mar 2016 14:35:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix broken 'device scan' arguments parsing
Message-ID: <20160309133524.GE738@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457486380-4051-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457486380-4051-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 08, 2016 at 05:19:40PM -0800, Yauhen Kharuzhy wrote:
> commit 52179e4fea41e55f31c92cd033a0b53a5107b4f4 'btrfs-progs: unify argc
> min/max checking' brokes 'btrfs device scan' command when no argument
> was given. Fix this.
> 
> Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>

Applied, thanks.
