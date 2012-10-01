Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49920 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab2JAQpS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Oct 2012 12:45:18 -0400
Date: Mon, 1 Oct 2012 12:45:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
Message-ID: <20121001164514.GA2370@localhost.localdomain>
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
 <CAHf9xvbZTizo6nbDbX8vjbT2RrwzPm=JMm-ms2MB-SVVcDKRhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHf9xvbZTizo6nbDbX8vjbT2RrwzPm=JMm-ms2MB-SVVcDKRhQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 30, 2012 at 05:28:23AM -0600, Alex Lyakas wrote:
> Hi Josef,
> I guess I am missing something, but I thought btrfs_next_leaf() should
> just jump to the next leaf (or item, if it was added meanwhile)
> irrespective of the key that is in the last slot of the current leaf.
> The change you added is effective when there is a next leaf, but you
> refuse to go there unless its first key has the same objectid. (I
> think you use the ctree property that the key in the first node/leaf
> of a tree block is equal to its parent's key).
> Can you pls explain why you insist on the same objectid?
> 

It's to avoid another search forward.  Unless I missed something everybody who
calls btrfs_next_leaf() only wants to walk forward based on a particular item.
If I've missed something and that's not the case then this needs to be dropped,
or we can set some flag in path to ignore this logic, either way.  Thanks,

Josef
