From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mark btrfsctl deprecated
Date: Tue, 26 Oct 2010 15:53:57 -0400
Message-ID: <20101026195357.GH13254@think>
References: <22986774.2784821287748969875.JavaMail.defaultUser@defaultHost>
 <AANLkTimiuTM02Dnue_3NdC+uLbCMP9hEjfrp_4efFbGe@mail.gmail.com>
 <201010261932.15023.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010261932.15023.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 26, 2010 at 07:32:14PM +0200, Goffredo Baroncelli wrote:
> 
> The package btrfs-tools needs a lot of care:
> - the INSTALL file still reports that is not possible to remove a subvolume
> - a lot of program are not documented (what is the meaning of btrfs-zero-log 
> ?)
> - "btrfs dev scan" and "btrfs -a" try to read CDROM and Floppy looking for a 
> btrfs filesystem: only waste of time
> - [...]
> 
> I think that is better to improve the btrfs-progs and not to update btrfsctl.

I'd agree, the btrfsctl command is more than a little awkward, and the
btrfs command is pretty much better in every way.

-chris

