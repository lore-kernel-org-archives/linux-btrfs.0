Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53257 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932797AbeFUNwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 09:52:04 -0400
Date: Thu, 21 Jun 2018 15:49:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: About commit f8f84b2dfda5 ("btrfs: index check-integrity state
 hash by a dev_t")
Message-ID: <20180621134911.GP24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 02:36:35PM +0800, Qu Wenruo wrote:
> I see mainline kernel merged commit f8f84b2dfda5 ("btrfs: index
> check-integrity state hash by a dev_t"), and you reviewed it but I can't
> find the mail in mail list, nor it's signed by David.
> 
> Is this btrfs related commit merged without review from btrfs community?
> (Well, at least Liu reviewed it, but at least the mail is not CCed to
> btrfs mail list)

IIRC the patch was part of some series and went through the block layer
tree as it was change in the API and not of btrfs code, but was CCed to
btrfs list as you found out.
