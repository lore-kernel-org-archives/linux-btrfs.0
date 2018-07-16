Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbeGPQns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 12:43:48 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A1A2AD03
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 16:15:40 +0000 (UTC)
Date: Mon, 16 Jul 2018 18:15:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: check: orig: Don't panic out when
 unexpected root item is referring to one extent
Message-ID: <20180716161533.GO3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180705074558.20022-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180705074558.20022-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2018 at 03:45:56PM +0800, Qu Wenruo wrote:
> With crafted image, expected root item can refer to certain extent, and
> original mode uses BUG_ON() to handle such case.
> 
> Fix it by gracefully return error.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200403
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Please send cover lettter for patchsets with more than one patch.
Patches 1-3 applied, thanks.
