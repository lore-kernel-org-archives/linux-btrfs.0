From: jim owens <jowens@hp.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 09:58:54 -0400
Message-ID: <49F70B9E.7040107@hp.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> 	<1240839448.26451.13.camel@think.oraclecorp.com> <20090428052215.GA22921@cip.informatik.uni-erlangen.de> 	<1240912971.2149.5.camel@think.oraclecorp.com> <2a31deca0904280649w29d9cca8re9c0abc910ff99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0904280649w29d9cca8re9c0abc910ff99@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Andrey Kuzmin wrote:
> On Tue, Apr 28, 2009 at 2:02 PM, Chris Mason <chris.mason@oracle.com> wrote:
>> On Tue, 2009-04-28 at 07:22 +0200, Thomas Glanzmann wrote:
>>> Hello Chris,
>>>
>>>> There is a btrfs ioctl to clone individual files, and this could be used
>>>> to implement an online dedup.  But, since it is happening from userland,
>>>> you can't lock out all of the other users of a given file.
>>>> So, the dedup application would be responsible for making sure a given
>>>> file was not being changed while the dedup scan was running.
>>> I see, does that mean that I can not do ,,dedup'' for files that are
>>> currently opened by a userland program?
>> No, but it does mean the dedup done from userland is racey.  Picture
> 
> Race disappears if (background) dedupe is run against snapshot(s).

only if the snapshots are made read-only.

btrfs has writable snapshots.

jim

> 
> Regards,
> Andrey
> 
>> this:
>>
>> process A:
>>    create some_file # some_file matches the contents of another file
>>
>> dedup proc:
>>    check some_file
>>    decide to start block dedup
>>
>> process A:
>>     modify some_file
>>
>> dedup proc:
>>     progress through block dedup
>>
>> So, this will happily replace blocks in some_file with the dedup blocks.
>> But there's no way to atomically swap them.
>>
>> We could create new ioctls for this, basically a variant of the clone
>> file ioctl that makes sure a given set of pages has a given sum (or
>> strict memory contents) before doing the swap.
>>
>> But they don't exist yet.
>>
>> -chris
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

