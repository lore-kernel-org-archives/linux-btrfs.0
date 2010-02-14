From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH 0/2] btrfs: a new tool to manage a btrfs filesystem
Date: Sun, 14 Feb 2010 16:39:32 +0100
Message-ID: <201002141639.32634.kreijack@libero.it>
References: <57271D7A-6077-4DAF-9B21-B3CFD99B9C3B@kupper.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Thomas Kupper <thomas@kupper.org>,
	Mike Fedyk <mfedyk@mikefedyk.com>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <57271D7A-6077-4DAF-9B21-B3CFD99B9C3B@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

On Sunday 14 February 2010, Thomas Kupper wrote:
> Hi Goffredo,
> 
> Great work! It is indeed much easier to work with one tool instead with the 
many of them!
> 
> > Usage:
> >         btrfs snapshot|-s <source> [<dest>/]<name>
> >                 Create a writeble snapshot of the subvolume
> >                 <source> with the name <name> in the <dest>
> >                 directory.
> >         btrfs delete|-D <subvolume>
> >                 Delete the subvolume <subvolume>.
> 
> 
> I backup up Mike on the opinion that the short options aren't what I would 
expect. Personally I'd prefer a command line syntax like git, "<command> 
<action> [sub-action> <options>|<arguments] ...".

I don't think that git may be used as examples of "good user interface". Sorry 
but I was a fan of bazaar :-)

Seriously, you (as also Michel and Mike) raised some concern about the command 
line syntax. The main issues are:
1) possible mistaken between the '-d' (delete) command and '-D' (defrag) 
command. It was suggested to remove the short form command.
2) some commands are not very auto-explainant

Regarding the point #1, I am against about removing the short command ('-
s'...). If someone fears to mistake, he has the option to use the log form 
command. But I don't see any reason to force all others peoples to use the 
long form command.
If there is an agreement I am open to rename the command "-D/delete" in order 
to reduce the conflict. For examples the -D/delete command may be renamed as -
R/remove. The conflict with the -r/resize command is not a problem because the 
former requires 1 arguments, the latter two. Another renaming option may be -
E/erase.

Regarding the point #2, I don't think that the command in btrfs are so much to 
require a multilevel command (btrfs subvolume delete, btrfs subvolume create 
...). Moreover there is no difference between removing a snapshot and a sub-
volume, both from a implementation POV and from a logical POV.
Again I am open to rename "create" in "subvolume" if it seems more auto-
explainant.

BR
G.Baroncelli

> Example:
> -> deletion of a subvolume : $ btrfs subvolume delete <subvolume>
> -> creation of a snapshot : $ btrfs snapshot create <source [<dest>/] <name>
> Or maybe no <subaction> but actions like "subvolume-delete" and a shortcut 
like "svd", and "snapshot-delete" with a shortcut like "ssd" or "ss-del"
> 
> I think that your current syntax is not that intuitive because it's not 
clear without reading the man page what - for example - '$ btrfs create' does. 
One could think that it creates a btrfs-formated device, or it creates a 
subvolume or a snapshot. The same with delete, I guess you get my idea :)
> I'm aware that the syntax you've chosen is based on how the zfs command is 
working. And that's of course a strong argument for the syntax you've chosen 
:)
> 
> The git approach would IMHO by a good one, maybe even let the user allow a 
.btrfsconfig or .btrfsrc file in which users can define alias (shortcuts). The 
benefit of a git-like syntax is the extensibility : whatever functionality 
gets added to btrfs it will never interfer/confuse with the existing ones. The 
downside (w/o alias) is rather long command lines (which I don't mind because 
I find it harder to remember all the shortcuts).
> 
> 
> Thanks for your work and have a good day,
> Thomas--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
