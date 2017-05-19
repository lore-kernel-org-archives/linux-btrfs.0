Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753169AbdESNJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 09:09:20 -0400
Date: Fri, 19 May 2017 15:08:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] btrfs: scrub: use bool for flush_all_writes
Message-ID: <20170519130822.GU4065@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1494954480.git.dsterba@suse.com>
 <0d4dcd2dd113cdff9141336e583ab5afacfeee6f.1494954480.git.dsterba@suse.com>
 <20170519004224.GK23822@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170519004224.GK23822@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 05:42:24PM -0700, Liu Bo wrote:
> On Tue, May 16, 2017 at 07:10:38PM +0200, David Sterba wrote:
> > flush_all_writes is an atomic but does not use the semantics at all,
> > it's just on/off indicator, we can use bool.
> > 
> 
> It might use atomic to avoid reordering, but I'm not sure if
> reordering could really happen here.

Ok, I'll have a look. It does not seem to rely on atomics/ordering though.
