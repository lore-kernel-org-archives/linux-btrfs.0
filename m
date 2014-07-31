Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGaMBy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 08:01:54 -0400
Date: Thu, 31 Jul 2014 14:01:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-porgs: fix xfstest btrfs/023 random failure
Message-ID: <20140731120151.GC1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405589304-7174-1-git-send-email-anand.jain@oracle.com>
 <20140729125723.GR1553@twin.jikos.cz>
 <53D9EB3B.2070703@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D9EB3B.2070703@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 31, 2014 at 03:07:39PM +0800, Anand Jain wrote:
> > and the fsync just made the race window smaller. If you still think
> > the fsync is useful, please update the changelog.
> 
>   You mean I should put fsync at more correct places ?

The fsync should not be necessary, but I haven't looked very closely.
