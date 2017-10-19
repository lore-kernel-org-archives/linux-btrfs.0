Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58333 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751868AbdJSPrg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 11:47:36 -0400
Date: Thu, 19 Oct 2017 17:45:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: qgroup: show subvol path when qgroup show
Message-ID: <20171019154548.GM3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010083709.30690-1-lufq.fnst@cn.fujitsu.com>
 <20171016185511.GW3521@twin.jikos.cz>
 <20171018033621.GD495@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171018033621.GD495@fnst.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 18, 2017 at 11:36:21AM +0800, Lu Fengqi wrote:
> >> @@ -1140,7 +1249,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
> >>  					goto skip;
> >>  				add_qgroup(qgroup_lookup,
> >>  					   btrfs_search_header_offset(sh), 0,
> >> -					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
> >> +					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1,
> >> +					   NULL);
> >
> >Oh no, yet another argument, so it's 15 in total.
> 
> So many arguments are really hard to accept, I will rework this.

This could be done independent of this patch, but the cleaning up this
area is highly desired.
