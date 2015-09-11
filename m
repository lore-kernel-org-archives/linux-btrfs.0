Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbbIKUnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 16:43:47 -0400
Date: Fri, 11 Sep 2015 13:43:45 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: keep dropped roots in cache until transaciton
 commit
Message-ID: <20150911204345.GU1145@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1441916850-19021-1-git-send-email-jbacik@fb.com>
 <55F22D85.8010004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55F22D85.8010004@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 11, 2015 at 09:25:25AM +0800, Qu Wenruo wrote:
> Josef Bacik wrote on 2015/09/10 16:27 -0400:
> >When dropping a snapshot we need to account for the qgroup changes.  If we drop
> >the snapshot in all one go then the backref code will fail to find blocks from
> >the snapshot we dropped since it won't be able to find the root in the fs root
> >cache.  This can lead to us failing to find refs from other roots that pointed
> >at blocks in the now deleted root.  To handle this we need to not remove the fs
> >roots from the cache until after we process the qgroup operations.  Do this by
> >adding dropped roots to a list on the transaction, and letting the transaction
> >remove the roots at the same time it drops the commit roots.  This will keep all
> >of the backref searching code in sync properly, and fixes a problem Mark was
> >seeing with snapshot delete and qgroups.  Thanks,Btrfs: keep dropped roots in
> >cache until transaciton commit
> 
> Mark will definitely be happy with this patch, as quite a good basis
> for snapshot deletion.

Indeed. My tests against a kernel with Josefs patches and my snapshot
deletion code seem to be passing. I'll have something on the list shortly.

Thanks,
	--Mark

--
Mark Fasheh
