Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34913 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2I3V5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 17:57:49 -0400
Date: Sun, 30 Sep 2012 23:57:44 +0200
From: David Sterba <dave@jikos.cz>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfsck: "root 256 inode 581419 errors 100". Can I heal this
 file system?
Message-ID: <20120930215744.GJ14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5067759C.4090302@statystyka.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5067759C.4090302@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 30, 2012 at 12:26:36AM +0200, Adam Ryczkowski wrote:
> I was using this btrfs file system on kernel 3.6 rc4 and rc5 and 3.5.4 on
> Mint 13 (which is based on Ubuntu 12.04). Now, I found the following output
> of btrfsck /dev/sda8 (which was of course off-line at that time):
> >checking extents
> >checking fs roots
> >root 256 inode 581419 errors 100

If I'm reading fsck.c right, it means that there are missing extents at
the end of the file, ie some unaccounted range.

Please run 'filefrag -vb mountpoint/@/var/cache/hald/fdi-cache', save
the last line, and add the 2nd and last numbers

  22 1046528 52330076 63340363   2048 eof
     ^^^^^^^                     ^^^^

multiply by 1024 and this will give end of the accounted extents. Next,
run 'stat' on the file to find it's size. Tell me those numbers and I'll
tell you if your filesystem is broken :)

I think the error comes from a truncate that made extents and file size
disagree and this can be further observed by reading the file beyond the
last extent. In ideal case it returns zeros in that range, or refuse to
read anything due to missing checksum.

Do you recall any unclean shutdown? As it's a cache of a system(!d)
service, the file will be probably open for a long time and will last
out to all unexpected shutdowns.

> I understand, that the line "root 256 inode 581419 errors 100" tries to tell
> me, that there is a problem with inode 581419. (Which happen to be
> mountpoint/@/var/cache/hald/fdi-cache; I use btrfs as a root file system for
> Linux mint 13). I pulled the recent btrfs-tools from Ubuntu 12.10
> (https://launchpad.net/ubuntu/quantal/+package/btrfs-tools; version
> 0.19+20120328-7ubuntu1 <https://launchpad.net/ubuntu/quantal/+source/btrfs-tools/0.19+20120328-7ubuntu1>).
> The btrfsck doesn't make the error disapear. I don't experience any problems
> with the file system, but maybe I am only lucky.

Not sure here, it's fsck after all, but the particular error could be
fixed by resetting the inode size to the last extent end or adding a
preallocated range for the gap.

> Is there any way to heal the file system?
> 
> I can read the file just fine. But I can't confirm if the contents are valid
> though; they definitely don't look random. Would deleting the file help? Or
> re-writing it?

If it's a cache, the application will be able to recreate it if you
delete it. Howver I'm not sure if this would not provoke a runtime bug.

Maybe other developers would like to investigate, so please do not
delete it yet. Otherwise, 'rm', or 'truncate -s0 file; rm file' should work.


david
