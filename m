Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:51661 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030314Ab2GFMAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 08:00:49 -0400
Message-ID: <4FF6D36E.7000201@libero.it>
Date: Fri, 06 Jul 2012 14:00:46 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: kreijack@inwind.it, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Btrfs "sendshots" and hidden snapshots
References: <CAB9VWqCnbd-Mqo6Po408uqhbbSyg=W4Huiqs61HLxc8=nkdQdQ@mail.gmail.com> <4FF61669.9080605@libero.it> <CAB9VWqBcZNc7unKA9sFC9nUrBgCB=G3tsDy89QXiQBmdvzbkwA@mail.gmail.com>
In-Reply-To: <CAB9VWqBcZNc7unKA9sFC9nUrBgCB=G3tsDy89QXiQBmdvzbkwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/2012 10:51 AM, Alexander Block wrote:
> On Fri, Jul 6, 2012 at 12:34 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> On 07/05/2012 06:51 PM, Alexander Block wrote:
>>> Hello all,
>>>
[....]
>>> When we later do an incremental send we can do this:
>>> 1. Do the same as point 1. from above.
>>> 2. Determine which of the previous sendshots is the correct one for
>>> the incremental send. We could use some magic auto detection here or
>>> the user has to specify it by himself.
>>> 3. Use the hidden snapshot from 1. and the determined sendshot from 2.
>>> to find the incremental changes and do the send.
>>
>> I can understand how a sendshot could be used to compute the metadata
>> delta. But how compute the data delta ?
> We still would have the file extent data found in the metadata. When
> we see that logical addresses or generations have changed, we know the
> data has changed. This may however be problematic in case a defrag or
> balance was performed, for this we should probably introduce a data
> only transid or something like that which is preserved on such
> operations.

Yes, this makes sense. The data that has to be collected is only the new
one, if I can track which data is changed (comparing the extent data )
then I need only the new data.

>>


