Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbcK3QeT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 11:34:19 -0500
Date: Wed, 30 Nov 2016 17:34:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2 02/14] btrfs-progs: check: introduce function to find
 dir_item
Message-ID: <20161130163414.GS12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
 <20160921031604.23334-3-quwenruo@cn.fujitsu.com>
 <20161102152151.GH12522@twin.jikos.cz>
 <cedc76f5-fadc-c6d0-b491-eb16ccc3e15a@cn.fujitsu.com>
 <20161107170523.GR12522@twin.jikos.cz>
 <bef6db9e-c106-c31b-22a5-708d2ce1221b@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bef6db9e-c106-c31b-22a5-708d2ce1221b@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 10:27:59AM +0800, Qu Wenruo wrote:
> > Yes please. Third namespace for existing error bits is not a good
> > option. Move the I_ERR bits to start from 32 and use them in the low-mem
> > code that's been merged to devel.
> 
> I didn't see such fix in devel branch.

Well, that's because nobody implemented it and I was not intending to do
it myself as it's a followup to yor lowmem patchset in devel.
