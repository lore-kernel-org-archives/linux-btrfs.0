Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35722 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbCRXBL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 19:01:11 -0400
Received: by pabyw6 with SMTP id yw6so56025528pab.2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 16:01:10 -0700 (PDT)
Subject: Re: syntax for deleting subvolumes?
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
references: <5509E34F.6010504@graphitesystems.com>
 <CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
 <5509F08E.6070702@graphitesystems.com> <20150318215512.GC31762@carfax.org.uk>
From: K Richard Pixley <rpixley@graphitesystems.com>
message-id: <550A03B3.8020005@graphitesystems.com>
Date: Wed, 18 Mar 2015 16:01:07 -0700
mime-version: 1.0
in-reply-to: <20150318215512.GC31762@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/18/15 14:55 , Hugo Mills wrote:
> On Wed, Mar 18, 2015 at 02:39:26PM -0700, K Richard Pixley wrote:
>> On 3/18/15 14:06 , Chris Murphy wrote:
>>> The Fedora/RHEL/CentOS installer creates two subvolumes: root and
>>> home. If you check out fstab, those subvolumes are mounted at /
>>> and /home. Therefore the top level subvolume (id 5) is not mounted
>>> by default, so there's no way to delete subvolumes in the top
>>> level.
>> Ah!  Thank you.  That's the piece I was missing.
>>
>> IMO, someone needs to take a clue-by-four to the heads of the
>> Fedora/RHEL/CentOS installer folks.  I see no reason for this with
>> btrfs.
>     Actually, it's the recommended approach.
>
>     We've found over time that nesting subvolumes inside each other is,
> in general, more trouble than it's worth. It makes it harder to do
> things like take snapshots and then replace the original with a
> snapshot (e.g. rollback to an earlier state).
>
>     Arranging the subvolumes with the top level (subvolid=0) as nothing
> but a store for subvolumes means that you don't get the subvolumes
> tangled up with each other, so it's much easier to manage them in
> general.
>
>     There's a few cases where nesting subvolumes is helpful, but that's
> more to do with preventing snapshots being taken of some pieces of the
> filesystem.
Yes, I understand about the flat arrangement.  It's been that way for 
years now.

My complaint is a) about multiple subvols and b) about an unnecessary 
and redundant subvol for the top level file system.

The redundancy should be obvious.  And the problem with multiple subvols 
is that they aren't needed and make snapshotting an entire system more 
difficult than it needs to be.  I want to be able to snapshot and 
chroot.  The traditional reason for partitioning a disk was to isolate 
errors and to firewall "out of space" usage.  Neither of those really 
apply to btrfs as far as I can see.

I would much rather the installer simply create a single file system and 
mount the partition directly rather than through a superfluous subvol.  
I've never seen it done any other way as you might guess from my 
confusion above.

--rich
