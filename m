From: Boyd Waters <waters.boyd@gmail.com>
Subject: Re: Content based storage
Date: Sun, 21 Mar 2010 02:55:28 -0400
Message-ID: <-4111028596887385687@unknownmsgid>
References: <hnnijd$jol$1@dough.gmane.org> <201003171625.50257.hka@qbs.com.pl>	
		 <23a15591003170833t3ec4dc3fq9630558aa190afc@mail.gmail.com>	 	
	<201003172043.17314.hka@qbs.com.pl> <2b0225fb1003191946k1cf92c63q18e40d41274ce3e8@mail.gmail.com> 	
	<4BA4C811.4060702@redhat.com> <-1949627963487010042@unknownmsgid>
	<4BA5492C.5030709@redhat.com> <4BA54FC8.60806@redhat.com>
Mime-Version: 1.0 (iPhone Mail 7C144)
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BA54FC8.60806@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

I realize that I've posted some dumb things in this thread so here's a
re-cast summary:

1) In the past, I experimented with fikesystem backups, using my own
file-level checksumming that would detect when a file was already in
the backup repository, and add a hard link rather than allocate new
blocks. You can do that today on any [posix] fikesystem that supports
hard links, by using rsync.

But you are far, far better off using snapshots.

2) I said that I got 7-to-1 "deduplication" using my hard-link system.
That's a meaningless statement, but anyway I was able to save twelve
or so backups of a 100GB dataset on a 160GB hard disk.

You would almost certainly see much better results by using snapshots
on ZFS or btrfs, where a snapshot takes almost no storage to create,
and only uses extra space for any changed blocks. Snapshots are block-
level.

3) Another meaningless statement was my subjective notion that ZFS
dedup led to performance degradation. Forget I said that, as actually
I have no idea. My system was operating with failing drives at the time.

Some people report better performace with ZFS dedup, as it decreases
the number of disk writes.
