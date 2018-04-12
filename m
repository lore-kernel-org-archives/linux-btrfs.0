Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36000 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbeDLADR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 20:03:17 -0400
Received: by mail-pl0-f66.google.com with SMTP id 91-v6so2578004pld.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 17:03:17 -0700 (PDT)
Date: Wed, 11 Apr 2018 17:03:15 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.cz>
Cc: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
Message-ID: <20180412000315.GA25451@vader>
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
 <bc883776-3d68-b21c-bde1-edb6488cd1ed@suse.com>
 <ade96fd3-3aae-d39b-cf3c-0461811c1042@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ade96fd3-3aae-d39b-cf3c-0461811c1042@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 04, 2018 at 08:17:22PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年04月04日 16:53, Nikolay Borisov wrote:
> > 
> > 
> > On  3.04.2018 10:30, Qu Wenruo wrote:
> >> Hi David,
> >>
> >> I didn't see this patch merged in your misc-next branch but only the
> >> remaining patches.
> >>
> >> However without this patch, btrfs qgroup reserved space will get
> >> obviously increased as prealloc metadata reserved space is never freed
> >> until inode reserved space is freed.
> >>
> >> This would cause a lot of qgroup related test cases to fail.
> >>
> >> Would you please merge this patch with all qgroup patchset?
> > 
> > I'm seeing btrfs/022 and btrfs/099 fail as of today's misc-next. Both
> > are qgroup related tests.
> 
> Exactly.
> 
> Wondering why this patch is left.
> 
> Thanks,
> Qu

I'm also seeing several qgroups xfstests failures on Linus' master
branch. Dave?
