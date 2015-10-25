Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34993 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbJYOT0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 10:19:26 -0400
Received: by iofz202 with SMTP id z202so163325368iof.2
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2015 07:19:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <409f0e8e-c295-48c3-ae1e-5dceb44a9add@aei.ca>
References: <20151024173617.GA26012@nbnb1>
	<CAL3q7H5H_Qdq0NAhiDOVw=JLYPJPuHhhSZPgUSQm=oYN+yXK=g@mail.gmail.com>
	<c84e02ac-4e81-4a11-b8d8-3660d3e0eb77@aei.ca>
	<CAL3q7H4UGXsOOFoTVcw6=EsEaroT3nCwandenJXOhdxiaBVAdw@mail.gmail.com>
	<409f0e8e-c295-48c3-ae1e-5dceb44a9add@aei.ca>
Date: Sun, 25 Oct 2015 14:19:25 +0000
Message-ID: <CAL3q7H4WR0BZocuTrjDrYZc_9xp-LNqByQLG7q0qL9XEKHcvcg@mail.gmail.com>
Subject: Re: btrfs double send
From: Filipe Manana <fdmanana@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: kolcon@kolcon.net,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 25, 2015 at 2:10 PM, Ed Tomlinson <edt@aei.ca> wrote:
> Filipe,
>
> I realize its another bug.  Two additional pieces of info that might help.
> One, btrfs-progs was at 4.1.2 (I missed a tag= in my git pull).

Btrfs-progs' version is irrelevant. The problem is the send side
generating incorrect paths in the send stream (as I mentioned
earlier), so it's exclusively a problem in the kernel.

> Second
> is that I have been able to recreate this issue three times over a period of
> two to three days (tring again with 4.2.3).  My fs is probably a good
> testcase for any patches that appear.

Yeah.
If you can find out what happened to the directory/file in question
between the parent and send snapshots (was it renamed/moved? was it
deleted and then a new one with the same name/location created?) that
helps. Otherwise looking at btrfs-debug-tree and see the trees for
each snapshot helps too, but you need to figure out the number of the
inode where it's failing (sometimes btrfs receive -vv is enough to
figure this out).

thanks

>
> Meanwhile I've been falling back to rsync which always works but is so much
> slower.
>
> TIA
> Ed
> On Sunday, October 25, 2015 9:42:54 AM EDT, Filipe Manana wrote:
>>
>> On Sun, Oct 25, 2015 at 1:38 PM, Ed Tomlinson <edt@aei.ca> wrote:
>>>
>>> Filipe,
>>>
>>> Its still not perfect.  Here I can do sequential sends a few times then I
>>> get something like this:
>>>
>>> [root@grover snap]# sh -x brh
>>> + base=/snap/shot ...
>>
>>
>> Different and unrelated problem.
>> Yes, we know there are still some problems regarding send issuing
>> invalid/outdated paths to the send stream. Nothing to do with
>> incorrect uuids in the send stream.
>>
>>> Please let me know if there is anything you would like me to try.  I am
>>> running 4.2 with the 4.3 for-linus tree applied and the 4.2.x patches
>>> with
>>> btrfs fixes removed.  On top of this are a few patches from this list.
>>>
>>> TIA
>>> Ed Tomlinson ...
>>
>>
>>
>>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
