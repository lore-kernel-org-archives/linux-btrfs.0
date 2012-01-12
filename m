From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH v2 0/3] Btrfs: apply the Probabilistic Skiplist on btrfs
Date: Thu, 12 Jan 2012 13:28:12 -0800
Message-ID: <m21ur4sj9v.fsf@firstfloor.org>
References: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>,
	<josef@redhat.com>, <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com> (Liu
	Bo's message of "Tue, 10 Jan 2012 15:31:33 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo <liubo2009@cn.fujitsu.com> writes:
>
> Here we choose extent_map firstly, since it is a "read mostly" thing,
> and the change is quite direct, all we need to do is
> a) to replace rbtree with skiplist,
> b) to add rcu support.
> And more details are in patch 2 and patch 3.
>
> I've done some simple tests for performance on my 2-core box, there is no
> obvious difference, but I want to focus on the design side and make sure
> there is no more bug in it firstly.
>
> For long term goals, we want to ship skiplist to lib, like lib/rbtree.c.

I looked at skiplists some time ago. What made them awkward for kernel
use is that you have to size the per node skip array in advance and it's
hard to resize. So you have a node that wastes memory in common small
cases, but still degenerates to linked list on very large sizes.
With fine grained locking it gets even worse because the nodes get larger.

Con didn't worry about this problem because he assumed the scheduler
run queues never could get too long.

But for a very scalable subsystem that's definitely a problem.

I think skiplists are not a good fit here.

At least in our tests the older style trees got a lot better with Chris'
recent locking improvements. 

Now replacing rbtrees is probably still a good idea, but not convinced
skiplist are suitable here. There were various other tree alternatives
with better locking.

-Andi
