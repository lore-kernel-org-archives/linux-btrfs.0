Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45361 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751776AbdJPOTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:19:34 -0400
Date: Mon, 16 Oct 2017 16:17:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use need_full_stripe() in __btrfs_map_block()
Message-ID: <20171016141748.GO3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171012084300.4740-1-anand.jain@oracle.com>
 <ec5ffd06-6881-d121-3046-9a2e1f79993c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ec5ffd06-6881-d121-3046-9a2e1f79993c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 12:03:31PM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.10.2017 11:43, Anand Jain wrote:
> > A cleanup patch, use need_full_stripe() to replace the open code.
> 
> The code is equivalent by merit of De Morgan's law (I had to actually go
> look up the equivalence classes before I convinced myself it was correct)
> 
> ~A ^ ~B == ~(A or B)

You confused me first by the bitwise operators here, while the patch is
actually for the logical ones (and correct).
