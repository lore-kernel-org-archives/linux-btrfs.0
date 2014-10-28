Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:56361 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaJ1RBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 13:01:39 -0400
Received: by mail-qg0-f46.google.com with SMTP id z60so829437qgd.19
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 10:01:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$9971f$f447ea56$689bac10$a0d10b02@cox.net>
References: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
	<5DD6D691-A067-4937-A5B4-545A0DFB9B1E@colorremedies.com>
	<pan$98595$5149a38a$2d53014$f3ac0c62@cox.net>
	<trinity-1f0ee155-d845-40b5-844d-77270be4d58e-1414495992747@3capp-mailcom-bs04>
	<pan$9971f$f447ea56$689bac10$a0d10b02@cox.net>
Date: Tue, 28 Oct 2014 13:01:35 -0400
Message-ID: <CAGfcS_konOdjWxDnQLZQmUhiMRC3EJxZJCp=4bAwp0YMwdzzSA@mail.gmail.com>
Subject: Re: BTRFS balance segfault, where to go from here
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 28, 2014 at 9:33 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Since it's not an option here I've not looked into it too closely
> personally, and don't know if it'll fit your needs, but if it does, it
> may well be simpler to substitute it into the existing backup setup
> without rewriting the WHOLE thing, than to do that full rewrite from
> scratch, without the btrfs/zfs features.  I'd at least look into it,
> assuming you haven't already.

I haven't researched zfs as thoroughly as btrfs and I'm not running
it, but you're certainly right that it is more mature (though I would
not say that zfs on linux is as mature as zfs on BSD or especially
Solaris).

Keep in mind that ZFS is marketed more towards enterprise workloads.
It isn't quite a dynamic as btrfs is intended to be, though in truth
many of those btrfs features like reshaping a raid5 aren't implemented
yet.  My sense is that you're going to need to plan ahead a bit more
with ZFS and making changes without doing a full backup/re-create is
going to be harder.  It also isn't designed for SSD (though it does
have features for SSD caching of the write log and I think also
read-caching, which is something that does not yet exist for btrfs).

>From what I understand of both I'd say that btrfs actually has the
better overall design, but zfs just has a LOT more maturity.  I think
that btrfs will eventually overtake it, but just when that will happen
is anybody's guess, and it certainly isn't there today.

The one thing that zfs does have going for you is that you're very
unlikely to get BUGs and PANICs anytime you do something as simple as
running rsync on it.

I will also note that I rsync data off of my btrfs filesystem all the
time without issue.  I do not have experience with using rsync to
write TO a btrfs filesystem.  Right now I don't trust btrfs send
enough to rely on it - the whole purpose of using rsync right now is
to backup my btrfs data to an ext4 partition which lets me sleep well
at night while still getting to play around with btrfs and make use of
features like snapshots/etc.  :)

If I was running a large (ie measured in 10s of disks) storage system
I'd probably go with ZFS now.  In such a setup being limited to RAID6s
of maybe 7 drives each and having to add/remove drives 7 at a time
wouldn't be a big deal.  When you're running a system with 6 disks
total that is a much bigger limitation.  If you look at something like
Backblade's storage pods that is the perfect example of the kind of
situation ZFS was designed to handle.  On the other hand, btrfs aims
to eventually address that while being a decent default filesystem for
your smartphone.

--
Rich
