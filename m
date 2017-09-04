Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753932AbdIDSXX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 14:23:23 -0400
Date: Mon, 4 Sep 2017 20:21:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove batch plug in run_scheduled_IO
Message-ID: <20170904182154.GH31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170901221430.10131-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170901221430.10131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 04:14:26PM -0600, Liu Bo wrote:
> Block layer has a limit on plug, ie. BLK_MAX_REQUEST_COUNT == 16, so
> we don't gain benefits by batching 64 bios here.

So this effectively does not change anything on the btrfs side, but we
can remove code that relies on some internal block layer behaviour.

Reviewed-by: David Sterba <dsterba@suse.com>
