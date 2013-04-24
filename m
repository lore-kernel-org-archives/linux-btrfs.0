Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:52698 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3DXI0Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 04:26:24 -0400
Message-ID: <5177972C.8040009@jan-o-sch.net>
Date: Wed, 24 Apr 2013 10:26:20 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: separate sequence numbers for delayed ref tracking
 and tree mod log
References: <1366740027-27627-1-git-send-email-list.btrfs@jan-o-sch.net> <20130424081236.GE19283@liubo.jp.oracle.com>
In-Reply-To: <20130424081236.GE19283@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, April 24, 2013 at 10:12 (+0200), Liu Bo wrote:
> On Tue, Apr 23, 2013 at 08:00:27PM +0200, Jan Schmidt wrote:
>> Sequence numbers for delayed refs have been introduced in the first version
>> of the qgroup patch set. To solve the problem of find_all_roots on a busy
>> file system, the tree mod log was introduced. The sequence numbers for that
>> were simply shared between those two users.
> 
> Can't we just separate them with two vars?

My reasoning comes a few lines below ...

> thanks,
> liubo
> 
>>
>> However, at one point in qgroup's quota accounting, there's a statement
>> accessing the previous sequence number, that's still just doing (seq - 1)
>> just as it had to in the very first version.
>>
>> To satisfy that requirement, this patch makes the sequence number counter 64
>> bit and splits it into a major part (used for qgroup sequence number
>> counting) and a minor part (incremented for each tree modification in the
>> log). This enables us to go exactly one major step backwards, as required
>> for qgroups, while still incrementing the sequence counter for tree mod log
>> insertions to keep track of their order. Keeping them in a single variable
>> means there's no need to change all the code dealing with comparisons of two
>> sequence numbers.

See the previous sentence :-)

And, it doesn't add too much complexity, setting and incrementing remains in
fact quite easy, even though we use the upper 32 bit and the lower 32 bit of
that integer independently.

Thanks,
-Jan

>>
>> The sequence number is reset to 0 on commit (not new in this patch), which
>> ensures we won't overflow the two 32 bit counters.
>>
>> Without this fix, the qgroup tracking can occasionally go wrong and WARN_ONs
>> from the tree mod log code may happen.
>>
>> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
>> ---
>> [snip]
