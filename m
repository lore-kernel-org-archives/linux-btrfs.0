From: James Cloos <cloos@jhcloos.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2260!
Date: Fri, 10 Jun 2011 00:52:24 -0400
Message-ID: <m3vcwes2xr.fsf@jhcloos.com>
References: <m3tyccay9y.fsf@jhcloos.com>
	<20110610002208.GQ12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110610002208.GQ12709@twin.jikos.cz> (David Sterba's message of
	"Fri, 10 Jun 2011 02:22:08 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "DS" == David Sterba <dave@jikos.cz> writes:

DS> confirmed, -ENOSPC == -28

So not a novel BUG_ON() after all.

On the plus side, it has not re-appeared in the 3.0 rc's.

That (4 Gig) fs currently has:

:; find /usr/local/portage|wc -l
444073

:; df /usr/local/portage
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sda12       4194304 1278124   1767252  42% /usr/local/portage

:; btrfs filesystem df /usr/local/portage/
Data: total=1.21GB, used=822.17MB
System: total=4.00MB, used=4.00KB
Metadata: total=1.51GB, used=426.00MB

Most of the files are quite small, even before compression.
About 40% are directories.

I've never run balance or defragment on that filesystem.  Should I?

(It is a single-disk, single-partition fs; it has no subvolumes;
it is mounted with rw,noatime,compress=zlib; it is in exports and
does get mounted over nfs3.)

(I take it balance is for multi-device applications?  --help uses the
singular 'the device' but the btrfs(8) man page uses the plural 'the
devices'....)

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
