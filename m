From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: Various Questions
Date: Sat, 8 Jan 2011 10:40:57 -0500
Message-ID: <20110108154057.GG7447@idallen.ca>
References: <201101070915.20468.CACook@quantum-sci.com>
 <AANLkTinCSW-JpwYPYNNAaxHnvXqAy02fMr=Hd34CGxh3@mail.gmail.com>
 <201101071055.44187.CACook@quantum-sci.com>
 <201101080525.19792.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101080525.19792.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 08, 2011 at 05:25:19AM -0800, Carl Cook wrote:
> In addition to the questions below, if anyone has a chance could you
> advise on why my destination drive has more data than the source after
> this command:
> # rsync --hard-links --delete --inplace --archive --numeric-ids /media/disk/* /home
> sending incremental file list
> sent 658660 bytes  received 2433 bytes  1322186.00 bytes/sec
> total size is 1355368091626  speedup is 2050192.77
> 
> # df /media/disk
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md2             1868468340 1315408384 553059956  71% /media/disk
> # df /home
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb             3907029168 1325491836 2581537332  34% /home

This has little to do with btrfs; it happens with many file systems due
to file system infrastructure details such as directory sizes, sparse
file handling, file fragmentation, etc.

For example: If you have a directory with a huge number of file names
in it, the actual directory disk space used will be large and will not
be reclaimed when you delete all the file names from the directory.
You would have to remove the directory itself and recreate it to reclaim
that space.  Also, using rsync without --sparse (which can't work with
--inplace), sparse files on the source may get expanded to take real
disk blocks on the destination.

Unless you use "dd" to copy a partition exactly, including all the file
system infrastructure details, any copy you make will be subject to the
vagaries of how the file system decides to lay out the data.

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
