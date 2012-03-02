From: Sander <sander@humilis.net>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Fri, 2 Mar 2012 13:25:40 +0100
Message-ID: <20120302122540.GA10972@attic.humilis.net>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
 <1330484376-16178-2-git-send-email-anand.jain@oracle.com>
 <CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
 <20120302113421.GA6214@suse.de>
 <CAE5mzviFyib_=a5Yd_cegxTA7aAj3EQCPbXMK3fXk7Qx_A+37A@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arvin Schnell <aschnell@suse.de>, linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzviFyib_=a5Yd_cegxTA7aAj3EQCPbXMK3fXk7Qx_A+37A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

cwillu wrote (ao):
> > While developing snapper I faced similar problems and looked at
> > find-new but unfortunately it is not sufficient. E.g. when a file
> > is deleted find-new does not report anything, see the reply to my
> > mail here one year ago [1]. Also for newly created empty files
> > find-new reports nothing, the same with metadata changes.

> For a system-wide undo'ish sort of thing that I think autosnapper is
> going for, it should work quite nicely, but you're right that it
> doesn't help a whole lot with a backup system.  It can't tell you
> which files were touched or deleted, but it will still tell you that
> _something_ in the subvolume was touched, modified or deleted (at
> least, as of the last commit), which is all you need if you're only
> ever comparing it to its source.

Tar can remove deleted files for you during a restore. This is (imho) a
really cool feature of tar, and I use it in combination with btrfs
snapshots.

https://www.gnu.org/software/tar/manual/tar.html#SEC94

"The option `--listed-incremental' instructs tar to operate on an
incremental archive with additional metadata stored in a standalone
file, called a snapshot file. The purpose of this file is to help
determine which files have been changed, added or deleted since the last
backup"

"When extracting from the incremental backup GNU tar attempts to restore
the exact state the file system had when the archive was created. In
particular, it will delete those files in the file system that did not
exist in their directories when the archive was created"

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
