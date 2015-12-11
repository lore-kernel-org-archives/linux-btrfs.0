Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:48390 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbLKW3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 17:29:50 -0500
Message-ID: <1449872498.31388.74.camel@fo>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Christoph Anton Mitterer <fo@fo>
To: Chris Murphy <lists@colorremedies.com>, "S.J." <sorry@anonym.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Fri, 11 Dec 2015 23:21:38 +0100
In-Reply-To: <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
References: <20151204120529.37E47D5A28@emkei.cz>
	 <20151204130758.GR8775@carfax.org.uk>
	 <1449286104.18841.14.camel@scientia.net>
	 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	 <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
	 <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
	 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2015-12-10 at 12:42 -0700, Chris Murphy wrote:
> That isn't what I'm suggesting. In the multiple device volume case
> where there are two exact (same UUID, same devid, same generation)
> instances of one of the block devices, Btrfs could randomly choose
> either one if it's an RO mount.
No, for the same reasons as just stated in my mail few minutes ago.
An attacker could probably find out the UUID/devid/generation... it
would probably possible for him to craft a device with exactly those
and try to use it.
If then btrfs would select any of these, it may also select the wrong
one - ro or rw, this may likely lead to problems.




> > About 1 and 2 ... if 3 gets fulfilled, why?
> > DD itself is not a problem "if" the UUID is changed after it
> > (which is a command as simple as dd), and if someone doesn't
> > know that, he/she will notice when mount refuses to work
> > because UUID duplicate.
> 
> dd is not a copy operation. It's creating a 2nd original. You don't
> end up with an original and a copy (or clone). A copy or clone has
> some distinguishing difference. Volume UUID is used throughout Btrfs
> metadata, it's not just in the superblocks. Changing volume UUID
> requires a rewrite of all metadata. This is inefficient for two
> reasons: one dd copies unused sectors; two it copies metadata that
> will have to be completely rewritten by btrfstune to change volume
> UUID; and also the subvolume UUIDs aren't changed, so it's an
> incomplete solution that has problems (see other threads).
Well dd is surely not the only thing that can be used to create a clone
(i.e. a bitwise identical copy - I guess we don't really care which is
the "original" and which are the "clones", or whether these are "2nd
originals).
We always just use it here as an example for scenarios in which bitwise
identical copies are created.

And even if internally it's a big thing, from the user's PoV, changing
the UUID is pretty simple (I guess that's what S.J. meant).


> If your workflow requires making an exact copy (for the shelf or for
> an emergency) then dd might be OK. But most often it's used because
> it's been easy, not because it's a good practice.
Ufff.. I wouldn't got that far to call something here bad or good
practice.
At least, I do not see any reason to call it a bad practice, except
that systems got over time much more complex and haven't dealt properly
with the problems that can occur by using dd.
Again, I don't demand magical "solutions" (i.e. the btrfs or LVM people
getting code into all dd like tools, so that these auto-detect when the
duplicate such data and auto-change the UUIDs)... they just should
handle the situations gracefully.


>  Note that Btrfs is
> not unique, XFS v5 does a very similar thing with volume UUID as
> well,
> and resulted in this change:
> http://oss.sgi.com/pipermail/xfs/2015-April/041267.html
Do you mean that xfs may suffer from the same issues that we're talking
about here? If so, one should probably give them a notice.



> Using dd also means the volume is offline.
Not really, you could do it on a snapshotted LV, while the "original"
is still running.
Or in emergency cases one could do it on a ro-remounted... probably not
guaranteed to work, but may do so in practise.


Cheers,
Chris.
