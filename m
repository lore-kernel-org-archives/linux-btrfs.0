Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:38010 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388909AbeIUPee (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 11:34:34 -0400
Subject: Re: [RFC PATCH v2 0/4] btrfs-progs: build distinct binaries for
 specific btrfs subcommands
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
References: <20180912144604.6178-1-axel@tty0.ch>
 <3ceee37e-66f5-e2f8-dbc9-fde2452a6447@tty0.ch>
 <pan$1f31c$d7f59d13$3b6f50b9$200a6f62@cox.net>
From: Axel Burri <axel@tty0.ch>
Message-ID: <de48e007-451e-6094-c4c6-ee1662ff3836@tty0.ch>
Date: Fri, 21 Sep 2018 11:46:37 +0200
MIME-Version: 1.0
In-Reply-To: <pan$1f31c$d7f59d13$3b6f50b9$200a6f62@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/09/2018 10.32, Duncan wrote:
> Axel Burri posted on Thu, 20 Sep 2018 00:02:22 +0200 as excerpted:
> 
>> Now not everybody wants to install these with fscaps or setuid, but it
>> might also make sense to provide "/usr/bin/btrfs-subvolume-{show,list}",
>> as they now work for a regular user. Having both root/user binaries
>> concurrently is not an issue (e.g. in gentoo the full-featured btrfs
>> command is in "/sbin/").
> 
> That's going to be a problem for distros (or users like me with advanced 
> layouts, on gentoo too FWIW) that have the bin/sbin merge, where one is a 
> symlink to the other.

I think you got me wrong here: There will not be binaries with the same
filename. I totally agree that this would be a bad thing, no matter if
you have bin/sbin merged or not, you'll end up in either having a
collision or (even worse) rely on the order in $PATH.

With this "separated" patchset, you can install a binary
"btrfs-subvolume-show", which has the same functionality as "btrfs
subvolume show" (note the whitespace/dash), ending up with:

    /sbin/btrfs
    /usr/bin/btrfs-subvolume-show
    /usr/bin/btrfs-subvolume-list

thus allowing a user to run "btrfs-subvolume-show" while "btrfs" is
still only visible for root. With /usr merge it would look like this:

    /bin/btrfs
    /bin/btrfs-subvolume-show
    /bin/btrfs-subvolume-list


What I'm thinking of is a distro package which installs the separated
binaries, either with suid/fscaps (if the admin wants to provide their
users with non-restricted versions of specific commands), or without
special flags (if the admin wants to just provide the binaries that also
work for non-root user, enabled by Misono's patchset.

See my gentoo ebuild:
https://github.com/digint/gentoo/tree/btrfs-progs-separated/sys-fs/btrfs-progs-separated


> 
> FWIW I have both the /usr merge (tho reversed for me, so /usr -> . 
> instead of having to have /bin and /sbin symlinks to /usr/bin) and the 
> bin/sbin merge, along with, since I'm on amd64-nomultilib, the lib/lib64 
> merge.  So:
> 
> $$ dir -gGd /bin /sbin /usr /lib /lib64
> drwxr-xr-x 1 35688 Sep 18 22:56 /bin
> lrwxrwxrwx 1     5 Aug  7 00:29 /lib -> lib64
> drwxr-xr-x 1 78560 Sep 18 22:56 /lib64
> lrwxrwxrwx 1     3 Mar 11  2018 /sbin -> bin
> lrwxrwxrwx 1     1 Mar 11  2018 /usr -> .
> 
> 
> Of course that last one (/usr -> .) leads to /share and /include hanging 
> directly off of / as well, but it works.
> 
> But in that scheme /bin, /sbin, /usr/bin and /usr/sbin, are all the same 
> dir, so only one executable of a particularly name can exist therein.
> 
