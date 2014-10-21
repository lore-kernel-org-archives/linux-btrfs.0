Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50278 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbaJUKNf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 06:13:35 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 4B133201C2
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 21:13:32 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem
Date: Tue, 21 Oct 2014 21:13:29 +1100
References: <201410181454.19375.russell@coker.com.au> <pan$9907e$9b197fe7$2a806862$700ddfa7@cox.net> <20141020130243.GB29401@hungrycats.org>
In-Reply-To: <20141020130243.GB29401@hungrycats.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201410212113.30887.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Oct 2014, Zygo Blaxell <zblaxell@furryterror.org> wrote:
> On Mon, Oct 20, 2014 at 04:38:28AM +0000, Duncan wrote:
> > Russell Coker posted on Sat, 18 Oct 2014 14:54:19 +1100 as excerpted:
> > > # find . -name "*546"
> > > ./1412233213.M638209P10546 # ls -l ./1412233213.M638209P10546 ls:
> > > cannot access ./1412233213.M638209P10546: No such file or directory
> > 
> > Does your mail server do a lot of renames?  Is one perhaps stuck?  If so,
> > that sounds like the same thing "Zygo Blaxell" is reporting in the
> > "3.16.3..3.17.1 hang in renameat2()" thread, OP on Sun, 19 Oct 2014
> > 15:25:26 -400, Msg-ID: <20141019192525.GA29401@hungrycats.org>, as linked
> > here:

It's a Maildir server so it does a lot of renames, but I don't think anything 
is stuck.  I've just rebooted the Dom0 and nothing has changed.

> For Russell's issue...most of the stuff I can think of has been
> tried already.  I didn't see if there was any attempt try to ls the
> file from the NFS server as well as the client side.  If ls is OK on
> the server but not the client, it's an NFS issue (possibly interacting
> with some btrfs-specific quirk); otherwise, it's likely a corrupted
> filesystem (mail servers seem to be unusually good at making these).

# ls -l *546
ls: cannot access *546: No such file or directory

Above is on the server.

# ls -l *546
ls: cannot access 1412233213.M638209P10546: No such file or directory

Above is on the client.  Note that wildcard expansion worked because readdir() 
found the file even though stat can't.

> Most of the I/O time on mail servers tends to land in the fsync() system
> call, and some nasty fsync() btrfs bugs were fixed in 3.17 (i.e. after
> 3.16, and not in the 3.16.x stable update for x <= 5 (the last one
> I've checked)).  That said, I'm not familiar with how fsync() translates
> over NFS, so it might not be relevant after all.

That's going to suck for people running mail servers on Debian.

> If the NFS server's view of the filesystem is OK, check the NFS protocol
> version from /proc/mounts on the client.  Sometimes NFS clients will
> get some transient network error during connection and fall back to some
> earlier (and potentially buggier) NFS version.  I've seen very different
> behavior in some important corner cases from v4 and v3 clients, for
> example, and if the client is falling all the way back to v2 the bugs
> and their workarounds start to get just plain _weird_ (e.g. filenames
> which produce specific values from some hash function or that contain
> specific character sequences are unusable).  v2 is so old it may even
> have issues with 64-bit inode numbers.

Rebooting the client multiple times and rebooting the server once doesn't 
change it.  I don't think it's any transient error.

On Tue, 21 Oct 2014, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> Just now saw this thread, but IIRC 'No such file or directory' also gets 
> returned sometimes when trying to automount a share that can't be 
> enumerated by the client, and also sometimes when there is a stale NFS 
> file handle.

I think that rebooting both client and server precludes the possibility of a 
stale file handle.  Even rebooting the client (which I have done several 
times) should fix it.

On Tue, 21 Oct 2014, Robert White <rwhite@pobox.com> wrote:
> Okay, from the strace output the shell _is_ finding the file in the
> directory read and expand (readdir) pass. That is "*546" is being
> expanded to the full file name text "1412233213.M638209P10546" but then
> the actual operation fails because the name is apparently not associated
> with anything.
> 
> So what pass of scrub or btrfsck checks directory connectedness? Does
> that pass give your file system a clean bill of health?

That's inconvenient for a remote system with a single BTRFS filesystem.

> Also you said that you are using a 32bit user space "copied from another
> server" under a 64bit kernel. Is the "ls" command a 32 bit executable then?

Yes.

> What happens if you stop the Xen domain for the mail server and then
> mount the disks into a native 64bit environment and then ls the file name?

The filesystem in question is NFS mounted from a server with 64bit kernel+user 
to a virtual server with 64bit kernel+32bit user.  On the file server (the Xen 
Dom0) ls doesn't even see that file in readdir.

> I ask because the man page for lstat64 says its a "wrapper" for the
> underlying system call (fstatat64). It is not impossible that you might
> have a case where the wrapper is failing inside glibc due to some 32/64
> bit conversion taking place.

If there is a 32/64 conversion then we have another problem.  The mail server 
is configured to reject messages bigger than about 50M, I don't recall the 
exact number but it's a lot smaller than 2G.

On Tue, 21 Oct 2014, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> Could this be related to the inode overflow in 32 bit system 
> (see inode_cache options) ? If so running a 64bit "ls -i" should
> work....

I've just installed coreutils:amd64 on the NFS client and I get the same 
results.

On Tue, 21 Oct 2014, Duncan <1i5t5.duncan@cox.net> wrote:
> The inode_cache mount option isn't recommended for any bitness.
> 
> @ Russ, are you mounting with inode_cache?  If so, definitely try running 
> without it and see if it changes the results.

/dev/sda3 / btrfs rw,seclabel,noatime,space_cache,skip_balance 0 0

The above is in /proc/mounts.  I have configured my systems to use 
skip_balance because in the past I've had a balance cause big problems on 
several occasions and I've never had a resumed balance do any good.  I think 
that noatime is unlikely to cause any problems.  I don't know what space_cache 
is about, is that something the kernel adds automatically?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
