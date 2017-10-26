Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39651 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932334AbdJZTA1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 15:00:27 -0400
Date: Thu, 26 Oct 2017 20:58:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, yoasif@gmail.com,
        rrauenza@gmail.com
Subject: Re: [PATCH 2/4] btrfs-progs: fsck: Introduce --fix-dev-size option
Message-ID: <20171026185838.GH3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
 <20171010075113.10718-3-quwenruo.btrfs@gmx.com>
 <20171010131648.GM3521@twin.jikos.cz>
 <f86fb7cf-5e20-3b04-2ed1-5250df618f24@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <f86fb7cf-5e20-3b04-2ed1-5250df618f24@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 08:43:24AM +0800, Qu Wenruo wrote:
> On 2017年10月10日 21:16, David Sterba wrote:
> > On Tue, Oct 10, 2017 at 07:51:11AM +0000, Qu Wenruo wrote:
> >> Introduce --fix-dev-size option to fix device related problems.
> > 
> > Please don't add it to 'check', this is not the right place for the
> > targeted fixes. -> 'btrfs rescue'
> 
> I'm OK moving the super total_bytes fix to 'btrfs rescue'.
> 
> But what about the alignment/mismatch detection part?
> Is it still OK to detect them in 'btrfs check'?
> 
> And further more, the unaligned device total_bytes problem is not a big 
> problem that fits into 'rescue' territory.
> 
> I'm not really sure about the difference between rescue and check.

Check is supposed to find the problems, and rescue command group is for
specific fixes that are not suitable for 'check'. This is to avoid too
many specific options for 'check' and all the possible combinations.

We'll fix the total_bytes bug and don't expect it to be a problem in the
future again, so we can forget about the subcommand in rescue.

What should check report if it detects this kind of inconsistencies,
that's a good question. It could either fix them automatically (if it's
safe) or point to the specific command.
