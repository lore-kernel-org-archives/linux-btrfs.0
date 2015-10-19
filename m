Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbbJSNmS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 09:42:18 -0400
Date: Mon, 19 Oct 2015 15:41:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/10] btrfs-progs: save error number correctly in
 check_chunks_and_extents
Message-ID: <20151019134104.GW27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
 <1445254680-11102-3-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445254680-11102-3-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 19, 2015 at 07:37:52PM +0800, Eryu Guan wrote:
> Coverity reports assigning value from "err" to "ret", but that stored
> value is overwritten by check_extent_refs() before it can be used.

If you fix a coverity issue, please add a tag and the id, like

Resolves-coverity-id: 1234
