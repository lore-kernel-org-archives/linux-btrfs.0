From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs git repos available
Date: Thu, 25 Sep 2008 21:08:01 -0400
Message-ID: <1222391281.7028.109.camel@think.oraclecorp.com>
References: <1222282963.7160.210.camel@think.oraclecorp.com>
	 <1222376788.7028.83.camel@think.oraclecorp.com> <48DC01B7.50408@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48DC01B7.50408@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-09-25 at 14:25 -0700, Zach Brown wrote:
> > Well, after some hints from Linus I've rebased these about 4 times =
now.
> > The new changesets are generally cleaner and are setup properly und=
er
> > fs/btrfs.
>=20
> Can you publish these hints somewhere?

Step one was to have all the changes from hg in git.  David Woodhouse
has been maintaining git copies of the btrfs repos for a while, so that
part was done for me.

Most of the hints come from man git-filter-branch.  Here's what was
wrong with the btrfs repos.

1) The btrfs repo had .hgtags and .hginore files in the changeset
history.  This wasn't horrible, but not too pretty.

2) Almost none of the changesets had Signed-off-by

3) The filenames needed to be rewritten under fs/btrfs.

----
=46or 1) the man page said to:

 git filter-branch --index-filter =C2=B4git rm -f --cached filename=C2=B4=
 HEAD

Which certainly did print output, but didn't actually change the
changesets.  Instead I used the slightly slower suggestion:

git filter-branch -f --tree-filter =C2=B4rm -f filename=C2=B4 HEAD

=46or 2) I made a script that added a signed-off-by from me for any
changeset that didn't have it.  myfilter is called with the old commit
message on stdin and the new message is taken from stdout.

git filter-branch -f --msg-filter myfilter HEAD

=46or 3) Linus provided a pretty little piece of bash:

#!/bin/sh
        exists=3D$(git ls-files fs/btrfs/)
        [ -z "$exists" ] &&
                git ls-files --stage | awk -F '\t' '{ print "0 00000000=
00000000000000000000000000000000\t" $2 "\n" $1 "\tfs/btrfs/" $2 }' | gi=
t update-index --index-info

You toss this into a script and then run:

git filter-branch -f --index-filter hack-from-linus HEAD

At this point you should have shiny new commits in a git repo, all
pretending to be under fs/btrfs.  You merge them into a git repo from
mainline and all should be good.

Linus requested that I not merge at a random changeset of the day, but
use a real release.  He also asked that I not pull from mainline into
the linux btrfs repo (a backwards merge) because that makes gitk make
ugly pictures.  In general unless there's a conflict there's no need to
update the mainline side of the btrfs repo.

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
