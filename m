Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:35765 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbKJDMC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 22:12:02 -0500
Received: by ykba77 with SMTP id a77so2780388ykb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 19:12:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5640A497.2060701@gmail.com>
References: <CABtZWNH4rzzTtBwvt6Xs+nf=8aiJrbsCAVZB3QzPEnEfi-Cs5A@mail.gmail.com>
 <5640A497.2060701@gmail.com>
From: Glen H <glen.hertz@gmail.com>
Date: Mon, 9 Nov 2015 22:11:41 -0500
Message-ID: <CABtZWNHRiUOA1tcj2NmqBJs8N6SzXFbs1iVhj73D45Xb7sNojw@mail.gmail.com>
Subject: Re: btrfs-progs send | receive error: no such file or directory
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 9, 2015 at 8:50 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-11-08 16:28, Glen H wrote:
>>
>> Hi,
>>
>> I really enjoy the features of btrfs but send|receive is failing me so
>> my backups are not working.  I'm using "btrbk" to backup my drives
>> (all local) and one of the three subvolumes errors out.  When I run
>> this command from the terminal it errors out:
>>
>>> btrfs send /mnt/ssd/_btrbk_snap/@.20151108 | btrfs receive
>>> /mnt/backup2tb/
>>
>> At subvol /mnt/ssd/_btrbk_snap/@.20151108
>> At subvol @.20151108
>> ERROR: send ioctl failed with -2: No such file or directory
>> ERROR: unexpected EOF in stream.
>
> Have you ever run any kind of data deduplication (bedup, duperemove, or
> something else) on the source filesystem?  I've seen errors like this in the
> past when trying to send from a filesystem that I had run deduplication on
> (and I don't think that the patches to fix it made into the version of Mint
> you're using).
>
> That aside, there are two things that I've found that can fix some (but not
> all) send/receive errors:
> 1. Run a balance on the filesystem (either a full balance, or use filters to
> select just the block in question).
> 2. Force the file that it's choking on to be re-written (you can use 'btrfs
> receive -vv' to see what files it's processing, although be prepared for _a
> lot_ of output).

Thanks Austin for the suggestions.  I haven't done any deduping, it is
a pretty fresh install too (two weeks old).  I tried a full balance a
few times:

# btrfs balan /
Done, had to relocate 28 out of 28 chunks
# btrfs balan /
Done, had to relocate 28 out of 28 chunks

After balancing the first time should there be less to rebalance the
second time?

I tried receive -vv and then deleted the file that was causing the
issue but running again the issue happens on a different file:

...
utimes var/lib/sudo/hertz
truncate var/lib/sudo/hertz/2 size=40
chown var/lib/sudo/hertz/2 - uid=0, gid=1000
chmod var/lib/sudo/hertz/2 - mode=0600
utimes var/lib/sudo/hertz/2
mkfile o189735-35-0
truncate o189735-35-0 size=0
chown o189735-35-0 - uid=1000, gid=1000
chmod o189735-35-0 - mode=0600
ERROR: unexpected EOF in stream.

I'm not using any kind of raid.  Do you think reformatting the
partition or something else might help?  Should I try to upgrade the
kernel?

Thanks for the support.

Glen
