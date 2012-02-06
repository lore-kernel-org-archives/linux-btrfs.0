From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Accidental formatting
Date: Mon, 6 Feb 2012 09:42:30 +0100
Message-ID: <CAMthOuO-_fB41=0AdzNaUt_U6D+7ueav5MK7mgAOdeiS2GmM0w@mail.gmail.com>
References: <4F2F4BF9.7070609@gmail.com>
	<5pc409-hou.ln1@hurikhan.ath.cx>
	<CAD8hrTPmcuac6wtJPR=pHES1gQJ2Q+ft8OmNOOKopMQKmV+8qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Farz Hem <fahhem2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAD8hrTPmcuac6wtJPR=pHES1gQJ2Q+ft8OmNOOKopMQKmV+8qA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

It seems you didn't reply to the list (at least Gmail doesn't tell me
"via vger.kernel.org", I cc'ed your email address)... I've added the
list again.

Anyway, here's my comment on this:

2012/2/6 Farz Hem <fahhem2@gmail.com>:
> I thought of corrupting my tree root, but I ran "btrfs-debug-tree" and
> didn't see any tree root backups mentioned. On the youtube where Avi Miller
> mentioned it, he used "btrfs-debug-tree -R" but the version of btrfs-tools
> that I have available, as well as any I could compile from sources from the
> kernel wiki, didn't have a -R option. Either way, I'm not sure there is a
> root tree backup since I initially created the btrfs on a 3.0.0 kernel. I
> can run a 3.0.0 or 3.2.0 kernel on the new system as necessary.

I think Avi was using a pre-release version of the new btrfs-progs
from Chris which are soon to be released. I've watched that video,
too. But you are right, root tree backups are in btrfs only since 3.2
so if you never booted that kernel before purging the filesystem,
there are no backups.

> I'll try running photorec tomorrow, thanks for the pointer to that. Of
> course, a btrfs-specific way, such as using an older root tree, would be
> better since I'd get a higher signal-to-noise ratio on returned files.

I think photorec will expect the files to be continous so it will
probably return old versions of files (before COW'ed) or junk blocks
within the files. You should carefully check your important files
after finding them.

So in conclusion, photorec is probably your best chance (except trying
Josef's rescue uitility, see his btrfs-progs tree on Github[1]). The
rescue/restore utility is afair only in the unstable tree[2] which is
missing support for compression but you can copy that utility over to
the master tree without problems and modify the Makefile accordingly.

[1] https://github.com/josefbacik/btrfs-progs
[2] https://github.com/josefbacik/btrfs-progs/tree/unstable
