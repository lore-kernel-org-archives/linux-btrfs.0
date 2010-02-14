From: Thomas Kupper <thomas@kupper.org>
Subject: [PATCH 0/2] btrfs: a new tool to manage a btrfs filesystem
Date: Sun, 14 Feb 2010 11:17:29 +0100
Message-ID: <57271D7A-6077-4DAF-9B21-B3CFD99B9C3B@kupper.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

Great work! It is indeed much easier to work with one tool instead with the many of them!

> Usage:
>         btrfs snapshot|-s <source> [<dest>/]<name>
>                 Create a writeble snapshot of the subvolume
>                 <source> with the name <name> in the <dest>
>                 directory.
>         btrfs delete|-D <subvolume>
>                 Delete the subvolume <subvolume>.


I backup up Mike on the opinion that the short options aren't what I would expect. Personally I'd prefer a command line syntax like git, "<command> <action> [sub-action> <options>|<arguments] ...".

Example:
-> deletion of a subvolume : $ btrfs subvolume delete <subvolume>
-> creation of a snapshot : $ btrfs snapshot create <source [<dest>/] <name>
Or maybe no <subaction> but actions like "subvolume-delete" and a shortcut like "svd", and "snapshot-delete" with a shortcut like "ssd" or "ss-del"

I think that your current syntax is not that intuitive because it's not clear without reading the man page what - for example - '$ btrfs create' does. One could think that it creates a btrfs-formated device, or it creates a subvolume or a snapshot. The same with delete, I guess you get my idea :)
I'm aware that the syntax you've chosen is based on how the zfs command is working. And that's of course a strong argument for the syntax you've chosen :)

The git approach would IMHO by a good one, maybe even let the user allow a .btrfsconfig or .btrfsrc file in which users can define alias (shortcuts). The benefit of a git-like syntax is the extensibility : whatever functionality gets added to btrfs it will never interfer/confuse with the existing ones. The downside (w/o alias) is rather long command lines (which I don't mind because I find it harder to remember all the shortcuts).


Thanks for your work and have a good day,
Thomas