Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55035 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab2FDQYI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 12:24:08 -0400
Received: by vbbff1 with SMTP id ff1so2563911vbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 09:24:07 -0700 (PDT)
Message-ID: <4FCCE125.7000004@gmail.com>
Date: Mon, 04 Jun 2012 12:24:05 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
References: <4FCC1AE1.8050802@gmail.com> <4FCC2496.6070805@cn.fujitsu.com> <4FCC6F44.2030503@gmx.net> <4FCC9C63.7000605@gmail.com> <4FCC9CD5.2050309@gmx.net> <4FCC9F6C.5090305@gmail.com> <20120604114901.GA15986@carfax.org.uk> <4FCCA39C.8060409@gmail.com> <20120604121134.GB15986@carfax.org.uk> <4FCCA9E6.3030209@gmail.com> <20120604123431.GC15986@carfax.org.uk>
In-Reply-To: <20120604123431.GC15986@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I run through all potential tree roots. It gave me everytime messages 
like these:

parent transid verify failed on 3405159735296 wanted 9096 found 5263
parent transid verify failed on 3405159735296 wanted 9096 found 5263
parent transid verify failed on 3405159735296 wanted 9096 found 5263
parent transid verify failed on 3405159735296 wanted 9096 found 5263
Ignoring transid failure
parent transid verify failed on 3356745109504 wanted 5263 found 9008
parent transid verify failed on 3356745109504 wanted 5263 found 9008
parent transid verify failed on 3356745109504 wanted 5263 found 9008
parent transid verify failed on 3356745109504 wanted 5263 found 9008
Ignoring transid failure
parent transid verify failed on 3356744548352 wanted 5262 found 9008
parent transid verify failed on 3356744548352 wanted 5262 found 9008
parent transid verify failed on 3356744548352 wanted 5262 found 9008
parent transid verify failed on 3356744548352 wanted 5262 found 9008
Ignoring transid failure
parent transid verify failed on 3356745035776 wanted 5263 found 9008
parent transid verify failed on 3356745035776 wanted 5263 found 9008
parent transid verify failed on 3356745035776 wanted 5263 found 9008
parent transid verify failed on 3356745035776 wanted 5263 found 9008
Ignoring transid failure
parent transid verify failed on 3356745015296 wanted 5263 found 9008
parent transid verify failed on 3356745015296 wanted 5263 found 9008
parent transid verify failed on 3356745015296 wanted 5263 found 9008
parent transid verify failed on 3356745015296 wanted 5263 found 9008
Ignoring transid failure
Root objectid is 5

The largest recovered data is 12Kb.
max@s0:~/btrfs-recovering./recovered$ ls -lahs 3728819929088
total 28K
4.0K drwxr-xr-x   3 root root 4.0K Jun  4 12:06 .
  20K drwxrwxr-x 347 max  max   20K Jun  4 12:18 ..
4.0K drwxr-xr-x   3 root root 4.0K Jun  4 12:06 Irina
max@s0:~/btrfs-recovering./recovered$ ls -lahs 3728819929088/Irina/
total 12K
4.0K drwxr-xr-x 3 root root 4.0K Jun  4 12:06 .
4.0K drwxr-xr-x 3 root root 4.0K Jun  4 12:06 ..
4.0K drwxr-xr-x 2 root root 4.0K Jun  4 12:06 .idmapdir2
max@s0:~/btrfs-recovering./recovered$ ls -lahs 
3728819929088/Irina/.idmapdir2/
total 8.0K
4.0K drwxr-xr-x 2 root root 4.0K Jun  4 12:06 .
4.0K drwxr-xr-x 3 root root 4.0K Jun  4 12:06 ..
    0 -rw-r--r-- 1 root root    0 Jun  4 12:06 4.bucket.lock
    0 -rw-r--r-- 1 root root    0 Jun  4 12:06 7.bucket
max@s0:~/btrfs-recovering./recovered$

What can I do next?



On 06/04/2012 08:34 AM, Hugo Mills wrote:
> [trimmed Arne&  Jan from cc by request]
>
> On Mon, Jun 04, 2012 at 08:28:22AM -0400, Maxim Mikheev wrote:
>> adding -v, as an example:
>> sudo btrfs-find-root -v -v -v -v -v /dev/sdb
>>
>> didn't change output at all.
>     OK, then all I can suggest is what I said below -- work through the
> potential tree roots in order from largest generation id to smallest.
> Given that it's not reporting any trees, though, I'm not certain that
> you'll get any success with it.
>
>     Did you have your data in a subvolume?
>
>     Hugo.
>
>> On 06/04/2012 08:11 AM, Hugo Mills wrote:
>>> On Mon, Jun 04, 2012 at 08:01:32AM -0400, Maxim Mikheev wrote:
>>>> Thank you for helping.
>>>     I'm not sure I can be of much help, but there were a few things
>>> missing from the earlier conversation that I wanted to check the
>>> details of.
>>>
>>>> ~$ uname -a
>>>> Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21 09:22:02
>>>> UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>> I compiled progs from recent git (week or two ago). I can compile it
>>>> again if there updates.
>>>     No, that should be recent enough. I don't think there have been any
>>> major updates since then.
>>>
>>>> The output of btrfs-find-root is pretty long and below:
>>>> max@s0:~$ sudo btrfs-find-root /dev/sdb
>>>> Super think's the tree root is at 5532762525696, chunk root 20979712
>>>> Well block 619435147264 seems great, but generation doesn't match,
>>>> have=8746, want=9096
>>>     This is not long enough, unfortunately. At least some of these
>>> should have a list of trees before them. At the moment, it's not
>>> reporting any trees at all. (At least, it should be doing this unless
>>> Chris took that line of code out). Do you get anything extra from
>>> adding a few -v options to the command?
>>>
>>>     I would suggest, in the absence of any better ideas, sorting this
>>> list by the "have=" value, and systematically working down from the
>>> largest to the smallest, running btrfs-restore -t $n for each one
>>> (where $n is corresponding block number).
>>>
>>>     Hugo.
> [snip]
>
