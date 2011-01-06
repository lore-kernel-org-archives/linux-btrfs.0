From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 14:41:28 +0000
Message-ID: <4D25D498.4050709@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <ig4bur$mns$1@dough.gmane.org> <20110106142059.GA13178@domone>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110106142059.GA13178@domone>
List-ID: <linux-btrfs.vger.kernel.org>

Ond=C5=99ej B=C3=ADlka wrote:

>>> Then again, for a lot of use-cases there are perhaps better ways to
>>> achieve the targed goal than deduping on FS level, e.g. snapshottin=
g or
>>> something like fl-cow:
>>> http://www.xmailserver.org/flcow.html
>>>
> As VM are concerned fl-cow is poor replacement of deduping.

Depends on your VM. If your VM uses monolithic images, then you're=20
right. For a better solution, take a look at vserver's hashify feature=20
for something that does this very well in it's own context.

> Upgrading packages? 1st vm upgrades and copies changed files.
> After while second upgrades and copies files too. More and more becom=
es duped again.

So you want online dedupe, then. :)

> If you host multiple distributions you need to translate
> that /usr/share/bin/foo in foonux is /us/bin/bar in barux

The chances of the binaries being the same between distros are between=20
slim and none. In the context of VMs where you have access to raw files=
,=20
as I said, look at vserver's hashify feature. It doesn't care about fil=
e=20
names, it will COW hard-link all files with identical content. This=20
doesn't even require an exhaustive check of all the files' contents -=20
you can start with file sizes. Files that have different sizes can't=20
have the same contents, so you can discard most of the comparing before=
=20
you even open the file, most of the work gets done based on metadata al=
one.

> And primary reason to dedupe is not to reduce space usage but to
> improve caching. Why should machine A read file if machine B read it =
five minutes ago.

Couldn't agree more. This is what I was trying to explain earlier. Even=
=20
if deduping did cause more fragmentation (and I don't think that is the=
=20
case to any significant extent), the improved caching efficiency would=20
more than offset this.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
