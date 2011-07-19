From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 0/6] Move the infor for the help/man page in the source
Date: Tue, 19 Jul 2011 18:11:53 +0200
Message-ID: <20110719161049.3210.54794.stgit@venice.bhome>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following series implement a way to generate the help messages and
the btrfs man page from the sources comments for the "btrfs" commanda
.
The syntax and the detailed help of every subcommand are stored in
the comments before the function which implements the subcommand.

The fact that the help messages and the man page are generated from the 
same source should help to avoid incoherencies and mistakes.
Moreover tha fact that the source and the help are strictly linked
helps to avoid man page/help outdated.

You can pull the changes from 

You can download the source from
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

	branch extended-help

and/or browse the code at
	http://cassiopea.homelinux.net/git/?p=btrfs-progs-unstable.git

BR
G.Baroncelli

---

Goffredo Baroncelli (6):
      Add info for the commands.
      Add the header/footer/introduction of the man page.
      helpextract: tool to extract the info for the help from the source.
      Update the makefile for generating the man page.
      Show the help messages from the info in the comment.
      Update the makefile for generating the help messages.


 Makefile           |   28 +++
 btrfs.c            |  210 +++++++++++++++++++++++++
 btrfs_cmds.c       |  276 +++++++++++++++++++++++++++++++++
 helpextract.c      |  435 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in     |  359 -------------------------------------------
 man/btrfs.8.in.old |  359 +++++++++++++++++++++++++++++++++++++++++++
 scrub.c            |   79 +++++++++
 7 files changed, 1380 insertions(+), 366 deletions(-)
 create mode 100644 helpextract.c
 delete mode 100644 man/btrfs.8.in
 create mode 100644 man/btrfs.8.in.old

