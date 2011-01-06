From: Peter A <loony@loonybin.org>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 22:58:36 -0500
Message-ID: <201101052258.36457.loony@loonybin.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24D8BC.90808@bobich.net> <4D251888.7060508@shiftmail.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D251888.7060508@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, January 05, 2011 08:19:04 pm Spelic wrote:
> > I'd just make it always use the fs block size. No point in making it 
> > variable.
> 
> Agreed. What is the reason for variable block size?

First post on this list - I mostly was just reading so far to learn more on fs 
design but this is one topic I (unfortunately) have experience with... 

You wouldn't believe the difference variable block size dedupe makes. For a 
pure fileserver, its ok to dedupe on block level but for most other uses, 
variable is king. One big example is backups. Netbackup and most others 
produce one stream with all data even when backing up to disk. Imagine you 
move a whole lot of data from one dir to another. Think a directory with huge 
video files. As a filesystem it would be de-duped nicely. The backup stream 
however may and may not have matching fs blocks. If the directory name before 
and after has the same lengths and such - then yeah, dedupe works. Directory 
name is a byte shorter? Everything in the stream will be offset by one byte - 
and no dedupe will occur at all on the whole dataset. In real world just 
compare the dedupe performance of an Oracle 7000 (zfs and therefore fs block 
based) to a DataDomain (variable lenght) in this usage scenario. Among our 
customers we see something like 3 to 17x dedupe ration on the DD, 1.02 - 1.05 
in the 7000.

There are many other examples and in the end it comes down to if you want 
general purpose de-dupe (e.g. something useful when you serve iscsi luns, 
serve as backup target, ...) or if you only care about a pure file store, 
you're probably going to be ok with fixed block lengths... 

Hope that helps, 

Peter.

-- 
Censorship: noun, circa 1591. a: Relief of the burden of independent thinking.
