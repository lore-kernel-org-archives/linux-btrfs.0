Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:53365 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab2FVO05 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 10:26:57 -0400
Message-ID: <4FE480B0.50201@jan-o-sch.net>
Date: Fri, 22 Jun 2012 16:26:56 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: "Chris L. Mason" <clmason@fusionio.com>
Subject: Re: Deadlock in ctree.c?
References: <4FE45064.4090104@jan-o-sch.net> <4FE47372.6070101@fusionio.com> <4FE47563.8090102@jan-o-sch.net> <4FE47FD6.9010205@fusionio.com>
In-Reply-To: <4FE47FD6.9010205@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, June 22, 2012 at 16:23 (+0200), Josef Bacik wrote:
> On 06/22/2012 09:38 AM, Jan Schmidt wrote:
>> On Fri, June 22, 2012 at 15:30 (+0200), Josef Bacik wrote:
>>> l2 shouldn't be locked anymore, if we're in push_leaf_left it's because we
>>> cow'ed l2 and are holding a lock on it, so really it has a lock on l2' and the
>>> btrfs_next_leaf is trying to get a lock on l2 which it should be free to do.
>>
>> Each tree block is cowed only once per transaction, right? Lets assume l2 was
>> cowed before any of the above threads started, we should end up with a lock on
>> l2 even in push_leaf_left, because should_cow_block returns 0.
>>
> 
> Except you'd never get to l2 in the case that it had already been cow'ed.  Thanks,

Thank you :-) That's the missing bit.

-Jan
