From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: announcement of deduplication in Sun ZFS
Date: Mon, 2 Nov 2009 15:26:12 -0800
Message-ID: <b269bc570911021526j52308ef8p38965c53e6120712@mail.gmail.com>
References: <934f64a20911021225o12acdb81u7a8a55afbf49963b@mail.gmail.com>
	 <5f8586d40911021251n75161177s1230f44c1a4b9917@mail.gmail.com>
	 <200911031004.57592.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911031004.57592.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 2, 2009 at 3:04 PM, Chris Samuel <chris@csamuel.org> wrote:
> On Tue, 3 Nov 2009 07:51:52 am Alex Dedul wrote:
>
> > In any way thats a nice and interesting feature, thanks! :)
>
> My concern would be that it increases the impact of a corruption of the block
> that has been de-dup'd - in other words if the block that now represents the
> same data in lots of files gets trashed then all those files have corrupt
> data. This implies that you would want to keep around at least one other copy
> of that data to be resilient in the face of corruption (checksums will let you
> detect it, but not necessarily recover from it without duplicate copies).
>
> Given that ZFS prides itself on detecting errors it would be strange if they
> hadn't considered this in the implementation but I couldn't see any mention of
> it.

In the PSARC description and mailing list thread, there's mention of a
setting for how many references before another copy of the block is
kept.  The default was going to be 100.  So after 100 references to
the same block, a second copy of the block would be stored on disk.
After 200 references, a third copy of the block would be stored on
disk.  And so on.

There was some confusion on whether or not the 100 would be the
minimum or the maximum, though.

Either way, the admin sets the policy for how many extra copies to
keep around.  And it would play nicely with the "copies=X" setting as
well (ie if copies=2, then you'd start with 2 copies of each deduped
block, and after 100 references, you'd store 2 more copies on disk,
and so on).

--
Freddie Cash
fjwcash@gmail.com
