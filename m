Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55392 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaJMLsc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 07:48:32 -0400
Received: by mail-vc0-f174.google.com with SMTP id hq12so5686803vcb.33
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 04:48:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2313804.P0rE2GFdbV@merkaba>
References: <54358C77.2070808@redhat.com>
	<5437BAB2.1040605@shiftmail.org>
	<93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com>
	<2313804.P0rE2GFdbV@merkaba>
Date: Mon, 13 Oct 2014 07:48:31 -0400
Message-ID: <CAGfcS_=yjBR+j7AUCaMBCC4BmDTEX52wN-ZoB8vZ5j_jhB8ONg@mail.gmail.com>
Subject: Re: What is the vision for btrfs fs repair?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 12, 2014 at 6:14 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Freitag, 10. Oktober 2014, 10:37:44 schrieb Chris Murphy:
>> On Oct 10, 2014, at 6:53 AM, Bob Marley <bobmarley@shiftmail.org> wrote:
>> > On 10/10/2014 03:58, Chris Murphy wrote:
>> >>> * mount -o recovery
>> >>>
>> >>>   "Enable autorecovery attempts if a bad tree root is found at mount
>> >>>   time."
>> >>
>> >> I'm confused why it's not the default yet. Maybe it's continuing to
>> >> evolve at a pace that suggests something could sneak in that makes
>> >> things worse? It is almost an oxymoron in that I'm manually enabling an
>> >> autorecovery
>> >>
>> >> If true, maybe the closest indication we'd get of btrfs stablity is the
>> >> default enabling of autorecovery.>
>> > No way!
>> > I wouldn't want a default like that.
>> >
>> > If you think at distributed transactions: suppose a sync was issued on
>> > both sides of a distributed transaction, then power was lost on one side,
>> > than btrfs had corruption. When I remount it, definitely the worst thing
>> > that can happen is that it auto-rolls-back to a previous known-good
>> > state.
>> For a general purpose file system, losing 30 seconds (or less) of
>> questionably committed data, likely corrupt, is a file system that won't
>> mount without user intervention, which requires a secret decoder ring to
>> get it to mount at all. And may require the use of specialized tools to
>> retrieve that data in any case.
>>
>> The fail safe behavior is to treat the known good tree root as the default
>> tree root, and bypass the bad tree root if it cannot be repaired, so that
>> the volume can be mounted with default mount options (i.e. the ones in
>> fstab). Otherwise it's a filesystem that isn't well suited for general
>> purpose use as rootfs let alone for boot.
>
> To understand this a bit better:
>
> What can be the reasons a recent tree gets corrupted?
>
> I always thought with a controller and device and driver combination that
> honors fsync with BTRFS it would either be the new state of the last known
> good state *anyway*. So where does the need to rollback arise from?
>

In theory the recover option should never be necessary.  Btrfs makes
all the guarantees everybody wants it to - when the data is fsynced
then it will never be lost.

The question is what should happen when a corrupted tree root, which
should never happen, happens anyway.  The options are to refuse to
mount the filesystem by default, or mount it by default discarding
about 30-60s worth of writes.  And yes, when this situation happens
(whether it mounts by default or not) btrfs has broken its promise of
data being written after a successful fsync return.

As has been pointed out, braindead drive firmware is the most likely
cause of this sort of issue.  However, there are a number of other
hardware and software errors that could cause it, including errors in
linux outside of btrfs, and of course bugs in btrfs as well.

In an ideal world no filesystem would need any kind of recovery/repair
tools.  They can often mean that the fsync promise was broken.  The
real question is, once that has happened, how do you move on?

I think the best default is to auto-recover, but to have better
facilities for reporting errors to the user.  Right now btrfs is very
quiet about failures - maybe a cryptic message in dmesg, and nobody
reads all of that unless they're looking for something.  If btrfs
could report significant issues that might mitigate the impact of an
auto-recovery.

Also, another thing to consider during recovery is whether the damaged
data could be optionally stored in a snapshot of some kind - maybe in
the way that ext3/4 rollback data after conversion gets stored in a
snapshot.  My knowledge of the underlying structures is weak, but I'd
think that a corrupted tree root practically is a snapshot already,
and turning it into one might even be easier than cleaning it up.  Of
course, we would need to ensure the snapshot could be deleted without
further error.  Doing anything with the snapshot might require special
tools, but if people want to do disk scraping they could.

--
Rich
