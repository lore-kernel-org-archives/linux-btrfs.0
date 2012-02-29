From: cwillu <cwillu@cwillu.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Tue, 28 Feb 2012 21:16:49 -0600
Message-ID: <CAE5mzvixYURzdNX3snjjJESUNUBz316YjzDxfZe6-Q2TGBMYww@mail.gmail.com>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
	<4F4D8259.2090209@oracle.com>
	<20120229025027.GB15383@shiny>
	<CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Gurudas Pai <gurudas.pai@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Travis Shivers <ttshivers@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 28, 2012 at 9:00 PM, Travis Shivers <ttshivers@gmail.com> wrote:
> Where should I grab the source from? The main repo that you have
> listed on your main wiki page
> (https://btrfs.wiki.kernel.org/articles/b/t/r/Btrfs_source_repositories.html)
> is down: git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git

The btrfs wiki is at http://btrfs.ipv5.de .  The kernel.org one is a
static snapshot of the contents made nearly a year ago, prior to the
kernel.org break-in, and should be ignored.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git is
the development tree, although the above patch is in mainline as of
3.3rc5, which probably makes that the easiest way to try it.
