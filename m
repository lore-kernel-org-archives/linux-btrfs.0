Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46972 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932635AbcKGRyC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 12:54:02 -0500
Date: Mon, 7 Nov 2016 18:53:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs: Add trace point for qgroup reserved space
Message-ID: <20161107175339.GS12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161020022842.27328-1-quwenruo@cn.fujitsu.com>
 <20161020022842.27328-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161020022842.27328-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2016 at 10:28:42AM +0800, Qu Wenruo wrote:
> Introduce the following trace points:
> qgroup_update_reserve
> qgroup_meta_reserve
> 
> And modify the timing of btrfs_qgroup_free_delayed_ref() and
> btrfs_qgroup_release_data() events, to work with qgroup_update_reserve()
> event.

I think this should go to a separate patch, as it's a functional change
(and not obvious to me) unlike adding the tracepoints.
