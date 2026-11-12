Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=174.142.148.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794464111;
	b=4FAHDjV53mZd8hRyVvaYCkm6LC8Wtw1Mb1Yr89l6pKCt+HR42uF6h5+Pkb3W+0iN3oaM
	 2244vsC29BXHsCkgW8sWNCjKmOnH48hG/IKR2lrTfs/7dqJ1lhJbUTrFJ5yYAM+p4YVR1
	 EFWACUiSdHRthsvE/NinXfGZuJ/UVlF95nmPPDvGtyH7zIvwzUhmmWzevcK2d04HjTshU
	 FdXqT23SintAjxhiv51hB+PoVHWePdqFRaE8G/NZPGVwQyhWXNnOwwZFTh4YZXRZshQNi
	 MNRUQzt51ZCciOck9tJWS0dADSe+BA79W1r1Ps0OsGxKldyL1UqEc1MgAihq25Tnp3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794464111;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=BHQpga73EjDTxLR8w3Ak9ObnoV8jrlpHl+BtnwgUHTQ=;
	b=RU/ET/I6dVjRDzuOpxmUsfuIH/dGNyoLsiPXyutJRrabjsVRlWJ67PR51ayWQ8kJcsVv
	 OQx2tqoPVTJBA3E7PzF+ZkvhTiBNRQwthsFEDMjoVuUM/5gIpmw2g6TMcvA7S9JgQX7sR
	 DOokInbGk5PzKq5rbbFtgf5gEmhoE82hwD94UC+40beQV4lc/gP5V46Ho/+DV1JOFeMg0
	 v+zm02rHUzVxbRJFNuQjlBKPZVGCcOVoTlf8V6EFSTcVYMm9vYLMEnQX+i5muWeUxEIPj
	 mihHBMZrIiOm/vS+wKwE2yUXMVa31fRBw7YHhD5loLd3i86ZARMlWtR+5G1eSjrsNVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=furryterror.org;
	spf=pass smtp.mailfrom=furryterror.org;
	arc=none smtp.remote-ip=174.142.148.226
Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C843D606A331
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 06:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C843D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=furryterror.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id 037491CC941E; Thu, 12 Nov 2026 01:15:03 -0500 (EST)
Date: Thu, 12 Nov 2026 01:15:03 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: koraynilay <koray.fra@gmail.com>
Cc: Sterling Windmill <sterling@ampx.net>, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>
Subject: Re: [RFC] btrfs: forcing compression per inode via the compression
 property?
Message-ID: <avVZZ-u8kmaDyaSb@hungrycats.org>
References: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>
 <DMQQG1D324U7.2945KG0ANDDJZ@gmail.com>
 <5225511a-c66f-40e5-b9d6-31ff572496da@app.fastmail.com>
 <DMQYN0GE281B.1PW8AIHGLUNDF@gmail.com>
 <bebe248b-8eb5-48f3-8dc7-ddaf8e4a09c4@app.fastmail.com>
 <DMRFBAXJM4OA.CV6LZNBPYR7J@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DMRFBAXJM4OA.CV6LZNBPYR7J@gmail.com>

On Tue, Nov 10, 2026 at 10:29:16AM +0100, koraynilay wrote:
> On Tue Nov 10, 2026 at 3:50 AM CET, Sterling Windmill wrote:
> >> I read the code a bit (and bounced some ideas with gemini) and I think a
> >> "force:algo:level" would work well.
> >>
> >> This, compared to "algo:level:force", would also allow a "force" value
> >> (handled like "none" is already handled), that lets the user set *only*
> >> the compress-force, without having to specify algo:level, so inheriting
> >> from -o compress=, and the parsing would be as simple as if ("force")
> >> str += 6, where str is the xattr string that gets then parsed by the
> >> rest of the code (in compression_apply()).
> >
> > Thanks, a bare "force" value is a nice thing to have, and I agree the
> > separate property isn't worth it.

There is a symmetric gap to be filled here:  currently, there is no way
for individual files to opt out of a compress-force mount.  The force
mount option is checked first, so a compression attribute that says "none"
(or chattr +m) is ignored, and the file is compressed anyway (along with
all the side-effects that come with force, like 512K maximum uncompressed
extent size).

> > From reading the code only, a few things stand out for the bare
> > "force" case, where prop_compress would stay 0:
> >
> > - compress_file_range() starts from fs_info->compress_type, so on a
> > filesystem mounted without compress= there is no algorithm to use.
> > It needs a defined behaviour, such as falling back to zlib as the
> > chattr +c path does, or having no effect.
> >
> > - The check at mark_incompressible only looks at FORCE_COMPRESS and
> > prop_compress, so a failed attempt would set NOCOMPRESS and leave
> > it behind after force is removed.
> >
> > - btrfs_compress_typelevel2str() returns NULL when prop_compress is
> > 0, so children wouldn't inherit it and btrfs_fileattr_set() would
> > fall back to the mount algorithm. That helper would also need to
> > emit "force" in whichever form we choose.
> 
> Ah yes, these would all need to be changed (but only small changes
> AFAICT) for a "force" patch to work.

It might be nice to refactor all of those, so one parser gives you
a struct with compress type, level, and force, or gives a complete
string with all of those written out.  It would also get rid of
the "none" special case, which can't accept a suffix.

Doing it piecemeal means that someone's going to forget a parameter
somewhere, especially if it's extended over time, which is how we got
into the current mess of partial implementation everywhere.

