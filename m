Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdKUNis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 08:38:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DAFC6AAC7
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 13:38:46 +0000 (UTC)
Date: Tue, 21 Nov 2017 14:36:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: extent-tree: Use round up to replace align macro
Message-ID: <20171121133652.GJ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171121055445.13972-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171121055445.13972-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 01:54:45PM +0800, Qu Wenruo wrote:
> To save reader seconds before checking if it's rounding up or down.

Agreed, this is more clear. Please switch all instances of ALIGN to
round_up, there's not much point doing it file by file.
