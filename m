Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbbEUIwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 04:52:18 -0400
Date: Thu, 21 May 2015 10:52:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix a bug which makes unfinished fsid
 change unrecoverable.
Message-ID: <20150521085217.GO23255@suse.cz>
Reply-To: dsterba@suse.cz
References: <1431671795-30516-1-git-send-email-quwenruo@cn.fujitsu.com>
 <555D41D5.10109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <555D41D5.10109@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 10:24:21AM +0800, Qu Wenruo wrote:
> I didn't see this patch merged into 4.0.1.
> 
> As without this patch, canceled fsid change process can't be recovered.

There are only some of the fsid patches merged, the preparatory work.
When the series looks ok up to some patch I think it's better to merge
it so you don't have to resend it again.

The commandline interface is not present yet so it's not even possible
to start the fsid change.

> I totally understand that it's not good to merge a patch into the
> already fully tested tree.
> So would you please consider add this patch to next release(even 4.1 is OK)?

Yes, that's the plan.
