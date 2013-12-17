Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27408 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053Ab3LQBTq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 20:19:46 -0500
From: Chris Mason <clm@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: move the extent buffer radix tree into the
 fs_info
Date: Tue, 17 Dec 2013 01:19:39 +0000
Message-ID: <1387243189.15080.2.camel@ret.masoncoding.com>
References: <1387218386-5339-1-git-send-email-jbacik@fb.com>
	 <20131217010627.GK6498@twin.jikos.cz>
In-Reply-To: <20131217010627.GK6498@twin.jikos.cz>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2013-12-17 at 02:06 +-0100, David Sterba wrote:
+AD4- On Mon, Dec 16, 2013 at 01:26:26PM -0500, Josef Bacik wrote:
+AD4- +AD4- I need to create a fake tree to test qgroups and I don't want to have to setup a
+AD4- +AD4- fake btree+AF8-inode.  The fact is we only use the radix tree for the fs+AF8-info, so
+AD4- +AD4- everybody else who allocates an extent+AF8-io+AF8-tree is just wasting the space anyway.
+AD4- +AD4- This patch moves the radix tree and its lock into btrfs+AF8-fs+AF8-info so there is less
+AD4- +AD4- stuff I have to fake to do qgroup sanity tests.  Thanks,
+AD4- 
+AD4- This would make the fs+AF8-info::buffer+AF8-lock a global hotspot if
+AD4- alloc+AF8-extent+AF8-buffer and release+AF8-extent+AF8-buffer are called frequently.
+AD4- 

But since the only place that was really using it was the metadata
btree, the lock shouldn't be hotter than before right?

-chris

