Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbbJSNqi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 09:46:38 -0400
Date: Mon, 19 Oct 2015 15:45:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/10] btrfs-progs: remove deadcode around metadump_v2 in
 check_chunk_refs
Message-ID: <20151019134523.GX27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
 <1445254680-11102-4-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445254680-11102-4-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 19, 2015 at 07:37:53PM +0800, Eryu Guan wrote:
> metadump_v2 is initialized to 0 and never updated again. So remove the
> deadcode.

Josef introduced the v2 metadump to resolve some issues with the v1
format. Even if the code appears dead, I think it's "not yet used", but
I don't know what were the intentions with it.
