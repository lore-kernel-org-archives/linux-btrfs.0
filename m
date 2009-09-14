From: Michel Alexandre Salim <michael.silvanus@gmail.com>
Subject: Separate mount options for subvolumes?
Date: Mon, 14 Sep 2009 15:55:39 -0400
Message-ID: <615c05430909141255s614702deu44e42bbb7f7cd169@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

It is my understanding that currently, the only difference between
subvolumes and snapshots are that snapshots share a root with an
existing tree, while subvolumes start off empty.

There is an interesting use case difference, though: because a
subvolume by definition cannot share data with other subvolumes, that
frees it up to being mounted with different options (e.g. nodatasum,
nodatacow).

The reason I'm wondering is that I just switched my home directory to
btrfs, and one of my machine is often used for rebuilding RPMs (for
initial testing, before getting it built on a build server). The data
is never kept for a long time, and so checksumming and COW would just
slow things down.

Would this be possible, and if so, is it planned for implementation by 1.0?

Thanks,

-- 
Michel Alexandre Salim
