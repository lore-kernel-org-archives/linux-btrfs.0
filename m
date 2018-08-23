Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727666AbeHWQx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 12:53:56 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84845ADEF
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 13:24:13 +0000 (UTC)
Date: Thu, 23 Aug 2018 15:24:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2.1] btrfs: Handle owner mismatch gracefully when
 walking up tree
Message-ID: <20180823132402.GN24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180821014203.5443-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180821014203.5443-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 09:42:03AM +0800, Qu Wenruo wrote:
> [BUG]
> When mounting certain crafted image, btrfs will trigger kernel BUG_ON()
> when try to recover balance:
> ------
> ------------[ cut here ]------------

Please don't use lines starting with ---, an empty line is fine, or you
can also indent the trace dump by a few spaces for clarity. I'll update
the patches that have been merged so you don't need to resend.
