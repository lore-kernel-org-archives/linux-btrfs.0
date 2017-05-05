Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47266 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750759AbdEERYe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 13:24:34 -0400
Date: Fri, 5 May 2017 19:24:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 8/9] btrfs: qgroup: Introduce extent changeset for
 qgroup reserve functions
Message-ID: <20170505172427.GH10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-9-quwenruo@cn.fujitsu.com>
 <20170407120025.GT4781@twin.jikos.cz>
 <e97cbe28-1333-22bc-357b-570b4e865ec5@cn.fujitsu.com>
 <20170410140025.GZ4781@suse.cz>
 <20170410141430.GA4781@suse.cz>
 <0645fb36-be0b-c598-78be-36484589da7a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0645fb36-be0b-c598-78be-36484589da7a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 09:44:03AM +0800, Qu Wenruo wrote:
> > I get that we cannot easily avoid using the extent_changeset, so we'll
> > end up one way or another, the stack conservation has slight preference.
> 
> Yes, I understand dynamic allocation can complicate the error handler.
> 
> But the allocation inside btrfs_qgroup_reserve_data() could reduce the 
> impact. And bring less compact to qgroup disabled case.
> (So btrfs_qgroup_reserve_data() accepts struct extent_changeset ** other 
> than struct extent_changeset *)
> 
> The code to be modified should be at the same level as current patch.
> Mostly change extent_changeset_release() to extent_changeset_free().
> 
> 
> So overall the impact is not that huge, unless current error handlers 
> already have some problems.
> 
> Personally speaking I'm OK either way.
> 
> Do I need to build a temporary branch/patchset for your evaluation?

Yes please.
