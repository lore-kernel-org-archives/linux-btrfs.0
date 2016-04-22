Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbcDVSVu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 14:21:50 -0400
Date: Fri, 22 Apr 2016 11:21:48 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fdmanana@suse.com
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
Message-ID: <20160422182148.GZ2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
 <571A697B.6050502@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <571A697B.6050502@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2016 at 02:12:11PM -0400, Josef Bacik wrote:
> On 04/15/2016 05:08 AM, Qu Wenruo wrote:
> >+	/*
> >+	 * Force parent root to be updated, as we recorded it before so its
> >+	 * last_trans == cur_transid.
> >+	 * Or it won't be committed again onto disk after later
> >+	 * insert_dir_item()
> >+	 */
> >+	if (!ret)
> >+		record_root_in_trans(trans, parent, 1);
> >+	return ret;
> >+}
> 
> NACK, holy shit we aren't adding a special transaction commit only
> for qgroup snapshots.  Figure out a different way.  Thanks,

Yeah I saw that. To be fair, we run a whole lot of the transaction stuff
multiple times (at least from my reading) so I'm really unclear on what the
performance impact is.

Do you have any suggestion though? We've been banging our heads against this
for a while now and as slow as this patch might be, it actually works where
nothing else has so far.
	--Mark

--
Mark Fasheh
