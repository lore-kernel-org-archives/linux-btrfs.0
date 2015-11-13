Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37416 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbbKMKU4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 05:20:56 -0500
Message-ID: <5645B953.7080202@oracle.com>
Date: Fri, 13 Nov 2015 18:20:03 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com> <5644E6B5.9070405@inwind.it>
In-Reply-To: <5644E6B5.9070405@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for comments.

On 11/13/2015 03:21 AM, Goffredo Baroncelli wrote:
> On 2015-11-09 11:56, Anand Jain wrote:
>> These set of patches provides btrfs hot spare and auto replace support
>> for you review and comments.
>
> Hi Anand,
>
> is there any reason to put this kind of logic in the kernel space ?
> I think that it could be more simply to create a daemon which checks
 > the disks and when needed it starts a replace...

> The pool policy could be more sophisticated: some filesystem could
 > require a "dedicated" pool (for example because the disks are in the
 > same enclosure); in other case a global pool may be more useful.

  Thats true. It can be added as an enhancement on top of current
  implementation, I will, if time permits. Current priority is
  to have stability on what could possibly go wrong (in configuring)
  and how stable code towards it.

> Another feature of this daemon could be to add a disk when the disk
 > space is too low,

  That will be at the cost of a spare device which user should review
  the trade-offs and do it manually ? I am not sure.

> or to start a balance when there is no space to
 > allocate further chunk.....

  Yep. As you notice, the thread created here is casualty_kthread()
  (instead of replace_kthread()) over the long run I wish to provide
  that feature in this thread, as it is a mutually exclusive operations
  with replace.

> Of course all these logic could be implemented in kernel space,
 > but I think that we should avoid that when possible.

  Easy to handle the mutually_exclusive parts with in the kernel
  and Its better to have the important logic at one place. Two heads
  operating on an org looking and feeling different things will lead
  to wrong decisions.

> Moreover in  user space the logging is more easy....

Thanks, Anand
