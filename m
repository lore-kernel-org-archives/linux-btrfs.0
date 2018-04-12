Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753028AbeDLNPt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 09:15:49 -0400
Date: Thu, 12 Apr 2018 15:13:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
Message-ID: <20180412131318.GI21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2018 at 03:30:34PM +0800, Qu Wenruo wrote:
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

For the record: patch 9 and 10 are now in misc next and will go to 4.17.
I need to let them through the for-next and other testing, so it will be
some of the post rc1 pull requests.
