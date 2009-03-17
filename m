From: CSights <csights@fastmail.fm>
Subject: Re: metadata copied/data not copied?
Date: Tue, 17 Mar 2009 11:34:41 -0400
Message-ID: <200903171134.41896.csights@fastmail.fm>
References: <200903161035.19446.csights@fastmail.fm> <49BE7003.2050404@hp.com> <1237249545.3814.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1237249545.3814.4.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> This is true, cp makes a full copy of the file.
>
> The btrfs utilities include a program called bcp that makes a COW copy
> of a single file (or directory tree) with a btrfs specific ioctl.

Okay, what happens if in the original example "cp" is changed to "bcp"?

# bcp file1 file2
# chown newuser:newgroup file2
(Where file1 was owned by olduser:oldgroup.)

	Is using "bcp" the same as copying with hardlinks ("cp -l file1 file2")?


	Here is an expanded example which is how I imagined COW would handle changes 
to the file's data ("file contents").  One can pretend it is an attempt to 
inject malicious code into /bin/sh (e.g. file1 is /bin/sh).

[METADATA]                     -->  DATA
[file1 perms olduser:oldgroup] -->  file contents


# cp file1 file2
[file1 perms olduser:oldgroup "COW"]  \
                                       -->  file contents
[file1 perms olduser:oldgroup "COW"]  /   
(A "COW" flag is set in btrfs's (hidden) metadata.)


# chown newuser:newgroup file2
[file1 perms olduser:oldgroup "COW"]  \
                                       -->  file contents
[file1 perms newuser:newgroup "COW"]  /
(chown, chmod, others? are not "writes" to file contents, so file contents 
don't need to be copied-on-write yet.)


# cat newcontent >> file2
[file1 perms olduser:oldgroup] -->  file contents
[file2 perms newuser:newgroup] -->  file contents + newcontent
(File contents are modified.  This is a "write" that triggers COW.  The file 
contents are copied and then modified. Metadata for file2 are hooked up to 
copied then modified file contents.  "COW" flag is cleared.)

	Would this work?  At least in this example it looks like the filesystem can 
track whether the file contents should be copied or not without hints from 
userspace.

Thanks,
	newb.
