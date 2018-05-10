Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756946AbeEJLs3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 07:48:29 -0400
Date: Thu, 10 May 2018 13:45:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: check: Make btrfs check return error
 for qgroup mismatch
Message-ID: <20180510114549.GD6649@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180430061700.18498-1-wqu@suse.com>
 <20180508174513.GO6649@twin.jikos.cz>
 <d28e1cb9-7610-89ff-4980-34a969fbe779@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <d28e1cb9-7610-89ff-4980-34a969fbe779@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 09:43:09AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年05月09日 01:45, David Sterba wrote:
> > On Mon, Apr 30, 2018 at 02:16:59PM +0800, Qu Wenruo wrote:
> >> Current btrfs-check will check qgroup consistency, but even when it
> >> finds something wrong, the return value is still 0.
> >>
> >> Fix it by allowing report_qgroups() to return int to indicate qgroup
> >> mismatch, and also add extra logical to return no error if qgroup repair
> >> is successful.
> >>
> >> Without this patch, fstests can't detect qgroup corruption by its fsck
> >> alone.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > 
> > Applied, thanks. Please send the 0/N (cover letter) mail even for
> > 2-patch series.
> 
> Any advice on the necessity of the cover letter?
> 
> Is cover letter highly recommended for any patches which have any
> dependency like the 2nd test case?

The cover letter is a place where you can get feedback on the whole
patchset, individual patches get the specific comments to the code.

A patchset makes a logical chunk of patches so the cover letter also
serves as the high-level overview of the changes before I or others even
start looking further.

I've seen other maintainers to prefer cover letters, but as this is not
documented and not generally appreciated by developers, it needs to be
stated. Developers who post patches frequently could help to improve the
patch flow process, but lack of cover letter is not a big deal
otherwise.
