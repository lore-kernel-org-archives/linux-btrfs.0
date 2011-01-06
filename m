From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 6 Jan 2011 16:37:57 +0100
Message-ID: <20110106153757.GA14070@domone>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
 <4D24AD92.4070107@bobich.net>
 <ig4bur$mns$1@dough.gmane.org>
 <20110106142059.GA13178@domone>
 <4D25D498.4050709@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D25D498.4050709@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 06, 2011 at 02:41:28PM +0000, Gordan Bobic wrote:
> Ond=C5=99ej B=C3=ADlka wrote:
>=20
> >>>Then again, for a lot of use-cases there are perhaps better ways t=
o
> >>>achieve the targed goal than deduping on FS level, e.g. snapshotti=
ng or
> >>>something like fl-cow:
> >>>http://www.xmailserver.org/flcow.html
> >>>
> >As VM are concerned fl-cow is poor replacement of deduping.
>=20
> Depends on your VM. If your VM uses monolithic images, then you're
> right. For a better solution, take a look at vserver's hashify
> feature for something that does this very well in it's own context.
>=20
> >Upgrading packages? 1st vm upgrades and copies changed files.
> >After while second upgrades and copies files too. More and more beco=
mes duped again.
>=20
> So you want online dedupe, then. :)
>=20
> >If you host multiple distributions you need to translate
> >that /usr/share/bin/foo in foonux is /us/bin/bar in barux
>=20
> The chances of the binaries being the same between distros are
> between slim and none. In the context of VMs where you have access
> to raw files, as I said, look at vserver's hashify feature. It
> doesn't care about file names, it will COW hard-link all files with
> identical content. This doesn't even require an exhaustive check of
> all the files' contents - you can start with file sizes. Files that
> have different sizes can't have the same contents, so you can
> discard most of the comparing before you even open the file, most of
> the work gets done based on metadata alone.
>=20
Yes I wrote this as quick example. On second thought files shared=20
between distros are typicaly write-only(like manpages)

>
> >And primary reason to dedupe is not to reduce space usage but to
> >improve caching. Why should machine A read file if machine B read it=
 five minutes ago.
>=20
> Couldn't agree more. This is what I was trying to explain earlier.
> Even if deduping did cause more fragmentation (and I don't think
> that is the case to any significant extent), the improved caching
> efficiency would more than offset this.
>=20
> Gordan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

Program load too heavy for processor to lift.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
