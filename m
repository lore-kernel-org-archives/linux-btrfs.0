Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:51644 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2GIPvs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 11:51:48 -0400
Message-ID: <4FFAFE11.1080105@inwind.it>
Date: Mon, 09 Jul 2012 17:51:45 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] Btrfs "sendshots" and hidden snapshots
References: <CAB9VWqCnbd-Mqo6Po408uqhbbSyg=W4Huiqs61HLxc8=nkdQdQ@mail.gmail.com> <4FF61669.9080605@libero.it> <CAB9VWqBcZNc7unKA9sFC9nUrBgCB=G3tsDy89QXiQBmdvzbkwA@mail.gmail.com> <20120706115524.GH7159@shiny> <4FF6D41A.5050102@libero.it> <CAB9VWqAhU_HEL4qPqO5Ks=pg6xnGJ5es+roTSe6MsuT485TBJA@mail.gmail.com>
In-Reply-To: <CAB9VWqAhU_HEL4qPqO5Ks=pg6xnGJ5es+roTSe6MsuT485TBJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/2012 02:45 PM, Alexander Block wrote:
> On Fri, Jul 6, 2012 at 2:03 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> On 07/06/2012 01:55 PM, Chris Mason wrote:
>>> On Fri, Jul 06, 2012 at 02:51:43AM -0600, Alexander Block wrote:
>>>> On Fri, Jul 6, 2012 at 12:34 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>>>>> On 07/05/2012 06:51 PM, Alexander Block wrote:
>>>>>> Hello all,
>>>>>>
>>>>>> in IRC we had a discussion on how we could solve sending live
>>>>>> subvolumes and how to send subvolumes without the need to
>>>>>> administrate/keep old snapshots for incremental sends. One of the
>>>>>> ideas was to introduce "sendshots", which are basically snapshots
>>>>>> where no refs are counted for file data. This means, that when file
>>>>>> data is changed in the sendshot origin, we do not consume extra space
>>>>>> for two copies of the data. We would only have the metadata
>>>>>> duplicated.
>>>>>>
>>>>>> For the initial btrfs send we could do this:
>>>>>> 1. Create a hidden read-only snapshot of the subvolume to send. Hidden
>>>>>> means that it's not referenced by any subvolume. It is however still a
>>>>>> normal snapshot (not a sendshot!). Hidden snapshots are not possible
>>>>>> atm so we would have to implement that. This step allows us to send
>>>>>> read-write subvolumes, because we have a freezed version of it.
>>>>>
>>>>> Why we should want/need an hidden snapshot ? We could put this kind of
>>>>> hidden snapshot under a directory dot-prefixed (like /.hidden-subvolumes)
>>>> That would have the problem that the user may modify the subvolume
>>>> in-between (by removing the ro flag). Or he could simple cd into it
>>>> and we would later fail to delete it.
>>>
>>> I prefer to make this more explicit.  We could add a hard-readonly flag
>>> that cannot be cleared.  Having the snapshot show in the FS lets the
>>> admin know what things are really using space.
> Yepp sounds like a better solution then hidden snapshots. Or, we could
> protect against RO flag changes while performing the send.
>>
>>
>> Me too, but I am guessing what should happens when the users try to read
>> an old data ? (I am talking about sendshot ). If I understood correctly
>> the old data isn't tracked by the sendshot.
> Two possible solutions that I see:
> 1. Hidden sendshots :P
> 2. Reading files from a sendshot will always give dummy data (e.g. all
> zero). But I really can't estimate how hard this is to implement.

>From an user point of view, this would be a nightmare. Two similar
filesystem with no obvious differences....

I suggest that the sendshot appears as empty read only subvolume. So all
the btrfs subvolumes semantic could be applied (btrfs subvolume delete,
btrfs sublume list, btrfs send, btrfs receive ) and the user cannot read
false data. We could mark this with a specific inode number:currently
all subvolume have inode number=256, we could use 255 or similar (I
don't know if this could raise some problem however ).

Otherwise we need to create a separate namespace for this kind of
subvolume (which could be a solution for other kinds of problems), for
example under /sys.

GB

>>
>> GB
> .
> 

