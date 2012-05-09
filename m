From: David Sterba <dave@jikos.cz>
Subject: Re: Subdirectory creation on snapshot
Date: Wed, 9 May 2012 18:58:02 +0200
Message-ID: <20120509165802.GN19331@twin.jikos.cz>
References: <821DC50D-8451-4AD1-8CCA-DE1238D4788B@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Brendan Smithyman <smithyman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <821DC50D-8451-4AD1-8CCA-DE1238D4788B@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2012 at 05:10:08PM -0700, Brendan Smithyman wrote:
> I'm experiencing some odd-seeming behaviour with btrfs on Ubuntu
> 12.04, using the Ubuntu x86-64 generic 3.2.0-24 kernel and btrfs-tools
> 0.19+20120328-1~precise1 (backported from the current Debian version
> using Ubuntu's backportpackage).  When I snapshot a subvolume on some
> of my drives, it creates an empty directory inside the snapshot with
> the same name as the original subvolume.  Example case and details
> below:

This is known and it's not a problem, though I was surprised when I had
first seen it myself. Snapshotting is not recursive, the case of
file->file, directory->directory is straightforward, and when a
subvolume is encountered, a new file sub-type is created, it's
identified by BTRFS_EMPTY_SUBVOL_DIR_OBJECTID internally, so it's a kind
of a "stub" subvolume.  It is identified by inode number 2 in stat
output. The object cannot be modified and just sits there.


david
