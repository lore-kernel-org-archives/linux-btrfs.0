From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 21:46:03 +0100
Message-ID: <201012012146.03433.kreijack@libero.it>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101201150352.164007ed@tlielax.poochiereds.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201150352.164007ed@tlielax.poochiereds.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 01 December, 2010, Jeff Layton wrote:
> A more common use case than CIFS or samba is going to be things like
> backup programs. They commonly look at inode numbers in order to
> identify hardlinks and may be horribly confused when there files that
> have a link count >1 and inode number collisions with other files.
> 
> That probably qualifies as an "enterprise-ready" show stopper...

I hope that a backup program, uses the pair (inode,fsid) to identify if two 
file are hardlinked... otherwise a backup of two filesystem mounted can be 
quite danguerous...


>From the statfs(2) man page:
[..]
The f_fsid field
[...]
The general idea is that f_fsid contains some random stuff such that the pair 
(f_fsid,ino) uniquely determines a file.  Some operating systems use (a 
variation on) the device number, or the device number combined  with  the  
file-system  type.   Several  OSes restrict giving out the f_fsid field to the 
superuser only (and zero it for unprivileged users), because this field is 
used in the filehandle of the file system when NFS-exported, and giving it out 
is a security concern.


And the btrfs_statfs function returns a different fsid for every subvolume.

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
