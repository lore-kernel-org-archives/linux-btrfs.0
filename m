Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50069 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752625AbeCPQdC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 12:33:02 -0400
Date: Fri, 16 Mar 2018 17:30:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: drop num argument from find_live_mirror()
Message-ID: <20180316163036.GD16736@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180314082913.31503-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180314082913.31503-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 04:29:12PM +0800, Anand Jain wrote:
> Obtain the stripes info from the map directly and so no need
> to pass it as an argument.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

1-2 applied, thanks.
