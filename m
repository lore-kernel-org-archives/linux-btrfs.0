Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753143AbdACRyY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 12:54:24 -0500
Date: Tue, 3 Jan 2017 18:36:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] btrfs: consolidate auto defrag kick off policies
Message-ID: <20170103173628.GT12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161206044309.3450-4-anand.jain@oracle.com>
 <20161219110906.12979-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161219110906.12979-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 07:09:06PM +0800, Anand Jain wrote:
> As of now writes smaller than 64k for non compressed extents and 16k
> for compressed extents inside eof are considered as candidate
> for auto defrag, put them together at a place.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
