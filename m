From: Jens Rosenboom <j.rosenboom@syseleven.de>
Subject: Re: btrfs lacking inode or file count?
Date: Tue, 08 Mar 2011 10:45:07 +0100
Message-ID: <4D75FAA3.7090309@syseleven.de>
References: <4D75052D.7050704@syseleven.de> <alpine.DEB.2.01.1103070935550.23816@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1103070935550.23816@trent.utfs.org>
List-ID: <linux-btrfs.vger.kernel.org>

Am 07.03.11 18:38, schrieb Christian Kujau:
> On Mon, 7 Mar 2011 at 17:17, Jens Rosenboom wrote:
>> I'm just starting to do some testing with btrfs and I noticed that "df
>> -i" doesn't give any sensible output:
> 
> Btrfs has dynamic inode allocation (like zfs), so it (should) never runs 
> out of "available inodes" (only "out of space"). 
> It's a feature, not a bug :-)

Dynamic inode allocation surely is a nice feature, but easily being able
to get the total number of files in a file system is another one and I
am missing the latter.

For subvolumes it might probably be related to
https://btrfs.wiki.kernel.org/index.php/UseCases#How_I_can_know_how_much_space_is_used_by_a_volume.3F
but if there would be a way to compute the number of files in a
subvolume more easily, that might be a useable first order approximation
of space usage.

FWIW, it seems that ZFS can give away all these data[1] rather easily,
so it doesn't look to me like the lack of these features is a direct
consequence of having dynamic inode allocation. Either there is another
design decision that has this effect, or it is just lack of
implementation. (And in the latter case I might hope for this to change.)

[1] Number of files, total space used by a snapshot, space uniquely used
by a snapshot - the latter will correspond to the space that can be
freed by deleting the snapshot

