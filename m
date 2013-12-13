Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43810 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3LMGEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 01:04:30 -0500
Date: Fri, 13 Dec 2013 14:04:21 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v7 04/13] Btrfs: disable qgroups accounting when
 quata_enable is 0
Message-ID: <20131213060420.GB14429@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
 <1381726796-27191-5-git-send-email-bo.li.liu@oracle.com>
 <CAOcd+r17jar_CxrYhwQX4eeKLiFgjHDuLdptes04gG_LXtozrg@mail.gmail.com>
 <20131213054256.GA14429@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131213054256.GA14429@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 01:42:57PM +0800, Liu Bo wrote:
> On Tue, Dec 03, 2013 at 07:13:48PM +0200, Alex Lyakas wrote:
> > Hi Liu, Jan,
> > 
> > What happens to "struct qgroup_update"s sitting in
> > trans->qgroup_ref_list in case the transaction aborts? It seems that
> > they are not freed.
> > 
> > For example, if we are in btrfs_commit_transaction() and:
> > - call create_pending_snapshots()
> > - call btrfs_run_delayed_items() and this fails
> > So we go to cleanup_transaction() without calling
> > btrfs_delayed_refs_qgroup_accounting(), which would have been called
> > by btrfs_run_delayed_refs().
> > 
> > I receive kmemleak warnings about these thingies not being freed,
> > although on an older kernel. However, looking at Josef's tree, this
> > still seems to be the case.
> 
> I think you're right, but I'm sure because I cannot reproduce that somehow,

Sorry, s/'sure'/'not sure'/g

-liubo
