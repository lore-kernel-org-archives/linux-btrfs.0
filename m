Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51018 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaJJPTA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 11:19:00 -0400
Received: by mail-ig0-f174.google.com with SMTP id a13so3134475igq.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 08:18:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5437BF23.6030000@shiftmail.org>
References: <54358C77.2070808@redhat.com>
	<9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
	<5437BAB2.1040605@shiftmail.org>
	<20141010165902.36262e8e@natsu>
	<5437BF23.6030000@shiftmail.org>
Date: Fri, 10 Oct 2014 09:18:58 -0600
Message-ID: <CAE5mzvgGjM_LUS7GBk2Y6JAo2ci5vF3jiSsmNowObMPZBqykGQ@mail.gmail.com>
Subject: Re: What is the vision for btrfs fs repair?
From: cwillu <cwillu@cwillu.com>
To: Bob Marley <bobmarley@shiftmail.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If -o recovery is necessary, then you're either running into a btrfs
bug, or your hardware is lying about when it has actually written
things to disk.

The first case isn't unheard of, although far less common than it used
to be, and it should continue to improve with time.

In the second case, you're potentially screwed regardless of the
filesystem, without doing hacks like "wait a good long time before
returning from fsync in the hopes that the disk might actually have
gotten around to performing the write it said had already finished."

On Fri, Oct 10, 2014 at 5:12 AM, Bob Marley <bobmarley@shiftmail.org> wrote:
> On 10/10/2014 12:59, Roman Mamedov wrote:
>>
>> On Fri, 10 Oct 2014 12:53:38 +0200
>> Bob Marley <bobmarley@shiftmail.org> wrote:
>>
>>> On 10/10/2014 03:58, Chris Murphy wrote:
>>>>>
>>>>> * mount -o recovery
>>>>>         "Enable autorecovery attempts if a bad tree root is found at
>>>>> mount time."
>>>>
>>>> I'm confused why it's not the default yet. Maybe it's continuing to
>>>> evolve at a pace that suggests something could sneak in that makes things
>>>> worse? It is almost an oxymoron in that I'm manually enabling an
>>>> autorecovery
>>>>
>>>> If true, maybe the closest indication we'd get of btrfs stablity is the
>>>> default enabling of autorecovery.
>>>
>>> No way!
>>> I wouldn't want a default like that.
>>>
>>> If you think at distributed transactions: suppose a sync was issued on
>>> both sides of a distributed transaction, then power was lost on one
>>> side
>>
>> What distributed transactions? Btrfs is not a clustered filesystem[1], it
>> does
>> not support and likely will never support being mounted from multiple
>> hosts at
>> the same time.
>>
>> [1]http://en.wikipedia.org/wiki/Clustered_file_system
>>
>
> This is not the only way to do a distributed transaction.
> Databases can be hosted on the filesystem, and those can do distributed
> transations.
> Think of two bank accounts, one on btrfs fs1 here, and another bank account
> on database on a whatever filesystem in another country. You want to debit
> one account and credit the other one: the filesystems at the two sides *must
> not rollback their state* !! (especially not transparently without human
> intervention)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
