Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754853AbdCISnc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 13:43:32 -0500
Date: Thu, 9 Mar 2017 19:42:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 0/9] convert: rework rollback
Message-ID: <20170309184255.GJ14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 24, 2017 at 01:52:23PM +0800, Qu Wenruo wrote:
> The patchset can be fetched from my github, based on v4.9.1:
> https://github.com/adam900710/btrfs-progs/tree/rollback_rework_v2

I have manually merged the patchset and made some minor change along the
way. The convert tests now pass, I'll let the full set finish.

> Rework rollback to provide a easier to understand new mechnisim, which can
> handle both old convert behavior and new convert behavior.

Yeah, overall the new code looks better, thanks.
