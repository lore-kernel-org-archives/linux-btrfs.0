From: C Anthony Risinger <anthony@extof.me>
Subject: Replacing the top-level root
Date: Mon, 25 Oct 2010 15:20:58 -0500
Message-ID: <AANLkTiktaR6ipbH-i=kTdRvHqBdTAAcYYsdVamogifm1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 25, 2010 at 2:58 PM, Chris Mason <chris.mason@oracle.com> wrote:
>
> Oh, and it shouldn't work on the root of the FS either ;)
>
> -chris

This is not 100% related but...

Will removing [replacing] the top-level root be something that
can/will be supported?  I've asked in the past about this regarding an
initramfs hook i maintain implementing system rollbacks, but I never
really got a solid answer.

For example, right now extlinux support booting btrfs, but _only_ from
the top-level root.  if i just had a way to "swap" the top-level root
with a different subvol, i could overcome several problems i have with
users all at once:

) users install their system to the top-level root, which means it is
no longer manageable by snapshot scripts [currently]
) if the top-level root could be swapped, extlinux could then boot my
snapshot? (i'm probably wrong here)

"set-default" is not enough; i'm looking for a way to gain control
over the system state when the system has been installed into the
top-level root.  currently, i have no way to manipulate/move/change
it, because the top-level is essentially "immutable", or so it seems.

thus it's not possible to support kernel rollbacks without manually
syncing <snapshot>/boot to /boot.

is there a solution to this that i'm missing?

C Anthony
