Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1592D2C3251
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787336325; cv=none; b=W1Vt+g5HdYRIVsJxIcLTsI2llo5uncWZg9V0rAp0VD2T7LyYTt9s+LdrnHjPOfiPfeW6g6no6l760VKBawawC8rlAW5N7r8cBUxu3uA5HZS2Wsf52aIhvAoCiIYQiWCRiBah9O4csCIxGVMqX5BkEj7n/S+JqjARcAeiLf2Itz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787336325; c=relaxed/simple;
	bh=wdL5Pa5ogdkQDkpWOwr27FcsAWbzaPofpZokr2JuCfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cR/JkcjM1xLV8aEOFFa4046o4pt5KsQ4++u2td354xcGcZNW84IT/KcjVCdXpCdpoWfbCfwPAwObo7RHHKjPj42UnJktt7syak7kVKaDPgO4TrljC73mDhoHZixmdmYUQbdJxU93l2nDuPUEt11wFl5t+3SjGceVYNhyTENCO7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKxTQfH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKxTQfH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF721F00A3A
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 18:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787336323;
	bh=ZL0s2DLV1CIOMc1XLoOqTvlIbkQDNzFoLp7ohizLdoA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MKxTQfH5km1TQOybfqcB6Ca1ZoYy5RfR+AJEXKNV3vo+X/iDoA9kg6FmCSoiPLZX5
	 e63vRDTFUobJ/3wKtHyLJRW3R1OEnR6VEJE5edYluiE10zqWAZ0yQh57elSZQjYKJS
	 c0pweMvsPLXdXCvtYUPdU9eHZBwS4CX/6iyzxAMyvqtLmL9VIVfywWul1y6gVasumP
	 gEQKDkZKPaim73i2BtqOS0C9caWS4VlYmYpKVX0LKpU+yNmGouTtySHKizPlYthITP
	 VdZJji3UPG8hi5PNkpnzhUHoo67kz4iyzqSdjad3IVvUWzn7YwA+l3vjfctIVU6+Nb
	 YYe7T5/Me2ugA==
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-97bf910aa70so344475241.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 11:18:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpMleyfzdE2d1lRkcp55X6CcXm9JlcFvLCdSgZgSQfoKWuZDq92/Xy1wnEkrC4QwpHSE1tZQ/Z80YN2Cg==@vger.kernel.org
X-Gm-Message-State: AFuF++kGmR7YZgvKS39IMffR47d3omEnKnnLoVmoZSv37xF+CiF72SD/
	vf0b/CMY/1fliabUcskaRvpKhCA7pXISYwCHpbyK+Qa+LpyZZLCzEbgNeqAkkqBic6xwW2hRUlU
	GC+tKwOCUak0C2YgjFNo+mCI2dM5N1E0=
X-Received: by 2002:a05:6102:d89:b0:77b:b14e:b6c8 with SMTP id
 ada2fe7eead31-77bd3c8ae42mr92653137.14.1787336323009; Fri, 21 Aug 2026
 11:18:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
 <CAL3q7H4MW6AXhz=EnEawJNU_OEFVqdeXUaivY30cb1Lqxeqdfg@mail.gmail.com> <aohiK3N9IVncuRbI@gmail.com>
In-Reply-To: <aohiK3N9IVncuRbI@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 21 Aug 2026 19:18:07 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5=9aXtq8P6MF=QRqYMgaKZMsLHcO-VP1x9geATvOdkAg@mail.gmail.com>
X-Gm-Features: AcwNN1Vu7GocER1Itsun6bNXGmARuYS1N75Gy0dVTOZsdowCNyORUIYLC4SvxNM
Message-ID: <CAL3q7H5=9aXtq8P6MF=QRqYMgaKZMsLHcO-VP1x9geATvOdkAg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: skip the extent map tree lock for inodes without
 extent maps
To: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, fdmanana@suse.com, boris@bur.io, 
	wqu@suse.com, layton@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 5:07=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Hello Filipe,
>
> On Fri, Aug 21, 2026 at 12:17:26PM +0100, Filipe Manana wrote:
> > On Fri, Aug 21, 2026 at 11:39=E2=80=AFAM Breno Leitao <leitao@debian.or=
g> wrote:
> > > +               if (!READ_ONCE(tree->root.rb_node))
> >
> > Please use the proper rbtree api to check if a tree is empty:
> >
> > RB_EMPTY_ROOT(&tree->root)
> >
> > That's a lot more elegant and hides the use of READ_ONCE().
> >
> > But really when there are harmless races, I like to see an explicit
> > data_race() annotation and a comment about why the race is harmless.
> >
> > Nevertheless, first, I would like to know how much the performance
> > improvement was...
>
> Sorry for not posting it earlier.
>
> How I got into this: I've found while profiling arm64 production hosts
> that had high system utilization and : _raw_write_trylock and xa_find
> dominated, and the callchain pointed at find_first_inode_to_shrink()
> locking every inode it walks.
>
> Looking at the whole the Meta production fleet, the extent map shrinker
> is ~0.35% of non-idle kernel CPU.  Within it, and attributing callees to
> their caller, find_first_inode_to_shrink() is ~65% and the
> write_trylock() it does is ~30% of the whole shrinker. Two thirds of
> what the shrinker costs is looking for inodes that have anything to
> shrink, and half of that is a lock we do not need to take.
>
>
> micro benchmarks
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> I've hacked up a 6 GiB btrfs on a loop device, 100000 empty files
> kept open, plus 200 1 MiB files created last, so they have the highest
> inode numbers and every scan has to walk all the empty ones first.
>
> Each round drops the page cache, re-reads the data files to recreate the
> extent maps, then triggers the shrinker with "echo
> 2 > /proc/sys/vm/drop_caches". 15 rounds per run, arm64 (Neoverse V2),
> 8 CPUs, no lock debugging, cost of find_first_inode_to_shrink() from the
>  ftrace function profiler:
>
>   ns per inode walked, median of runs
>
>                           base   patched    delta
>     idle                  46.4      40.1   -13.6%
>     4 concurrent readers  47.8      38.4   -19.7%
>
> A separate build with CONFIG_LOCK_STAT, same test, for the extent map
> tree rwlock.  Note the shrinker is not the only user of that lock, every
> extent map insert and lookup takes it too, which is why the acquisition
> count drops by two thirds rather than to nothing:
>
>                               base   patched    delta
>     write acquisitions      628016    228000   -63.7%
>     hold time total (us)     47512     22717   -52.2%
>     acq cacheline bounces     1574      1288   -18.2%
>
> Does it help?

Yes, and all that should be in the changelog.

Thanks.
>
> Thanks for the quick reply,
> --breno
>
