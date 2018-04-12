Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56841 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752437AbeDLMsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 08:48:51 -0400
Date: Thu, 12 Apr 2018 14:46:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: David Sterba <dsterba@suse.cz>, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
Message-ID: <20180412124619.GH21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
 <bc883776-3d68-b21c-bde1-edb6488cd1ed@suse.com>
 <ade96fd3-3aae-d39b-cf3c-0461811c1042@gmx.com>
 <20180412000315.GA25451@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180412000315.GA25451@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 05:03:15PM -0700, Omar Sandoval wrote:
> > 
> > On 2018年04月04日 16:53, Nikolay Borisov wrote:
> > > On  3.04.2018 10:30, Qu Wenruo wrote:
> > >> I didn't see this patch merged in your misc-next branch but only the
> > >> remaining patches.
> > >>
> > >> However without this patch, btrfs qgroup reserved space will get
> > >> obviously increased as prealloc metadata reserved space is never freed
> > >> until inode reserved space is freed.
> > >>
> > >> This would cause a lot of qgroup related test cases to fail.
> > >>
> > >> Would you please merge this patch with all qgroup patchset?
> > > 
> > > I'm seeing btrfs/022 and btrfs/099 fail as of today's misc-next. Both
> > > are qgroup related tests.
> > 
> > Exactly.
> > 
> > Wondering why this patch is left.
> I'm also seeing several qgroups xfstests failures on Linus' master
> branch. Dave?

Hm, dunno where the last patch got lost. The intention whas to merge the
whole series, I'll add the patch to 2nd pull.
