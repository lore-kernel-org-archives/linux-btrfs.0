Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33655 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbcIIQ6j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 12:58:39 -0400
Received: by mail-oi0-f54.google.com with SMTP id y2so152698754oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Sep 2016 09:58:39 -0700 (PDT)
Subject: Re: Security implications of btrfs receive?
To: dsterba@suse.cz, Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
 <20160909161843.GY16983@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <75086f33-fb47-a6ce-213e-cf423fa3dcea@gmail.com>
Date: Fri, 9 Sep 2016 12:58:35 -0400
MIME-Version: 1.0
In-Reply-To: <20160909161843.GY16983@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-09 12:18, David Sterba wrote:
> On Wed, Sep 07, 2016 at 07:58:30AM -0400, Austin S. Hemmelgarn wrote:
>> On 2016-09-06 13:20, Graham Cobb wrote:
>>> Thanks to Austin and Duncan for their replies.
>>>
>>> On 06/09/16 13:15, Austin S. Hemmelgarn wrote:
>>>> On 2016-09-05 05:59, Graham Cobb wrote:
>>>>> Does the "path" argument of btrfs-receive mean that *all* operations are
>>>>> confined to that path?  For example, if a UUID or transid is sent which
>>>>> refers to an entity outside the path will that other entity be affected
>>>>> or used?
>>>> As far as I know, no, it won't be affected.
>>>>> Is it possible for a file to be created containing shared
>>>>> extents from outside the path?
>>>> As far as I know, the only way for this to happen is if you're
>>>> referencing a parent subvolume for a relative send that is itself
>>>> sharing extents outside of the path.  From a practical perspective,
>>>> unless you're doing deduplication on the receiving end, the this
>>>> shouldn't be possible.
>>>
>>> Unfortunately that is not the case.  I decided to do some tests to see
>>> what happens.  It is possible for a receive into one path to reference
>>> and access a subvolume from a different path on the same btrfs disk.  I
>>> have created a bash script to demonstrate this at:
>>>
>>> https://gist.github.com/GrahamCobb/c7964138057e4e092a75319c9fb240a3
>>>
>>> This does require the attacker to know the (source) subvolume UUID they
>>> want to copy.  I am not sure how hard UUIDs are to guess.
>> Oh, I forgot about the fact that it checks the whole filesystem for
>> referenced source subvolumes.
>
> What if the stream is verified first? Ie. look if there are the
> operations using subolumes not owned by the user.
>
I think that extending the ioctl to require proof of access to the 
source being cloned from would be a better approach to this, as this is 
an issue with the ioctl in general, it's just discussion of send/receive 
that brought this up.  I'm actually kind of surprised that this didn't 
get noticed before, seeing as it's a pretty significant and not all that 
difficult to use information leak.  Ideally, this needs to be decided 
before the VFS layer clone ioctl gets finalized.
