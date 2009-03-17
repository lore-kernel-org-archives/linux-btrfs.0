From: CSights <csights@fastmail.fm>
Subject: Re: metadata copied/data not copied?
Date: Tue, 17 Mar 2009 13:08:05 -0400
Message-ID: <200903171308.05848.csights@fastmail.fm>
References: <200903161035.19446.csights@fastmail.fm> <200903171134.41896.csights@fastmail.fm> <1237305370.31273.29.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1237305370.31273.29.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

> > 	Here is an expanded example which is how I imagined COW would handle
> > changes to the file's data ("file contents").  One can pretend it is an
> > attempt to inject malicious code into /bin/sh (e.g. file1 is /bin/sh).
> >
> > [METADATA]                     -->  DATA
> > [file1 perms olduser:oldgroup] -->  file contents
> >
> >
> > # cp file1 file2
> > [file1 perms olduser:oldgroup "COW"]  \
> >                                        -->  file contents
> > [file1 perms olduser:oldgroup "COW"]  /
> > (A "COW" flag is set in btrfs's (hidden) metadata.)
> >
> >
> > # chown newuser:newgroup file2
> > [file1 perms olduser:oldgroup "COW"]  \
> >                                        -->  file contents
> > [file1 perms newuser:newgroup "COW"]  /
> > (chown, chmod, others? are not "writes" to file contents, so file
> > contents don't need to be copied-on-write yet.)
> >
> >
> > # cat newcontent >> file2
> > [file1 perms olduser:oldgroup] -->  file contents
> > [file2 perms newuser:newgroup] -->  file contents + newcontent
> > (File contents are modified.  This is a "write" that triggers COW.  The
> > file contents are copied and then modified. Metadata for file2 are hooked
> > up to copied then modified file contents.  "COW" flag is cleared.)
>
> It would work, but it is slightly different from how btrfs works.  There
> are two ways to read COW (copy on write):
>
> 1) Before changing something, make a copy of the old data and put it
> somewhere else.  Then overwrite the original location.
>
> 2) Don't ever overwrite the original location, write somewhere new
> instead.  The old copy stays in the original location.
>
> Btrfs does #2.

	Does the choice #1 or #2 change whether the extended example works or not?  
It seems as though either way makes sense for the example given...?

> The bcp command creates a second inode that points to the same data
> extents as the first inode.  So, modifications to the inodes themselves
> (such as chown, chmod, touch etc) don't touch the data extents.
>
> Modifications to the data extents go through the COW mechanism to make
> sure we don't overwrite the originals.

	To me it sounds like if cp were replaced with bcp, then btrfs would behave as 
I imagined in my example...
	Why is a "bcp" separate from cp needed?  Is it because with cp btrfs 
doesn't "know" a simple copy is being made, but just gets a stream of data to 
write to disk?
	Is it possible to update cp to do the btrfs ioctl automatically, or must the 
commands always remain separate because there are situations where it would 
be a problem for the file contents to be COW?  (It seems to me the fact that 
the data contents are COW would be transparent to userland apps, so the bcp 
ioctl could be built in to cp.)

Looking forward to (a stable) btrfs!
	Eager User. :)
