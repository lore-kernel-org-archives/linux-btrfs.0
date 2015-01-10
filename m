Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34323 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbbAJKax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 05:30:53 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: dsterba@suse.cz, Lennart Poettering <lennart@poettering.net>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Date: Sat, 10 Jan 2015 11:30:51 +0100
Message-ID: <2517325.C82IPi5PVl@merkaba>
In-Reply-To: <20150109155259.GB3685@twin.jikos.cz>
References: <20150107174315.GA21865@gardel-login> <20150108133036.GA23096@gardel-login> <20150109155259.GB3685@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 9. Januar 2015, 16:52:59 schrieb David Sterba:
> On Thu, Jan 08, 2015 at 02:30:36PM +0100, Lennart Poettering wrote:
> > On Wed, 07.01.15 15:10, Josef Bacik (jbacik@fb.com) wrote:
> > > On 01/07/2015 12:43 PM, Lennart Poettering wrote:
> > > >Currently, systemd-journald's disk access patterns (appending to the
> > > >end of files, then updating a few pointers in the front) result in
> > > >awfully fragmented journal files on btrfs, which has a pretty
> > > >negative effect on performance when accessing them.
> > >
> > > 
> > >
> > > I've been wondering if mount -o autodefrag would deal with this problem
> > > but
> > > I haven't had the chance to look into it.
> >
> > 
> >
> > Hmm, I am kinda interested in a solution that I can just implement in
> > systemd/journald now and that will then just make things work for
> > people suffering by the problem. I mean, I can hardly make systemd
> > patch the mount options of btrfs just because I place a journal file
> > on some fs...
> >
> > 
> >
> > Is "autodefrag" supposed to become a default one day?
> 
> Maybe. The option brings a performance hit because reading a block
> that's out of sequential order with it's neighbors will also require to
> read the neighbors. Then the group (like 8 blocks) will be written
> sequentially to a new location.
> 
> It's an increased read latency in the fragmented case and more stress to
> the block allocator. Practically it's not that bad for general use, eg.
> a root partition, but now it's still users' decision whether to use it
> or not.

I am concerned about flash based storage as probably not needing it and for the 
additional writes it causes.

And about free space fragmentation due to regular defragmenting. I read on XFS 
mailing list more than one, not to run xfs_fsr, the XFS online defrag tool 
regularily from a cron job, as it can make free space fragmentation worse.

And given the issues BTRFS still has with free space handling (see the thread 
I started about it and the kernel bug report 90401), I am vary of anything 
that could add more of free space fragmentation by default, especially when 
its not needed, like on an SSD.

I have

merkaba:/home/martin/.local/share/akonadi/db_data/akonadi> filefrag 
parttable.ibd
parttable.ibd: 8039 extents found

And I had this up to 40000 extents already, I did try manual defragmenting it 
with various options to look whether I see any effect:

None.

Same with desktop search database of KDE.

On my dual SSD BTRFS RAID 1 setup the amount of extents simply does not seem 
to matter at all, except for journalctl where I saw some noticable delays on 
initially calling it. But right now also there its on one hand just about one 
second – which I consider to be on the other hand much giving its a SSD RAID 
1.

But heck, the fragmentation of some of those files in there is abysmal 
considering the small size of the files:

merkaba:/var/log/journal/1354039e4d4bb8de4f97ac8400000004> filefrag *                         
system@00050bbcaeb23ff2-c7230ef5d29df634.journal~: 2030 extents found
system@00050be4b7106b25-a4ab21cd18c0424c.journal~: 1859 extents found
system@00050bf84d2efb2c-1e4e85dacaf1252c.journal~: 1803 extents found
system@2f7df24c6b70488fa9724b00ab6e6043-0000000000000001-00050bf84d2ae7be.journal: 
1076 extents found
system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b22f7-00050bfb82b379f8.journal: 
84 extents found
system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b22fb-00050bfb8657c8b0.journal: 
1036 extents found
system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b2693-00050c0d8075ea4b.journal: 
1478 extents found
system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b4136-00050c3782b1c527.journal: 
2 extents found
system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b4137-00050c378666837a.journal: 
142 extents found
system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b414c-00050c37c7883228.journal: 
574 extents found
system@5ee315765b1a4c6d9ed2fe833dec7094-0000000000010fdd-00050b56fa20f846.journal: 
2309 extents found
system.journal: 783 extents found
user-1000@cc345f87cb404df6a9588b0b1c707007-0000000000011061-00050b56fa223006.journal: 
340 extents found
user-1000@cc345f87cb404df6a9588b0b1c707007-00000000001ad624-00050ba77c734a3b.journal: 
564 extents found
user-1000@cc345f87cb404df6a9588b0b1c707007-00000000001b297c-00050c0d8077447c.journal: 
105 extents found
user-1000.journal: 133 extents found
user-120.journal: 5 extents found
user-2012.journal: 2 extents found
user-65534.journal: 222 extents found

merkaba:/var/log/journal/1354039e4d4bb8de4f97ac8400000004> du -sh * | cut -
c1-72
16M     system@00050bbcaeb23ff2-c7230ef5d29df634.journal~
16M     system@00050be4b7106b25-a4ab21cd18c0424c.journal~
16M     system@00050bf84d2efb2c-1e4e85dacaf1252c.journal~
8,0M    system@2f7df24c6b70488fa9724b00ab6e6043-0000000000000001-00050bf84d
8,0M    system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b22f7-00050bfb82
8,0M    system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b22fb-00050bfb86
8,0M    system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b2693-00050c0d80
8,0M    system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b4136-00050c3782
8,0M    system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b4137-00050c3786
8,0M    system@2f7df24c6b70488fa9724b00ab6e6043-00000000001b414c-00050c37c7
16M     system@5ee315765b1a4c6d9ed2fe833dec7094-0000000000010fdd-00050b56fa2
8,0M    system.journal
8,0M    user-1000@cc345f87cb404df6a9588b0b1c707007-0000000000011061-00050b5
8,0M    user-1000@cc345f87cb404df6a9588b0b1c707007-00000000001ad624-00050ba
8,0M    user-1000@cc345f87cb404df6a9588b0b1c707007-00000000001b297c-00050c0
8,0M    user-1000.journal
3,6M    user-120.journal
8,0M    user-2012.journal
8,0M    user-65534.journal

Especially when I compare that to rsyslog:

merkaba:/var/log> filefrag messages syslog kern.log
messages: 24 extents found
syslog: 3 extents found
kern.log: 31 extents found
merkaba:/var/log> filefrag messages.1 syslog.1 kern.log.1
messages.1: 67 extents found
syslog.1: 20 extents found
kern.log.1: 78 extents found


When I see this, I wonder whether it would make sense to use two files:

1. One for the sequential appending case

2. Another one for the pointers, which could even be rewritten from scratch 
each time.


On the other hand one can claim:

Non copy on write filesystems cope well with that kind of random I/O workload 
inside a file, so BTRFS will have to cope well with that as well.

On the other hand the way systemd writes logfiles obviously didn´t take the 
copy on write nature of the BTRFS filesystem into account.

But MySQL, PostgreSQL or others also do not do this.

So to never break userspace, BTRFS would have to adapt. On the other hand I 
think it may be easier to adapt the applications, and I wonder how a database 
could perform that is specifically designed for copy on write semantics.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
