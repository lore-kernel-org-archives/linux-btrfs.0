Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36952 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbcC0TE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 15:04:26 -0400
Received: by mail-ig0-f178.google.com with SMTP id l20so43223248igf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 12:04:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160327193105.0ba5c557@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<CAJCQCtSzKT2BZ15JwgR4b6Nk+n2tsHBLizwJXOqJ93Jbuv05rQ@mail.gmail.com>
	<CAJCQCtQYkCDLks0Wvnt2nqTRMAvh6wQ5nsHB4GPD4wFA8geAsw@mail.gmail.com>
	<20160327033032.6dce42e0@jupiter.sol.kaishome.de>
	<CAJCQCtSOURe5Cy-ytB3Tg_s46hgWsGKLn6fXjy8vt+TBQKNucg@mail.gmail.com>
	<20160327193105.0ba5c557@jupiter.sol.kaishome.de>
Date: Sun, 27 Mar 2016 13:04:25 -0600
Message-ID: <CAJCQCtQZBv=Qrh+oSM4a5CQW3sTBRWVeJmYN_q0Vx0TvGZCtgg@mail.gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 27, 2016 at 11:31 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Sat, 26 Mar 2016 22:57:53 -0600
> schrieb Chris Murphy <lists@colorremedies.com>:
>
>> On Sat, Mar 26, 2016 at 7:30 PM, Kai Krakow <hurikhan77@gmail.com>
>> wrote:
>>
>> > Both filesystems on this PC show similar corruption now - but they
>> > are connected to completely different buses (SATA3 bcache + 3x SATA2
>> > backing store bache{0,1,2}, and USB3 without bcache = sde), use
>> > different compression (compress=lzo vs. compress-force=zlib), but
>> > similar redundancy scheme (draid=0,mraid=1 vs.
>> > draid=single,mraid=dup). A hardware problem would induce completely
>> > random errors on these pathes.
>> >
>> > Completely different hardware shows similar problems - but that
>> > system is currently not available to me, and will stay there for a
>> > while (it's a non-production installation at my workplace). Why
>> > would similar errors show up here, if it'd be a hardware error of
>> > the first system?
>>
>> Then there's something about the particular combination of mount
>> options you're using with the workload that's inducing this, if it's
>> reproducing on two different systems. What's the workload and what's
>> the full history of the mount options? Looks like it started life as
>> compress lzo and then later compress-force zlib and then after that
>> the addition of space_cache=v2?
>
> Still, that's two (or three) different filesystems:
>
> The first (my main system) had compress=lzo forever, I never used
> compress-force or something different than lzo.
>
> The second (my main system backup) had compress-force=zlib forever,
> never used a different compression option.
>
> The third (the currently offline system) had compress=lzo like the
> first one. It has no backup, system can be rebuild from scratch, no
> important data there. I don't bother about that currently.
>
>> Hopefully Qu has some advice on what's next. It might not be a bad
>> idea to get a btrfs-image going.
>
> I first upgraded to btrfs-progs 4.5 and removed the space_cache=v2
> option (space tree has been removed, ro-incompat flag was reset
> according to dmesg). I only activated that to see if it changes things,
> and I made sure beforehand that this can be removed. Looks like that
> works as documented.
>
> I'll come back to the other thread as soon as I've run the check. It
> takes a while (it contains a few weeks worth of snapshots). Meanwhile
> I'll see if the main fs looks any different with btrfs-progs 4.5. I
> need to get into dracut pre-mount for that.
>
> At least, with space_cache=v2 removed, the delayed_refs problem there
> is gone - so that code obviously has problems.
>
> The main system didn't use space_cache=v2, tho, when the "object
> already exists" problem hit me first.
>
> I'll prepare for btrfs-image. How big is that going to be? I'd prefer
> to make it as sparse as possible. I could hook it up to a 100mbit
> upload but I need to get storage for that first.

Before you go to the trouble of uploading btrfs-image, see if 'btrfs
check' with progs 4.5 clears up the noisy messages that Qu thinks are
false alarms.

As for the csum errors with this one single VDI file, you're going to
have to come up with a way to reproduce it consistently. You'll need
to have a good copy on a filesystem that comes up clean with btrfs
check and scrub. And then reproduce the corruption somehow. One hint
based on the other two users with similar setups or workload is they
aren't using the discard mount option and you are. I'd say unless you
have a newer SSD that supports queued trim, it probably shouldn't be
used, it's known to cause the kinds of hangs you report with drives
that only support non-queued trim. Those drives are better off getting
fstrim e.g. once a week on a timer.

And something that I find annoying is when you say in the first post
"results in a write error and the file system goes read-only" you're
asked by one of the developers to provide the kernel log, and then you
paste only some csum errors not kernel log. And not even the write
error. I think you need to collect more data, this whole thread is
like throwing spaghetti at a wall or throwing darts in a pitch black
room. You need to do more testing to find out what the pattern is,
when it happens and doesn't happen. The traces you're posting don't
help. And they're also incomplete. That's my two cents.


-- 
Chris Murphy
