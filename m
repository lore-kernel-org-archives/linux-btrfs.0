Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbeAENCt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 08:02:49 -0500
Date: Fri, 5 Jan 2018 14:00:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfS: collapse btrfs_handle_error() into
 __btrfs_handle_fs_error()
Message-ID: <20180105130041.GI3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180104100155.9160-1-anand.jain@oracle.com>
 <20180104100155.9160-2-anand.jain@oracle.com>
 <80d38945-d3db-7579-f19a-bbc87b08fa80@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <80d38945-d3db-7579-f19a-bbc87b08fa80@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 04, 2018 at 02:11:21PM +0200, Nikolay Borisov wrote:
> 
> 
> On  4.01.2018 12:01, Anand Jain wrote:
> > There is no other consumer for btrfs_handle_error() other than
> > __btrfs_handle_fs_error(), further this function quite small.
> > Merge it into its parent.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Both patches added to for-next, thanks.
