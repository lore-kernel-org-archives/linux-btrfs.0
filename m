From: David Brown <david@westcontrol.com>
Subject: Re: Content based storage
Date: Wed, 17 Mar 2010 09:21:50 +0100
Message-ID: <hnq3fa$700$1@dough.gmane.org>
References: <hnnijd$jol$1@dough.gmane.org> <4BA00A06.9020208@ilbello.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BA00A06.9020208@ilbello.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 16/03/2010 23:45, Fabio wrote:
> Some years ago I was searching for that kind of functionality and found
> an experimental ext3 patch to allow the so-called COW-links:
> http://lwn.net/Articles/76616/
>

I'd read about the COW patches for ext3 before.  While there is 
certainly some similarity here, there are a fair number of differences. 
  One is that those patches were aimed only at copying - there was no 
way to merge files later.  Another is that it was (as far as I can see) 
just an experimental hack to try out the concept.  Since it didn't take 
off, I think it is worth learning from, but not building on.

> There was a discussion later on LWN http://lwn.net/Articles/77972/
> an approach like COW-links would break POSIX standards.
>

I think a lot of the problems here were concerning inode numbers.  As 
far as I understand it, when you made an ext3-cow copy, the copy and the 
original had different inode numbers.  That meant the userspace programs 
saw them as different files, and you could have different owners, 
attributes, etc., while keeping the data linked.  But that broke a 
common optimisation when doing large diff's - thus some people wanted to 
have the same inode for each file and that /definitely/ broke posix.

With btrfs, the file copies would each have their own inode - it would, 
I think, be posix compliant as it is transparent to user programs.  The 
diff optimisation discussed in the articles you sited would not work - 
but if btrfs becomes the standard Linux file system, then user 
applications like diff can be extended with btrfs-specific optimisations 
if necessary.

> I am not very technical and don't know if it's feasible in btrfs.

Nor am I very knowledgeable in this area (most of my programming is on 
8-bit processors), but I believe btrfs is already designed to support 
larger checksums (32-bit CRCs are not enough to say that data is 
identical), and the "cp --reflink" shows how the underlying link is made.

> I think most likely you'll have to run an userspace tool to find and
> merge identical files based on checksums (which already sounds good to me).

This sounds right to me.  In fact, it would be possible to do today, 
entirely from within user space - but files would need to be compared 
long-hand before merging.  With larger checksums, the userspace daemon 
would be much more efficient.

> The only thing we can ask the developers at the moment is if something
> like that would be possible without changes to the on-disk format.
>

I guess that's partly why I made these posts!

>
> PS. Another great scenario is shared hosting web/file servers: ten of
> thousand website with mostly the same tiny PHP Joomla files.
> If you can get the benefits of: compression + "content based"/cowlinks +
> FS Cache... That would really make Btrfs FLY on Hard Disk and make SSD
> devices possible for storage (because of the space efficiency).
>

That's a good point.

People often think that hard disk space is cheap these days - but being 
space efficient means you can use an SSD instead of a hard disk.  And 
for on-disk backups, it means you can use a small number of disks even 
though the users think "I've got a huge hard disk, I can make lots of 
copies of these files" !

