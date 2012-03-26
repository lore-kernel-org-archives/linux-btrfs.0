From: Alexander Block <ablock84@googlemail.com>
Subject: State of btrfs send/receive
Date: Mon, 26 Mar 2012 17:46:40 +0200
Message-ID: <CAB9VWqBM3n6ACp8tx42zwzyLyme-HXB-Ag-t0JMhZBjKjjwwcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I used btrfs some time to do incremental backups of large (200GB) VM
images, which worked fine using snapshots and rsync (with --inplace to
preserve COW).
The only problem with this solution is that it takes extremely long
due to rsync's performance on large files. For this reason, I can't
await the btrfs send/receive feature.
The latest discussion regarding send/receive that I know about is this one:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/12318/focus=12340

So my question is, especially to Jan Schmidt, are there any news on
this feature?

If there is no progress yet, would it be possible to create
send/receive like features entirely in
userspace at the moment, without touching too much kernel code? I
remember that I've read a
discussion some time ago about missing data for directory changes when
using find-new.
The discussion did not mention if this is a problem of the find-new
command or a problem of the
currently offered apis to the userspace? Is this still the case (or
was it ever?) and are there
any other pitfalls that I may come across while implementing a
send/receive like tool in userspace.
I'm asking because I'm not that experienced in kernel programming to
actually add features on
the kernel side.

Alex.
