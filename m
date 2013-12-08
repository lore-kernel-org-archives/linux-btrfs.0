Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:54053 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3LHAcK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Dec 2013 19:32:10 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so841370bkz.39
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 16:32:09 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAEzrpqfGNbFQ8wG7SWVJOp3pM3BwfAdO79VrOK-t9JiUFNCkUQ@mail.gmail.com>
References: <20131129154525.GN25312@twin.jikos.cz>
	<CAL3q7H7CmaKsnQQacpZck3zGV35ikhTwqX=Xg9eAiM97kb5TwA@mail.gmail.com>
	<20131203164344.GW25312@twin.jikos.cz>
	<CAEzrpqfGNbFQ8wG7SWVJOp3pM3BwfAdO79VrOK-t9JiUFNCkUQ@mail.gmail.com>
Date: Sun, 8 Dec 2013 00:32:08 +0000
Message-ID: <CAL3q7H4RGpAc1_Gedq6GeqK3HDZ3=asLHUk8Vn=_JYd56K6ufw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: optimize btrfs_lookup_extent_info() - extent
 refcount mismatches?
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        clm@fb.com, jbacik@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 3, 2013 at 6:28 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> On Tue, Dec 3, 2013 at 8:43 AM, David Sterba <dsterba@suse.cz> wrote:
>> On Fri, Nov 29, 2013 at 07:55:37PM +0000, Filipe David Manana wrote:
>>> On Fri, Nov 29, 2013 at 3:45 PM, David Sterba <dsterba@suse.cz> wrote:
>>> > Hi,
>>> >
>>> > On Fri, Jul 05, 2013 at 09:32:05PM +0100, Filipe David Borba Manana wrote:
>>> >> If we're looking for a metadata item in the tree and the
>>> >> search fails with return value of 1, and the slot doesn't
>>> >> point to the first item in the leaf, check if the previous
>>> >> item in the leaf corresponds to an extent item for the same
>>> >> object id - if it does, then don't do another tree search
>>> >> to get it.
>>> >
>>> > I'm suspecting this patch to cause some trouble, see
>>> > https://bugzilla.kernel.org/show_bug.cgi?id=64961
>>>
>>> What makes you believe the problem is exactly in this function?
>>
>> It was a first guess based on the stacktraces and last patch that
>> touched the code. I've replied to mailinlist because it has higher
>> visibility, number of bugreports in balance/relocation has been
>> increasing lately (not blaming you).
>>
>>> I read it again, and I can't see how it can miss an extent item that
>>> it couldn't before, specially without skinny metadata enabled.  Did
>>> the fs had skinny metadata enabled?
>>
>> According to the updated bugzilla yes, and that's another possible
>> cause although we haven't seen bugs with skinny metadata yet. There's
>> another bugreport that has them enabled,
>> https://bugzilla.kernel.org/show_bug.cgi?id=66411

I found an issue in btrfs_lookup_extent_info() when skinny metadata is
enabled. It can actually miss existing skinny extent items.
The following patch fixes it and explains in detail the issue:

https://patchwork.kernel.org/patch/3305521/

thanks

>>
>
> I've been seeing similar issues while testing my qgroups patches that
> I don't think is related to my qgroup work.  I'm going to try and
> track it down this week but I may not get to it until next week.
> Thanks,
>
> Josef



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
