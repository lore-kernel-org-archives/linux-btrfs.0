Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47949 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3IKS4i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 14:56:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 1DF147C06AF
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 12:56:38 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id ISAmDu3KZSvu3dR3 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 12:56:37 -0600 (MDT)
Date: Wed, 11 Sep 2013 14:56:36 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: drop dir i_size when adding new names on replay
Message-ID: <20130911185636.GE2446@localhost.localdomain>
References: <1378923537-14722-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1378923537-14722-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 11, 2013 at 02:18:57PM -0400, Josef Bacik wrote:
> So if we have dir_index items in the log that means we also have the inode item
> as well, which means that the inode's i_size is correct.  However when we
> process dir_index'es we call btrfs_add_link() which will increase the
> directory's i_size for the new entry.  So to fix this just drop the name len
> size before we call btrfs_add_link() so the i_size ends out properly.  Thanks,
> 

Ignore this, it isn't quite right.  Thanks,

Josef
