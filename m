From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFC] Subvolume Quota on-disk structures and configuration
Date: Mon, 21 Nov 2011 11:06:57 -0500
Message-ID: <4ECA7721.3040607@cfl.rr.com>
References: <4E19611D.2090007@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E19611D.2090007@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 7/10/2011 4:21 AM, Arne Jansen wrote:
> btrfs qgroup limit [--exclusive] <size>|none <qgroupid> <path>
>
> This sets actual limits on a qgroup. If --exclusive is given, the
> exclusive usage is limited instead of the referenced. I don't know
> if there are use cases where both values need a (possibly different)
> limit. <path> means the path to the root. Instead of "<qgroupid>
> <path>", a path to a subvolume can be given instead.
>
> btrfs qgroup create <qgroupid> <path>
> btrfs qgroup destroy <qgroupid> <path>
> btrfs qgroup assign <childid> <parentid> <path>
> btrfs qgroup remove <childid> <parentid> <path>
>
> These 4 commands are used to build hierarchical qgroups and are only
> for advanced users. I'll explain more of the concepts in a later
> paper.
>
> The main point here is that in the simplest case, a user creates a
> filesystem with initial quota support, creates his /var /usr /home
> etc. subvolumes and limits them with commands like
>
> btrfs qgroup limit 10g /usr
>
> That should be simple enough for the common use case.

Wouldn't that make the syntax above actually be:

btrfs qgroup limit [--exclusive] <size|none> [qgroupid] <path>

Since the qgroupid is optional?  And the meaning of path depends on 
whether or not qgroupid is specified.  With qgroupid, path is anywhere 
on the fs, but without it, it specifies the path of the implicit 
qgroupid, right?

I also have a question about the interactions with groups of groups. 
Say I have 4 subvolumes: 1, 2, 3, and Z.  I group the first 3 volumes 
and set a limit on them.  Now if all 3 volumes share a chunk of space, 
that space should only count towards the group once, rather than 3 
times.  You might think the solution to that is to use the exclusive 
limits, but that would mean that any space volume 3 and volume Z share 
would not be counted in the group at all.  I don't care about volume Z 
since it is not part of the group, yet it can influence the used space 
of the group.  Likewise, if I set an exclusive limit on the group, and 
then create snapshot Y from subvol 2, that would significantly reduce 
the exclusive charge for the group, and we don't want that.
