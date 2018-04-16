Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49423 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbeDPTFl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 15:05:41 -0400
Date: Mon, 16 Apr 2018 21:03:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
Message-ID: <20180416190309.GY21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180416020227.18528-1-wqu@suse.com>
 <59af2ff4-b8d9-c1df-2053-c180c5533d2d@oracle.com>
 <8cc34db9-0d09-38de-ac59-ed2be758de58@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <8cc34db9-0d09-38de-ac59-ed2be758de58@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 09:00:38PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年04月16日 20:55, Anand Jain wrote:
> > 
> > 
> > On 04/16/2018 10:02 AM, Qu Wenruo wrote:
> >> There are already 2 reports about strangely corrupted super blocks,
> >> where csum type and incompat flags get some obvious garbage, but csum
> >> still matches and all other vitals are correct.
> >>
> >> This normally means some kernel memory corruption happens, although the
> >> cause is unknown, at least detect it and prevent further corruption.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> > 
> >  Can you help point those 2 cases here?
> 
> Did you mean the reported-by tags?
> If so, no problem.

Yes please, also describe what got corrupted in the changelog, besides
the links to the bugreports.
