Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34619 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbcHFU0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2016 16:26:25 -0400
Received: by mail-vk0-f41.google.com with SMTP id s189so214692744vkh.1
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Aug 2016 13:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <07b886b6-750b-26c4-dd47-cdae94e48dad@gmail.com>
References: <CAOZhre2ZytraEyHzVb1zY6FmAJUC4xun0fpWRQS=Z8ZKWff0jg@mail.gmail.com>
 <ccd46545-b433-1ff5-21d1-dd1bd7dd3e9f@gmail.com> <CAOZhre1gA-c13O7zaUatqPeETEDJscCTpMrhrEkxGZSvB9_CiA@mail.gmail.com>
 <07b886b6-750b-26c4-dd47-cdae94e48dad@gmail.com>
From: Peter Holm <peter.g.holm@gmail.com>
Date: Sat, 6 Aug 2016 19:31:33 +0200
Message-ID: <CAOZhre0zr2HfkiDZccvva02_PSuRGrLq4NpFtMJUBf3Lcf-_Bg@mail.gmail.com>
Subject: Re: possible bug - wrong path in 'btrfs subvolume show' when snapshot
 is in path below subvolume.
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I accidentally posted this to Andrei Borzenkov
I repost to the list with the first 3 lines added from what was earlier sent.

Regarding to my manual for btrfs-subvolume  dated 01/19/2016  it says.
"If only <dest> is given, the subvolume will be named the basename of
<source>. "
So 'btrfs su snap <dest> is a shortcut for 'btrfs su snap <source>
<source>/<dest>

Ok. If you try to replace line 2 with
btrfs su snap is-this-a-bug is-this-a-bug/is-this-a-bug
then do the rest of the lines.
After that - what is the lines for Source(s) when you execute  'btrfs
sub  show is-this-a-bug' .?


2016-08-06 11:15 GMT+02:00, Andrei Borzenkov <arvidjaar@gmail.com>:
> 06.08.2016 11:00, Peter Holm пишет:
>> You are right. Typing error. Sorry.
>> Here is from my bash_history.
>>
>> 1 btrfs su create is-this-a-bug
>> *2 btrfs su snap is-this-a-bug is-this-a-bug
>> *3 btrfs su snap is-this-a-bug /mnt/btrfs/sdc16-svid-5/
>>
>
> As I said, in my case it fails with "File exists"
>
>> *2.When snapshot is created with the same name as subvolume, then it
>> by default creates in the subdirectory of the subvolume.
>> *3. Mountpoint for he root (subvolid=5) volume
>>
>> Also I in the first post had  a link to an photo from my terminal when
>> executing thoose commands.
>> https://s31.postimg.org/9f0d7xb7f/is_this_a_bug.png
>>
>> /Peter Holm
>>
>>
>> 2016-08-06 7:14 GMT+02:00, Andrei Borzenkov <arvidjaar@gmail.com>:
>>> 05.08.2016 02:32, Peter Holm пишет:
>>>> 'btrfs subvolumee show' gives no path to btrfs system root (volid=5)
>>>> when snapshot is in the folder of subvolume.
>>>>
>>>> Step to reproduce.
>>>> 1.btrfs subvolume create xyz
>>>> 2.btrfs subvolume snapshot xyz xyz/xyz
>>>> 3.btrfs subvolume snapshot <mountpoint-for-btrfs-root>/xyz
>>>
>>> This last command is wrong - snapshot name is missing. If you mean
>>>
>>> btrfs subvolume snapshot <mountpoint-for-btrfs-root> xyz
>>>
>>> - I get "File exists" (assuming that all previous commands were with
>>> <mountpoint-for-ntrfs-root> as current directory. This is on openSUSE
>>> Tumbleweed with kernel 4.6.4-2 and btrfsprogs 4.6.1-1.
>>>
>>> If my assumption is wrong, please copy and paste exact commands used to
>>> reproduce it.
>>>
>>>> 4.btrfs subvolumme show xyz
>>>> output
>>>> .....
>>>> Snapshot(s)
>>>>                          xyz
>>>>                          xyz
>>>> .....
>>>> picture from my console reproducing this. Whatchout for my personal
>>>> fs-layout
>>>> my mountpoint for volid=5 is - as seen in the findmount command  r at
>>>> top of the photo /mnt/btrfs/sdc16-svid-5
>>>> https://s31.postimg.org/9f0d7xb7f/is_this_a_bug.png
>>>>
>>>> If that can add anything, same thing happends when rootvolume is
>>>> mounted by path. (for the moment it is mounted by volid).
>>>> /Peter Holm
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>
>
