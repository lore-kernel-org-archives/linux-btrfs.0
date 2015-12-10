Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34269 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbbLJTmu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 14:42:50 -0500
Received: by mail-ig0-f176.google.com with SMTP id g19so25185847igv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 11:42:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5668A1CB.1020007@anonym.com>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	<1449366680.3183.37.camel@scientia.net>
	<56644785.4090702@gmx.com>
	<1449639588.7835.2.camel@scientia.net>
	<5668A1CB.1020007@anonym.com>
Date: Thu, 10 Dec 2015 12:42:49 -0700
Message-ID: <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Chris Murphy <lists@colorremedies.com>
To: "S.J." <sorry@anonym.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 9, 2015 at 2:48 PM, S.J. <sorry@anonym.com> wrote:
>> 1. better practices, we really need to tell users, and documentation
>> writers, that using dd (or variant) to copy Btrfs volumes has a
>> consequence and should not be used to make copies.
>
>
>> 2. Btrfs needs a better way to make a copy of a volume when there are
>> snapshots (including even rw snapshots); e.g. permit send/receive to
>> work on rw snapshots if the fs is ro mounted; e.g. a way to do
>> "recursive" send/receive.
>
>
>> 3. Some way to fail gracefully, when there's ambiguity that cannot be
>> resolved. Once there are duplicate devs (dd or lvm snapshots, etc)
>> then there's simply no way to resolve the ambiguity automatically, and
>> the volume should just refuse to rw mount until the user resolves the
>> ambiguity. I think it's OK to fallback to ro mount (maybe) by default
>> in such a case rather than totally fail to mount.
>
>
> About 3:
> RO fallback for the second device/partitions is not good.
> It won't stop confusing the two partitions, and even if both are RO,
> thinking it's ok to read and then reading the wrong data is bad.

That isn't what I'm suggesting. In the multiple device volume case
where there are two exact (same UUID, same devid, same generation)
instances of one of the block devices, Btrfs could randomly choose
either one if it's an RO mount.

It may very well be safer to just refuse to mount it with an error
indicating the ambiguity, and suggesting the user explicitly specify
the devices to use to assemble the volume, and if the generations
differ on those chosen devices, at least warn about that also.


>
> About 1 and 2 ... if 3 gets fulfilled, why?
> DD itself is not a problem "if" the UUID is changed after it
> (which is a command as simple as dd), and if someone doesn't
> know that, he/she will notice when mount refuses to work
> because UUID duplicate.

dd is not a copy operation. It's creating a 2nd original. You don't
end up with an original and a copy (or clone). A copy or clone has
some distinguishing difference. Volume UUID is used throughout Btrfs
metadata, it's not just in the superblocks. Changing volume UUID
requires a rewrite of all metadata. This is inefficient for two
reasons: one dd copies unused sectors; two it copies metadata that
will have to be completely rewritten by btrfstune to change volume
UUID; and also the subvolume UUIDs aren't changed, so it's an
incomplete solution that has problems (see other threads).

If your workflow requires making an exact copy (for the shelf or for
an emergency) then dd might be OK. But most often it's used because
it's been easy, not because it's a good practice. Note that Btrfs is
not unique, XFS v5 does a very similar thing with volume UUID as well,
and resulted in this change:
http://oss.sgi.com/pipermail/xfs/2015-April/041267.html

Using dd also means the volume is offline. For even medium sized
multiple device volumes, it's a huge penalty. dd does not scale. Using
dd means source and destination physical configurations are identical
(at least the number of devices and the data and metadata profiles)
which I may not want or need for a clone. Maybe I want a 1x6TB clone
for the 5x1TB raid5 volume.

Even for an online full volume copy/clone of a 5x1TB raid5, moving all
subvolume+snapshots to a new 3x4TB raid5 (or whatever), that could be
hundreds of subvolumes to btrfs send/receive. OK yeah script it. But
that's tedious even assuming I have a script friendly subvolume naming
convention to get the send/receive order correct, which I don't.

Anyway, I think it's a nice to have now, that'll eventually be a need.
And dd is just totally disqualified outside of very specific edge case
need.


-- 
Chris Murphy
