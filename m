Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36735 "EHLO
	mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbcHARUx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 13:20:53 -0400
Received: by mail-it0-f67.google.com with SMTP id j124so12341862ith.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 10:20:03 -0700 (PDT)
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com>
 <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
 <a582564a-e991-dd35-721f-31c807a24929@gmail.com>
 <CAJCQCtRgmfWVf9YB2=fVLDSRhm4-t7W+YHBabBaBsBZeSiDU1Q@mail.gmail.com>
 <ad6d5637-7d38-8527-513c-ffe000e5a2f1@gmail.com>
 <CAJCQCtQtxVOZ=7Phc=mjTbGbL+V5hMsjTL3vssJXH0pVZ2xrEg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <66ae3161-b57e-e531-36d5-afc726912563@gmail.com>
Date: Mon, 1 Aug 2016 13:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQtxVOZ=7Phc=mjTbGbL+V5hMsjTL3vssJXH0pVZ2xrEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-01 13:15, Chris Murphy wrote:
> On Mon, Aug 1, 2016 at 10:58 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-08-01 12:19, Chris Murphy wrote:
>>>
>>> On Mon, Aug 1, 2016 at 10:08 AM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>
>>>>
>>>> MD and DM RAID handle this by starting kernel threads to do the scrub.
>>>> They
>>>> then store the info about the scrub in the array itself, so you can query
>>>> it
>>>> externally.  If you watch, neither of those commands runs longer than it
>>>> takes to start the operation, so there's nothing for systemd to kill.
>>>
>>>
>>> pvmove continues to run and report progress so it can be killed off,
>>> but it only polls for statistics, it's not actually recording them. So
>>> even though it gets killed, subsequent pvmove command shows correct
>>> statistics.
>>
>> Because all that the pvmove command is doing is polling for statistics. It
>> actually works kind of like a scrub, all the actual work is done in the
>> kernel, the userspace component just handles reporting.  The difference is
>> that the move operation is accounted and mutexed in the kernel itself,
>> instead of userspace like scrub does.  This model is actually essentially
>> what I think scrub (and balance for that matter) should look like, and if
>> implemented right, we could actually store scrub results in the FS itself
>> (that is, in the metadata, not in special files or anything like that).
>>>
>>>
>>> So that makes me wonder how btrfs device add and remove will behave,
>>> if issued in a DE which is then logged out of. Those commands do not
>>> return to prompt until they complete.
>>
>> They work via balance, so they should behave the same as a balance command,
>> which means it will likely run part way then get cancelled because of the
>> SIGTERM to the userspace component (assuming of course that it is still
>> running when you log out).
>
> I've been using balance with &, and when I logout, the btrfs command
> continues to flip between status D and R, just like before logout and
> it appears to complete. I still get status messages of the balance
> after logout, in kernel messages.
>
Interesting, maybe balance is explicitly white-listed?  Either that, or 
it just ignores whatever signal systemd uses to kill stuff in this 
context (I initially thought SIGTERM, but SIGHUP would make more sense 
in this context), which wouldn't surprise me either.
