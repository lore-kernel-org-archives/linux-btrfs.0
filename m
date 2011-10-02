From: David Sterba <dave@jikos.cz>
Subject: Re: recursive subvolume delete
Date: Sun, 2 Oct 2011 19:17:23 +0200
Message-ID: <20111002171723.GK22205@twin.jikos.cz>
References: <CAJ1PRS=7HGupXFP1ma-rTyFnxvtCge2Ajipg1wLmGhZTAuDKrg@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=7HGupXFP1ma-rTyFnxvtCge2Ajipg1wLmGhZTAuDKrg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 02, 2011 at 04:38:21PM +0200, krzf83@gmail.com  wrote:
> Also I think there are no real tools to find out which directories are
> subvolumes/snapshots

Well, there are, but these are the _real_ tools, you know.

subv1 is a subvolume
snap1 is it's snapshot

$ stat subv1 snap1
  File: `subv1'
  Size: 0               Blocks: 0          IO Block: 4096   directory
Device: 1ch/28d Inode: 256         Links: 1
Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-10-02 19:12:04.493885220 +0200
Modify: 2011-10-02 19:12:04.493885220 +0200
Change: 2011-10-02 19:12:04.493885220 +0200
 Birth: -
  File: `snap1'
  Size: 0               Blocks: 0          IO Block: 4096   directory
Device: b1h/177d        Inode: 256         Links: 1
Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-10-02 19:12:04.493885220 +0200
Modify: 2011-10-02 19:12:04.493885220 +0200
Change: 2011-10-02 19:12:04.493885220 +0200
 Birth: -


Common signature is "Inode: 256" and this is acutally the same test which is
performed by 'btrfs subvol ...' to check whether the source dir is a
subvolume, and by the kernel module as well.


david
