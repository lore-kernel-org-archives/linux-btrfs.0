From: Alessio Focardi <alessiof@gmail.com>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 7 May 2012 13:15:26 +0200 (CEST)
Message-ID: <1429905255.3406.1336389326378.JavaMail.root@zimbra.interconnessioni.it>
References: <20120507105552.GC8938@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507105552.GC8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

> This is a lot more compact (as you can have several files' data in a
> single block), but by default will write two copies of each file,
> even
> on a single disk.

Great, no (or less) space wasted, then! I will have a filesystem that's composed mostly of metadata blocks, if I understand correctly. Will this create any problem? 

>    So, if you want to use some form of redundancy (e.g. RAID-1), then
> that's great, and you need to do nothing unusual. However, if you
> want
> to maximise space usage at the expense of robustness in a device
> failure, then you need to ensure that you only keep one copy of your
> data. This will mean that you should format the filesystem with the
> -m
> single option.


That's a very clever suggestion, I'm preparing a test server right now: going to use the -m single option. Any other suggestion regarding format options?

pagesize? leafsize?

 
> > XFS has a minimum block size of 512, but BTRFS is more modern and,
> > given the fact that is able to handle indexes on his own, it could
> > help us speed up file operations (could it?)
> 
>    Not sure what you mean by "handle indexes on its own". XFS will
> have its own set of indexes and file metadata -- it wouldn't be much
> of a filesystem if it didn't.

Yes, you are perfectly right; I tough that recreating a tree like /d/u/m/m/y/ to store "dummy" would have been redundant since the whole filesystem is based on trees - I don't have to "ls" directories, we are using php to write and read files, I will have to find a "compromise" between levels of directories and number of files in each one of them.

May I ask you about compression? Would you use it in the scenario I described?

Thank you for your help!
