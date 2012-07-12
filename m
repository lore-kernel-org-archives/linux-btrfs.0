Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:42381 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab2GLRFZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 13:05:25 -0400
Date: Thu, 12 Jul 2012 13:05:21 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "daniel@quora.org" <daniel@quora.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "sensille@gmx.net" <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: allow delayed refs to be merged
Message-ID: <20120712170521.GE2059@localhost.localdomain>
References: <1341946331-18058-1-git-send-email-jbacik@fusionio.com>
 <4FFD7D61.8070502@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FFD7D61.8070502@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2012 at 07:19:29AM -0600, Jan Schmidt wrote:
> Hi Josef,
> 
> I hit a warning with this patch on top of the current cmason/for-linus
> branch. Takes about 15 minutes to produce when running xfstest 278 in
> a loop and, in another shell, doing fsstress on the same volume to
> force metadata modifications.
> 
> fs/btrfs/extent-tree.c
> ...
> 5032         } else if (ret == -ENOENT) {
> 5033                 btrfs_print_leaf(extent_root, path->nodes[0]);
> 5034                 WARN_ON(1);
> 5035                 printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
> 5036                        "parent %llu root %llu  owner %llu offset %llu\n",
> 5037                        (unsigned long long)bytenr,
> 5038                        (unsigned long long)parent,
> 5039                        (unsigned long long)root_objectid,
> 5040                        (unsigned long long)owner_objectid,
> 5041                        (unsigned long long)owner_offset);
> 5042         } else {
> 

Which test, 278 is an xfs specific test.  Thanks,

Josef
