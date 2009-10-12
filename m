From: jim owens <jowens@hp.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 14:07:22 -0400
Message-ID: <4AD3705A.5000000@hp.com>
References: <4A74401B.90801@mccme.ru> <87my3y3r8u.fsf@faran.nsc.liu.se> <4AD35667.3020103@hp.com> <200910121909.56545.kreijack@alice.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@alice.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910121909.56545.kreijack@alice.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> I don't know a software which need so many hard links. But it easy to find 
> some similar cases.
> 
> For example under my "/usr/bin" I have 478 _"soft links"_ to _different_ 
> files.

Hard link is not used in place of soft link... soft link is
a different and preferred addition to posix style systems.

So don't think we need more hard links just because you find
apps using soft links.

> When a directory is created, its ".." entry is a hard link to the "parent" 
> directory. For example the /usr/share/doc directory has 2828 "hard links" 
> because it has 2826 children directories.

Max subdirectories per directory is again a different feature.

btrfs does not use "hard link count" for subdirectories.

That association of "hard links-2" == "max subdirs" is only a legacy
of the design of some filesystems such as UFS.

> These cases are different cases. But the 311 "hard link to the same file under 
> the same directory" limit may be too strong. Not now but in the next format 
> change I think that it would be useful to remove this limit.

I would agree if the cost was 0, but it increases a field size so
it would be nice to have a justified need.  But it is Chris's call.

jim
