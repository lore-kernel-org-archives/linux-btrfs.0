Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46168 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752492AbeBSPDi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 10:03:38 -0500
Date: Mon, 19 Feb 2018 16:01:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unused function btrfs_async_submit_limit()
Message-ID: <20180219150120.GH10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180215033607.14236-1-anand.jain@oracle.com>
 <e86cf203-fb50-d12c-39f1-1918d10c6acf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e86cf203-fb50-d12c-39f1-1918d10c6acf@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 10:29:10AM +0200, Nikolay Borisov wrote:
> On 15.02.2018 05:36, Anand Jain wrote:
> > Commit [1] removed the need to use btrfs_async_submit_limit(), so
> > delete it.
> > 
> > [1]
> >  commit 736cd52e0c720103f52ab9da47b6cc3af6b083f6
> >   Btrfs: remove nr_async_submits and async_submit_draining
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Added to next, thanks.
