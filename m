Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58887 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2IRXIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 19:08:45 -0400
Received: by ieak13 with SMTP id k13so618403iea.19
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 16:08:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com>
Date: Tue, 18 Sep 2012 16:08:42 -0700
Message-ID: <CAPYLRzhnWfQf=tcO882GfG-zpJDbQSqzoLiqpr+G2KSfFBLVRA@mail.gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
From: Gregory Farnum <greg@inktank.com>
To: Casper Bang <casper.bang@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 1:45 AM, Casper Bang <casper.bang@gmail.com> wrote:
> Abstract
> For database testing purposes, a COW filesystem was needed in order to
> facilitate snapshotting and rollback, such as to provide mirrors of
> our production database at fixed intervals (every night and by
> demand).
>
> Platform
> An HP Proliant 380P (2x Intel Xeon E5-2620 with 12 cores for a total
> of 24 threads) with build-in Smart Array SAS/SATA (Gen8) controllers,
> was combined with 10x consumer Samsung 830 512GB SSD (SATAIII, 6Gb/s).
> Oracle (Unbreakable) Linux x64 2.6.39-200.29.3.el6uek.x86_64 #1 SMP
> Tue Aug 28 13:03:31 EDT 2012 and Oracle database standard edition
> 10.2.0.4 64bit.
>
> Setup
> OS was installed on fist disk (sda) and the remaining 9 (sdb - sdj)
> were pooled into some 4.4TB, for containing Oracle datafiles. An
> initial backup of the 1.5TB large prod database would get restored as
> a (shut down) sync instance on the test server on the COW filesystem.
> A script on the test server, would then apply Oracle archive files
> from the production environment to this Oracle sync database, every
> 10'th minute, effectively making it near up-to-date with production.
> The most reliable way to do this was with a simple NFS mount (rather
> than rsync or samba). The idea then was, that it would be very fast
> and easy to make a new snapshot of the sync database, start it up, and
> voila you'd have a new instance ready to play with. A desktop machine
> with ext4 partitions proved lower boundary for applying archivelog
> data at around 1200 kb/s - we expected an order of magnitude higher
> performance on the server.
>
> BTRFS experiences
> We used native BTRFS from kernel; with atime off, ssd mode. BTRFS
> proved to be very fast at reading for a large TRDBMS (2x speedup
> compared to a SAN). However, applying archivelog on a BTRFS filesystem
> proved to scale poorly, by starting out with a decent apply rate it
> would eventually end down around 400-500 kb/s. BTRFS had to be
> abandoned due to this, since the script would never be able to finish
> applying archivelog as new ones arrived. The desktop machine with
> traditional spinning drives formatted for BTRFS showed a similar
> scenario, so hardware (server, controller and disks) was excluded as a
> cause.

Can you talk more about this decent apply rate ending up down at
400-500kb/s? We've been seeing degrading performance in our workloads
but thought it was due to snapshot abuse. (ie, large writes start out
at say 110MB/s and get slower the longer we run it — though we've
never run it long enough to go slower than about half starting speed.)


>
> ZFS experiences
> We then tried using ZFS via custom-built SPL/ZFS 0.6.0-rc10 modules
> with recordsize equal to that of Oracle database (8K); compression
> off, quota off, dedup off, checksum on and atime on.
> ZFS proved to be on-pair with a SAN, when it comes to reading for a
> large TRDBMS. Thankfully, ZFS did not degrade much in archivelog apply
> performance, and proved to have a lower-boundary of 15MB/s.
>
> Conclusion
> We had hoped to be able to utilize BTRFS, due to it's license and
> inclusion in the Linux mainline kernel. However, for practical
> purposes, we're not able to make use of BTRFS due to its performance
> when writing -especially considering this is even without mixing in
> shapshotting. While ZFS doesn't give us quite the boost in read
> performance we had expected from SSD's, it seems more optimized for
> writting and will allow us to complete our project of getting clones
> of a production database environment up and running in a snap.
>
> Take it for what it's worth, a couple of developers experiences with
> BTRFS. We are not likely to go back and change things now it works,
> but we are curious as to why we see such big differences between the
> two file-systems. Any comments and/or feedback appreciated.
>
> Regards,
> Jesper and Casper
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
