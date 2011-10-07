From: cwillu <cwillu@cwillu.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 7 Oct 2011 13:29:25 -0600
Message-ID: <CAE5mzvj=KieP3P1gYe3Eb8L+UCjQHEKyh1a0SAxr9vdhvT-WTQ@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<4E5FE9FC.9040705@cchtml.com>
	<20110901203442.GA17928@carfax.org.uk>
	<201109101209.40759.Martin@lichtvoll.de>
	<CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
	<20111005061628.GA3702@shiny.elevennetworks.com>
	<CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
	<20111005145843.GA4770@shiny.elevennetworks.com>
	<CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
	<CAAE6i0i-AsH7TkupkrFDdv26gN_-pshFFwvuH1nOuuSmKWbZdQ@mail.gmail.com>
	<4E8F4EA9.4090108@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chester <somethingsome2000@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8F4EA9.4090108@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

> What I would like to know instead, is WHY we need an btrfsck when ZFS does
> not. Zfs also has this kind of problems especially on power failures, but
> you can always mount by rolling back to a previous uberblock, showing an
> earlier view of the filesystem, which would be consistent.
>
> It wasn't always like this with ZFS, but this "feature" has been added after
> ther numerous requests of users who lost their complete filesystems after a
> power failure or similar events. And there was no zfsck (there still isn't,
> and it's apparently not needed).

There's a couple different categories of tool that are occasionally
referred to as "fsck".  Consistency checking (which we already have in
the current btrfsck), data recovery (which we have a couple rough
tools for, but which improved tools are desired and probably part of
cmason's plans), transparent healing making the filesystem always
mountable (the big selling point of both zfs and btrfs, although
obviously btrfs is still immature in this regard; again, something
that progress is expected on), in-place "rebuild the world" repair
tools (which again I believe is part of cmason's plans), online scrubs
(which we have), and so on.

You'll note that zfs now has all of these tools (and took a remarkable
amount of time to acquire some of them), they just never call any
combination of them "zfsck".  Really, zfs doesn't require fsck in
exactly the same sense that ext3 doesn't:  given hardware that doesn't
lie to the filesystem, there's no massive "search and rescue"
operation required after an otherwise unclean shutdown.  That's it.
And we mostly have that too, modulo the usual and expected bumps of a
very young filesystem.

--cwillu

Warning:  cwillu may cause excessive warnings.
