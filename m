Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2820 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab3KBEib (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Nov 2013 00:38:31 -0400
Message-ID: <527480F5.1010304@cn.fujitsu.com>
Date: Sat, 02 Nov 2013 12:35:01 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner accounting
 (bug #61951)
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net> <801531AB-DF1E-44AC-B58E-D0388C7FCC55@gmail.com> <52737175.6020906@jan-o-sch.net>
In-Reply-To: <52737175.6020906@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan, Arne

On 11/01/2013 05:16 PM, Jan Schmidt wrote:
> I've understood the problem this reproducer creates. In fact, you can shorten it
> dramatically. The story of qgroups is going to turn awkward at this point.
>
> mkfs and enable quota, put some data in (needs a level 2 tree)
> -> this accounts rfer and excl for qgroup 5
>
> take a snapshot
> -> this creates qgroup 257, which gets rfer(257) = rfer(5) and excl(257) = 0,
> excl(5) = 0.
>
> now make sure you don't cow anything (which we always did in our extensive
> tests), just drop the newly created snapshot.
> -> excl(5) ought to become what it was before the snapshot, and there's no code
> for this. This is because there is node code that brings rfer(257) to zero, the
> data extents are not touched because the tree blocks of 5 and 257 are shared.
>
> Drop tree does not go down the whole tree, when it finds a tree block with
> refcnt > 1 it just decrements it and is done. This is very efficient but is bad
> the qgroup numbers.
>
> We have got three possibile solutions in mind:
>
> A: Always walk down the whole tree for quota-enabled fs tree drops. Can be done
> with the read-ahead code, but is potentially a whole lot of work for large file
> systems.
>
> B: Use tracking qgroups as required for several operations on higher level
> qgroups also for the level 0 qgroups. They could be created automatically and
> track the correct numbers just in case a snapshot is deleted. The problem with
> that approach is that it does not scale for a large number of subvolumes, as you
> need to track each possible combination of all subvolumes (exponential costs).
>
> C: Make sure all your metadata is cowed before dropping a subvolume. This is
> explicitly doing what solution A would do implicitly, but can theoretically be
> done by the user. I don't consider C a practical solution.
Qgroup's exclusive size is an important feature to know a subvolume's 
sole size.
However, it really brings a lot of problems.

1> To differ refer and exclusive size, we have to walk backref to find 
all root
for a backref in a point,find_all_root() can slow down btrfs if there 
are a lot of
snapshots...

2> some people complain that with qgroup enabled, system memory cost
become extremely high, this maybe related to qgroup tracking for delayed
refs.

3> Deleting a subvolume/Snapshot can make btrfs qgroup tracking wrong,
we haven't found an effective way to solve this problem.

So maybe we should remove qgroup's exclusive or add an option to disable
qgroup's exclusive size, this will make life easier, considering:

1> we don't have to walk backref, calling find_all_root() will be avoided.

2> system memory high cost maybe be avoided.

3> When deleting a subvolume, we just destroy its qgroup.

If there are no objections against it, i'd like to add it my todo list.:-P

Thanks,
Wang
> Sigh.
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>

