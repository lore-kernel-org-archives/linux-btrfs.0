Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754484AbdKFREG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 12:04:06 -0500
Date: Mon, 6 Nov 2017 18:02:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/7] btrfs: btrfs_rm_device() does not need uuid_mutex
Message-ID: <20171106170214.GS28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106083618.7617-1-anand.jain@oracle.com>
 <20171106083618.7617-6-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106083618.7617-6-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 04:36:16PM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

No changelog at all? Sorry but I'm tired of asking you for explanations
each time. Removing a mutex is far from a trivial change.
