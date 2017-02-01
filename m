Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:56816 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753178AbdBARni (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 12:43:38 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 149209B85C
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 17:43:33 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id BA6235FBB3
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 17:43:32 +0000 (GMT)
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
Date: Wed, 1 Feb 2017 17:43:32 +0000
MIME-Version: 1.0
In-Reply-To: <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/02/17 12:28, Austin S. Hemmelgarn wrote:
> On 2017-02-01 00:09, Duncan wrote:
>> Christian Lupien posted on Tue, 31 Jan 2017 18:32:58 -0500 as excerpted:
>>
>>> I have been testing btrfs send/receive. I like it.
>>>
>>> During those tests I discovered that it is possible to access and modify
>>> (add files, delete files ...) of the new receive snapshot during the
>>> transfer. After the transfer it becomes readonly but it could already
>>> have been modified.
>>>
>>> So you can end up with a source and a destination which are not the
>>> same. Therefore during a subsequent incremental transfers I can get
>>> receive to crash (trying to unlink a file that is not in the parent but
>>> should).
>>>
>>> Is this behavior by design or will it be prevented in the future?
>>>
>>> I can of course just not modify the subvolume during receive but is
>>> there a way to make sure no user/program modifies it?
>>
>> I'm just a btrfs-using list regular not a dev, but AFAIK, the behavior is
>> likely to be by design and difficult to change, because the send stream
>> is simply a stream of userspace-context commands for receive to act upon,
>> and any other suitably privileged userspace program could run the same
>> commands.  (If your btrfs-progs is new enough receive even has a dump
>> option, that prints the metadata operations in human readable form, one
>> operation per line.)
>>
>> So making the receive snapshot read-only during the transfer would
>> prevent receive itself working.
> That's correct.  Fixing this completely would require implementing
> receive on the kernel side, which is not a practical option for multiple
> reasons.

I am with Christian on this. Both the effects he discovered go against
my expectation of how send/receive would or should work.

This first bug is more serious because it appears to allow a
non-privileged user to disrupt the correct operation of receive,
creating a form of denial-of-service of a send/receive based backup
process. If I decided that I didn't want my pron collection (or my
incriminating emails) appearing in the backups I could just make sure
that I removed them from the receive snapshots while they were still
writeable.

You may be right that fixing this would require receive in the kernel,
and that is undesirable, although it seems to me that it should be
possible to do something like allow receive to create the snapshot with
a special flag that would cause the kernel to treat it as read-only to
any requests not delivered through the same file descriptor, or
something like that (or, if that can't be done, at least require root
access to make any changes). In any case, I believe it should be treated
as a bug, even if low priority, with an explicit warning about the
possible corruption of receive-based backups in the btrfs-receive man page.

>>> I can also get in the same kind of trouble by modifying a parent (after
>>> changing its property temporarily to ro=false). send/receive is checking
>>> that the same parent uuid is available on both sides but not that
>>> generation has not changed. Of course in this case it requires direct
>>> user intervention. Never changing the ro property of subvolumes would
>>> prevent the problem.
>>>
>>> Again is this by design?
>>
>> Again, yes.  The ability to toggle snapshots between ro/rw is a useful
>> feature and was added deliberately.  This one would seem to me to be much
>> like the (no doubt apocryphal) guy who went to the doctor complaining
>> that when he beat his head against the wall, it hurt.  The doctor said,
>> "Stop doing that then."
> Agreed, especially considering that some of the most interesting
> use-cases for send/receive (which requires the sent subvolume to be
> read-only) require the subvolume to be made writable again on the other
> end.

I agree that there are good reasons why subvolumes should be switchable
between ro and rw. However, receive should detect and issue warnings
when this problem has happened (for example by checking the generation).
Again, this may be low priority, and may need to wait for a send stream
format change, but it can't be claimed that this is correct behaviour.

Graham
