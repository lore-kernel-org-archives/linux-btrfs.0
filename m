From: C Anthony Risinger <anthony@extof.me>
Subject: default subvolume abilities/restrictions
Date: Wed, 19 May 2010 01:50:27 -0500
Message-ID: <AANLkTilY3SUN01IRz1mkKPlkMAJabJr-hYiWazPpeXsx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi,

i'm working on an initrd hook
[http://aur.archlinux.org/packages.php?ID=33376] to support
non-volatile system rollbacks (promoting a temporary rollback snapshot
to the new active/default).  when the system is installed to the
default/"." subvolume (as many users probably initially do), it is
more difficult/messier to manage system state; there are empty folders
in each "child" snapshot where a subvolume used to exist (this seems
like BUG to me, dir should not exist?) in the default subvolume. these
grow/vary with time.  to work around this and for cleaner
implementation, i'll intend to permanently boot a named subvolume
[__active] (though its contents may be swapped out).  ultimately, i
have to tell the user to manually remove the old junk (/usr, /etc,
/var, etc...) from the default subvolume (since its really in the
/__active subvolume)

moving along to a question... can the default subvolume be
swapped/removed/renamed/popped/shifted?

what would have been useful, would be the ability to generate an
empty, parent subvolume to _contain_ the current one, and rename it to
__active.  btrfs gives rise to a "subroot" structure; the structure
beneath the root.

is something like this possible or can be added?

an alternative idea i had was "promoting" a subvolume to be the new
root, and anything "above" the new root is lost/forgotten.  then i
could create the subroot structure in a subvol, snapshot the default
subvol to where i want it, and promote the subvol to be the new root.
like a permanent pivot_root/chroot.

great stuff,

C Anthony
