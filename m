Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47451 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750837AbeAENOk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 08:14:40 -0500
Date: Fri, 5 Jan 2018 14:12:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: optimize code converge mutex unlock
Message-ID: <20180105131233.GK3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171220064226.4317-1-anand.jain@oracle.com>
 <fdc6d2aa-12ee-c6ff-c997-a68232aac37b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fdc6d2aa-12ee-c6ff-c997-a68232aac37b@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 20, 2017 at 10:19:14AM +0200, Nikolay Borisov wrote:
> 
> 
> On 20.12.2017 08:42, Anand Jain wrote:
> > No functional change rearrange the mutex_unlock.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Added to for-next.
