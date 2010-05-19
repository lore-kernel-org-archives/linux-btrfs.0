From: "kreijack@libero.it" <kreijack@libero.it>
Subject: R: default subvolume abilities/restrictions
Date: Wed, 19 May 2010 13:56:32 +0200 (CEST)
Message-ID: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost>
Reply-To: "kreijack@libero.it" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anthony,

I think that for you may be interested to read this thread

http://kerneltrap.org/mailarchive/linux-btrfs/2009/11/20/6588643/thread

and to read a my blog about this argument

http://kreijack.blogspot.com/2010/01/linux-btrfs-example-of-layout.html

Regards
Goffredo


>----Messaggio originale----
>Da: anthony@extof.me
>Data: 19/05/2010 8.50
>A: <linux-btrfs@vger.kernel.org>
>Ogg: default subvolume abilities/restrictions
>
>hi,
>
>i'm working on an initrd hook
>[http://aur.archlinux.org/packages.php?ID=33376] to support
>non-volatile system rollbacks (promoting a temporary rollback snapshot
>to the new active/default).  when the system is installed to the
>default/"." subvolume (as many users probably initially do), it is
>more difficult/messier to manage system state; there are empty folders
>in each "child" snapshot where a subvolume used to exist (this seems
>like BUG to me, dir should not exist?) in the default subvolume. these
>grow/vary with time.  to work around this and for cleaner
>implementation, i'll intend to permanently boot a named subvolume
>[__active] (though its contents may be swapped out).  ultimately, i
>have to tell the user to manually remove the old junk (/usr, /etc,
>/var, etc...) from the default subvolume (since its really in the
>/__active subvolume)
>
>moving along to a question... can the default subvolume be
>swapped/removed/renamed/popped/shifted?
>
>what would have been useful, would be the ability to generate an
>empty, parent subvolume to _contain_ the current one, and rename it to
>__active.  btrfs gives rise to a "subroot" structure; the structure
>beneath the root.
>
>is something like this possible or can be added?
>
>an alternative idea i had was "promoting" a subvolume to be the new
>root, and anything "above" the new root is lost/forgotten.  then i
>could create the subroot structure in a subvol, snapshot the default
>subvol to where i want it, and promote the subvol to be the new root.
>like a permanent pivot_root/chroot.
>
>great stuff,
>
>C Anthony
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