> > One thing I should have mentioned: Qu pointed out on v1 that older
> > kernels ignore an appended ":<level>" because apply only compares the
> > leading bytes. "zstd:3:force" would keep that property, with older
> > kernels treating it as plain zstd, while "force:zstd:3" and a bare
> > "force" would get -EINVAL from both validate and apply. Is bare
> > "force" worth that trade-off, or would the suffix be better?
> 
> I think it's a worth trade-off, and my patch series already will break
> some setups where users had "zstd:random_text" (which would be
> semantically invalid anyway).

Putting force first is more consistent with the mount option.
"compress-force=zstd:5" becomes "force:zstd:5" on the inode, almost
exactly the same string.  The mount option prefix for negation is "no", so
overriding compress-force might look like "noforce:zstd:5" on the inode.
So there's a compelling argument to put force first.

That said, I think compatibility is more important.  On an old kernel,
a file with a force prefix won't be compressed at all if the user
had set up inode attributes without mounting with a compress= option.
With a force suffix, an old kernel still gets some compression, and
also avoids possibly getting the wrong type of compression, like the
slower zlib algorithm instead of zstd.

The prefix form breaks a convention that has been present since the
attributes were introduced.  Compression type is the first argument,
which has been there since the beginning.  The next part of the string
is the level. Fedora’s documentation, among others, already describes
it that way. Those docs were wrong, but people have read them,
and some users have already filled in those strings believing they
have an effect.  Extensions using the same attribute name should go
after the parts of the string that are already defined and in use.
Those constraints together prefer "zstd:3:force" and "zstd:3:noforce"
over "force:zstd:3" and "noforce:zstd:3".

"none" rears its head here:  it uses an exact match, so "none:extension"
is not currently accepted by kernels, and "none:noforce" would mean
"use mount option compression" on an old kernel.  So that's a point in
favor of a separate attribute.

> > If we go with the prefix, the match probably needs to be exactly
> > "force:", in both validate and apply, and "force:none" should be
> > rejected.

I agree with rejecting "force:none" (or "none:force"--I'll use the
prefix form here to match the text I'm replying to), although that
agreement is conditional on using a single string attribute (see
alternatives below).

"noforce:none" would mean "don't compress this file, even if
compress-force is set in the mount options."  A user might expect
"force:none" to mean "behave like compress-force with chattr +m"
(i.e. exactly the same as noforce:none), but the current compress-force
mount option behavior doesn't honor chattr +m, and "force:none" would
have to replicate what is arguably a bug to be consistent with what the
existing flags and options do.

> Yes, my current thinking is handling "force" exactly like "none"/"no" is
> handled right now, with an additional else if for "force:" which moves
> the string pointer to +6, which gets then passed to the rest of the
> checks as they are in my patch series.

If the all-in-one-attribute-string path is taken, now is the time to
lock down whether these strings have a fixed order, or if it's a set of
strings that can be present or absent.  e.g. is "3:force:zstd" valid?
If there's a compression algorithm called "shiny" with a flag "fast", is
"shiny:7:fast:force" valid, or only "shiny:7:force:fast", or do we make
every compression algorithm squeeze all of its parameters into a single
integer level?  Or will it be a free-for-all, with any order accepted on
input, and all fields optional, so "noforce" by itself is a valid string,
and a user can write "7:force:zstd" or even "5"?

A separate attribute avoids the parsing problem, but trades it for
an ordering problem.

"btrfs.force-compression" could be "yes", "no", or unset (for "look up
the mount option").  A new attribute gets a new name and doesn't touch
the old string parser.  Each of the force strings means something to
a kernel that knows the attribute name.  They are ignored by a kernel
that doesn't know the attribute name, and old kernels can still use the
attributes they do recognize.  Applications work the same way, using
the attributes they know and ignoring the ones they don't.

But a separate attribute forces us to reconsider combining "force" with
"none".  Order of attribute sets matters if they conflict:  a file with
force-compression=yes and compression=zstd, under a rejection rule, could
not be changed to compression=none by setting only btrfs.compression.
An application written before this patch is accepted would not know it
has to do that, so it may fail after a kernel upgrade.

The better option is to document that "force" combined with "none"
just means the same thing as "noforce" combined with "none", so all
combinations are valid.  That allows two attributes (or more extensions
in future) to be added or changed in any order without having to deal
with surprise -EINVALs, and without all the parsing issues.

For a cautionary tale about rejecting invalid option combinations,
look at what happened with conflicting combinations of chattr +C, +c,
and +m rejected by a patch in 2020 (f37c563bab42 "btrfs: add missing
check for nocow and compression inode flags").  These checks are _still_
broken in 2026, accepting invalid combinations of options while rejecting
valid ones, and requiring multiple steps to transition from one valid
flag combination to another.

> >> It should probably be a separate patch, but it'd depend on my patch
> >> series, so not sure if I should just make a v7 with that or not.
> >
> > I'd lean towards a separate patch on top rather than a v7, since this
> > is a new feature that may need its own discussion, and it shouldn't
> > hold up your series.
> 
> I think adding a force patch to my series wouldn't be a problem, as my
> series has been finalized since september, so I doubt it will change
> much in merging time.
> 
> > David, do you have a preference? And if the series isn't likely to
> > land soon, would you rather see force as a small standalone patch?
> >
> > I'm happy to write the force patch on top, or to test yours on the
> > images from my table, whichever you prefer.
> 
> Yes, please test mine and also write a patch on top of my series, I'll
> be happy to test that on my end as well.
> After that we can decide if it's better to include it in a v7 or send it
> as a standalone patch with references to my v6.
> 
> Thanks,
> koraynilay
> 
> > Thanks,
> > Sterling
> 
> 


