Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35412 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbcFEXjW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 19:39:22 -0400
Received: by mail-oi0-f47.google.com with SMTP id w184so202463573oiw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 16:39:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465162317.6702.53.camel@scientia.net>
References: <1464819934.6742.71.camel@scientia.net>
	<d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
	<1464975482.6679.11.camel@scientia.net>
	<6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
	<1465005092.6648.39.camel@scientia.net>
	<CAPmG0jZGY841PNwYi6gaun38gjN83=OMQB0r_UiVrdL9iY2J9Q@mail.gmail.com>
	<1465160205.6702.38.camel@scientia.net>
	<20160605210721.GH24492@carfax.org.uk>
	<1465162317.6702.53.camel@scientia.net>
Date: Sun, 5 Jun 2016 17:39:21 -0600
Message-ID: <CAJCQCtR62H2aOxN8EOFRZS7W4zsimp3Dcpd8qebRLzYFRfQ=dA@mail.gmail.com>
Subject: Re: btrfs
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Hugo Mills <hugo@carfax.org.uk>, Henk Slager <eye1tm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 5, 2016 at 3:31 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sun, 2016-06-05 at 21:07 +0000, Hugo Mills wrote:
>>    The problem is that you can't guarantee consistency with
>> nodatacow+checksums. If you have nodatacow, then data is overwritten,
>> in place. If you do that, then you can't have a fully consistent
>> checksum -- there are always race conditions between the checksum and
>> the data being written (or the data and the checksum, depending on
>> which way round you do it).
>
> I'm not an expert in the btrfs internals... but I had a pretty long
> discussion back then when I brought this up first, and everything that
> came out of that - to my understanding - indicated, that it should be
> simply possible.
>
> a) nodatacow just means "no data cow", but not "no meta data cow".
>    And isn't the checksumming data meda data? So AFAIU, this is itself
>    anyway COWed.
> b) What you refer to above is, AFAIU, that data may be written (not
>    COWed) and there is of course no guarantee that the written data
>    matches the checksum (which may e.g. still be the old sum).
>    => So what?

For  a file like a VM image constantly being modified, essentially at
no time will the csums on disk ever reflect the state of the file.

>       This anyway only happens in case of crash/etc. and in that case
>       we anyway have no idea, whether the written not COWed block is
>       consistent or not, whether we do checksumming or not.

If the file is cow'd and checksummed, and there's a crash, there is
supposed to be consistency: either the old state or new state for the
data is on-disk and the current valid metadata correctly describes
which state that data is in.

If the file is not cow'd and not checksummed, its consistency is
unknown but also ignored, when doing normal reads, balance or scrubs.

If the file is not cow'd but were checksummed, there would always be
some inconsistency if the file is actively being modified. Only when
it's not being modified, and metadata writes for that file are
committed to disk and the superblock updated, is there consistency. At
any other time, there's inconsistency. So if there's a crash, a
balance or scrub or normal read will say the file is corrupt. And the
normal way Btrfs deals with corruption on reads from a mounted fs is
to complain and it does not pass the corrupt data to user space,
instead there's an i/o error. You have to use restore to scrape it off
the volume; or alternatively use btrfsck to recompute checksums.

Presumably you'd ask for an exception for this kind of file, where it
can still be read even though there's a checksum mismatch, can be
scrubbed and balanced which will report there's corruption even if
there isn't any, and you've gained, insofar as I can tell, a lot of
confusion and ambiguity.

It's fine you want a change in behavior for Btrfs. But when a
developer responds, more than once, about how this is somewhere
between difficult and not possible, and you say it should simply be
possible, I think that's annoying, bordering on irritating.


-- 
Chris Murphy
