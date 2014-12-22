Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:65228 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaLVXPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 18:15:50 -0500
Received: by mail-la0-f48.google.com with SMTP id gf13so4635491lab.21
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 15:15:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5498A0BD.3000300@pobox.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
	<54982A79.1090102@gmail.com>
	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>
	<54985E4C.40003@gmail.com>
	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
	<CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>
	<5498829E.3060608@gmail.com>
	<5498A0BD.3000300@pobox.com>
Date: Mon, 22 Dec 2014 15:15:47 -0800
Message-ID: <CAN05THTqyoVK6sH2JR9CTE77eHu_-um963r4M6jXJEUSWk7DJA@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 2:52 PM, Robert White <rwhite@pobox.com> wrote:
> On 12/22/2014 12:44 PM, Austin S Hemmelgarn wrote:
>>
>> On 2014-12-22 15:06, Richard Sharpe wrote:
>>>
>>> On Mon, Dec 22, 2014 at 10:43 AM, Chris Murphy
>>> <lists@colorremedies.com> wrote:
>>>>
>>>> On Mon, Dec 22, 2014 at 11:09 AM, Austin S Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>>> Personally, I'd love to see unlimited length xattr's like NTFS and
>>>>> HFS+ do,
>>>>> as that would greatly improve interoperability (both Windows and OS
>>>>> X use
>>>>> xattrs, although they call them 'alternative data streams' and 'forks'
>>>>> respectively), and provide a higher likelihood that xattrs would start
>>>>> getting used more.
>>>>
>>>>
>>>> This is two years old, but it looks like NFS will not support xattr.
>>>> http://comments.gmane.org/gmane.linux.nfs/53259
>>>>
>>>> It looks like SMB does support xattr (and sometimes requires it) but I
>>>> have no idea to what degree, including the host/client preservation on
>>>> different filesystems. [1] It would still be helpful for cp and rsync
>>>> to be able to preserve xattr, however Apple has moved to a new on-disk
>>>> format that makes the future of reading OS X volumes on Linux an open
>>>> question. [2]
>>>
>>>
>>> Those are the old OS 2 XATTRs, better known as EAs, and NTFS says that
>>> you can support EAs or you can have Reparse Points, but not both
>>> (basically, they re-used the EA Length field as the reparse tag).
>>> Also, Windows (of any flavor) does not make it easy to access EAs.
>>>
>> But OS/2 style XATTRS are not the same as NTFS Alternative Data Streams,
>> which technically (because of Windows backward compatibility interfaces)
>> don't need a huge amount of support from SMB.  They were originally
>> added to support SFM in NT3.1, so that windows could store resource
>> forks.  The two primary uses on windows today are the file history
>> interface in Win8/8.1 and the 'zone_identifier' saved with downloads by
>> most modern browsers.  They're actually pretty easy to get to, you just
>> append the ADS name to the end of the filename with a : separating them,
>> and you can access it like a regular file (which is part of why : isn't
>> a legal character in a windows filename).  Most people don't know about
>> them because they don't get listed in windows explorer, even with hidden
>> files and protected OS file visible.  The actual on-disk format for them
>> is actually kind of interesting, the file data itself (what in the Apple
>> world is called the Data Fork) is actually stored as an unnamed ADS
>> associated with the filename.
>>
>
> My stupid two cents...
>
> Wouldn't keeping a file history be "better" done with something git-like
> (monotonish? 8-) combined with an incron type file-watcher?
>
> So like a small xattr to link the file to the repository or something...
>
> setfattr --name=user.history_repo --value=/path/to/repository file
>
> and some not-in-the-kernel subsystems?

Atomicity.
NTFS/ADS snapshots are created atomically.

There is of course nothing that prevents the "separate file" +
setfattr "the path to the file"
from working, but it is inconvenient and somewhat ugly since you have
to implement your own
transaction and rollback mechanism every time :-(

What about if someone else modifies/renames/deletes '/path/to/repository file'
Can you prevent that? If not, how do you detect this and handle it
when 'user.history_repo'
no longer points to the right data?
You have to write code to handle it somehow.

It is a lot more convenient when this is a first class filesystem api
since you don't have to deal with it. The guy writing the filesystem
dealt with it for you.



Second really big benefit with the ADS approach is that once it is a
first class API
you don't need to rewrite all third party apps to understand the
mapping 'user.history_repo' => '/path/to/repository file'
If it is a standard filesystem feature, then you just update 'tar',
'rsync', 'scp', 'cp', 'mv', ...
once and it will work. You don;t need to re-implement this API in
these tools everytime
a new mapping is invented.

I.e. by having it as a standard API for the filesystem, you update the
external tools once and it will work reliably always,a cross all
filesystems (that support it).



>
> What is the practical use case for really large XATTRS that isn't solved by
> indirection to non-kernel facilities.

metadata
and
snapshots

>
> (That's not snark, I've been trying to figure out why _I_ would want that
> expanse of auxiliary data so inconveniently stored and I've come up with
> nothing. Maybe I lack imagination.)
>
> I see the ADS thing now that you mention it. Kinda neat way to recycle the
> otherwise much-disparaged colon-is-for-devices thing. But would that sort of
> thing match the Linux/POSIX expectation at all? Everything in *ix being a
> file, the chaos of expectation from the equivalent /dev/sda1:ADS (to make it
> a portmantu of sorts) becomes unfriendly.
>
>
> I've thought of some interesting things to do whit XATTRS (like a kernel
> patch to let an executable carry around environment overrides like a
> restricted/overridden PATH) or include the intended editor for use in a
> GUI/file-manager. I'm pretty sure I could get into the 32K range with that
> stuff. But "unbounded" seems a little high. 8-)
>
> So skipping the full ADS, what's the current demand/payoff for large XATTR
> space?
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
