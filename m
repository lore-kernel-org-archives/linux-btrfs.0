From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Wed, 20 Jul 2011 04:44:26 -0400
Message-ID: <1311150979-sup-1740@shiny>
References: <201106061220.05696.markotahal@gmail.com> <201106102043.19025.markotahal@gmail.com> <4DF28414.8090601@redhat.com> <1340741.hHfqtiVQGn@beruska> <4E0213C8.20006@redhat.com> <1311141916.4652.4.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Marek Otahal <markotahal@gmail.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Andy Lutomirski <luto@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1311141916.4652.4.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Woodhouse's message of 2011-07-20 02:05:02 -0400:
> On Wed, 2011-06-22 at 12:09 -0400, Josef Bacik wrote:
> > >>>>>>>
> > >>>>>>> Hello,
> > >>>>>>> the issue happens every time when i have to hard power-off my notebook
> > >>>>>>> (suspend problems).
> > >>>>>>> With kernel 2.6.39 the partition is unmountable, solution is to boot
> > >>>>>>> 2.6.38 kernel which
> > >>>>>>> 1/ is able to mount the partition,
> > >>>>>>> 2/ by doing that fixes the problem so later .39 (after clean shutdown) can
> > >>>>>>> mount it also.
> > >>>>>>
> > >>>>>> Same problem here.  Mounting with 2.6.38 says:
> > >>>>>>
> > >>>>>> [   41.906259] Btrfs loaded
> > >>>>>> [   41.906747] device fsid e040a9d60da49596-66c0275e348878bf devid 1 transid
> > >>>>>> 69217 /dev/mapper/vg_midnight_ssd-home
> > >>>>>> [   41.908767] btrfs: disk space caching is enabled
> > >>>>>> [   42.232185] btrfs: unlinked 17 orphans
> > >>>>>> [   42.232189] btrfs: truncated 2 orphans
> > >>>>>>
> > >>>>>> dmesg in 2.6.39.1 says:
> > >>>>> []
> > >>>>>> [   15.004255] kernel BUG at fs/btrfs/inode.c:4676!
> > >>>>> []
> > >>>>>
> > >>>>> I've been experiencing the same issue also.
> > >>>>>
> > >>>>> Josef/Chris, would an metadata snapshot or full block snapshot help
> > >>>>> debug this regression? I can probably setup a small testcase to
> > >>>>> trigger this.
> > >>>>>
> > >>>>
> > >>>> If you can come up with a testcase to reproduce I would love you forever
> > >>>> ;).  If I get done what I wanted to do today I will try and reproduce.
> > >>>> Thanks,
> > >>>>
> > >>>> Josef
> > >>>>
> > >>> ...I was getting ready for you eternal love, Josef :P...but I can't reproduce it 100%, like 70% 
> > > success-rate. 
> > >>>
> > >>> The test-case is quite easy, 
> > >>> 1. mount the FS, just with compress-force=lzo option // I didn't try without, but on my other 
> > > btrfs partition that doesn't use compression the err never happened ...so, can the others who 
> > > experience the bug confirm compress=lzo used?   
> > >>> 2. cd to it & create a file (not sure if needed)
> > >>> 3. hard power-off
> > >>>
> > >>> To reproduce my tests: 
> > >>> dd /dev/zero /btrfstest bs=1M count=256 (min required for default mksf.btrfs)
> > >>> losetup /dev/loop0 /btrfstest
> > >>> mkfs.btrfs /dev/loop0
> > >>> mount -o compress-force=lzo /dev/loop0 /mnt/tmp
> > >>> vim /mnt/tmp/hello.txt
> > >>> ---power off!

Oh, the dirty little secret of loop devices is they don't actually write
things to disk properly.   They are not power off safe.  But you can
trigger this without a loop device, correct?

> 
> While repeatedly crashing 3.0-rc7 with attempts to make Broadcom
> wireless work, I've seen something very similar to this. Like Marek, I
> have to boot 2.6.38 to recover, and then I can boot 3.0 again. I've been
> seeing it for a while, but upon looking in to the mailing list I saw it
> was already being discussed and even had a test case more useful than
> "sometimes when I crash my kernel...", so I figured it was already in
> hand.
> 
> I'll try to crash it tonight so I can hand it to Chris in the morning.
> Obviously, my attempts to reproduce it on demand so far have failed :)
> 

The oops were hitting is a -EEXIST on trying to insert the directory
entry for the inode back ref, but the tree-logging stuff is already
trying to check for dups.

I'll take a look.

-chris
