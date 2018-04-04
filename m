Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33981 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751460AbeDDIyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 04:54:00 -0400
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bc883776-3d68-b21c-bde1-edb6488cd1ed@suse.com>
Date: Wed, 4 Apr 2018 11:53:56 +0300
MIME-Version: 1.0
In-Reply-To: <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.04.2018 10:30, Qu Wenruo wrote:
> Hi David,
> 
> I didn't see this patch merged in your misc-next branch but only the
> remaining patches.
> 
> However without this patch, btrfs qgroup reserved space will get
> obviously increased as prealloc metadata reserved space is never freed
> until inode reserved space is freed.
> 
> This would cause a lot of qgroup related test cases to fail.
> 
> Would you please merge this patch with all qgroup patchset?

I'm seeing btrfs/022 and btrfs/099 fail as of today's misc-next. Both
are qgroup related tests.

