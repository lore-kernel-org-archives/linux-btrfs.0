Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35813 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbbEMLfV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 07:35:21 -0400
Received: by igbyr2 with SMTP id yr2so135750077igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 04:35:20 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150511214412.GE15670@merlins.org>
References: <20140908015124.GA21441@merlins.org>
	<CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com>
	<20140915001836.GU8530@merlins.org>
	<20150511214412.GE15670@merlins.org>
Date: Wed, 13 May 2015 12:35:20 +0100
Message-ID: <CAL3q7H7SYfka5MK=8XZkw1m7PGjyR-1fzrD0tP_=dhznQ5QdGQ@mail.gmail.com>
Subject: Re: btrfs differential receive has become excrutiatingly slow on one machine
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 10:44 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Sun, Sep 14, 2014 at 05:18:36PM -0700, Marc MERLIN wrote:
>> On Mon, Sep 08, 2014 at 10:49:01PM +0100, Filipe David Manana wrote:
>> > Hi Marc,
>> >
>> > Does the sum of all reads from the stream file (fd 3) gets anywhere
>> > close to the total btrfs receive time? (or even more than 50%)
>> > Can you paste somewhere the full output of strace (with -T option)?
>>
>> Sorry for the lack of answer, I lost the snapshot I used for that mail,
>> so it was not possible to do again easily.
>> Because my backups were so hopelessly behind, I did a full resync of
>> /var, i.e. not a differential send (300GB or so). The copy went at about
>> 25GB/h, which wasn't bad at all since was over wifi (took about 14H).
>
> Sigh, now that I'm resyncing my laptop I just rebuilt after the btrfs
> crash, to my server (both running 3.19.5+), full btrfs sends (i.e. not
> incremental), are taking ages.
>
> I'm seeing less than 100GB/day on my home network when my tcp
> connections over wifi easily get 50MB/s
>
> Right now I'm seeing the equivalent of aout 1MB/s, or 50 times less than
> what my network connection can do.
>
> Last time I tried to strace btrfs send, it killed the process with
> SIGPIPE and I lost a full day of sync and had to start over :(
>
> It's a broad question, but how can I diagnose btrfs send being so slow
> without taking the risk of killing my connection?
> (if there is no good answer on this one, I can try another sync later
> with -vvv and strace if you'd like)

Try to see if it's a problem at the sending side or at the receiving
side. Redirect send's output to a file, see how much it takes. Then
run receive with that file as input and see how long it takes.
You can also use 'perf record -ag' while doing both, it might give
some useful information.

>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
