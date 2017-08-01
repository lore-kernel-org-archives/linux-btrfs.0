Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:48038 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdHANOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 09:14:16 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:38350)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dcX02-0001Of-BP
        for linux-btrfs@vger.kernel.org; Tue, 01 Aug 2017 14:14:14 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dcWzw-0001ht-25
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 14:14:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22912.32415.601826.757780@tree.ty.sabi.co.uk>
Date: Tue, 1 Aug 2017 14:14:07 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <6022267.255.1501581534233.JavaMail.gkos@dynomob>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
        <22907.32175.311827.10738@tree.ty.sabi.co.uk>
        <19527869.26.1501422186960.JavaMail.gkos@dynomob>
        <22911.5971.350346.969146@tree.ty.sabi.co.uk>
        <6022267.255.1501581534233.JavaMail.gkos@dynomob>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Peter, I don't think the filefrag is showing the correct
> fragmentation status of the file when the compression is used.

As reported on a previous message the output of 'filefrag -v'
which can be used to see what is going on:

>>>> filefrag /mnt/sde3/testfile 
>>>>   /mnt/sde3/testfile: 49287 extents found

>>>> Most the latter extents are mercifully rather contiguous, their
>>>> size is just limited by the compression code, here is an extract
>>>> from 'filefrag -v' from around the middle:

>>>>   24757:  1321888.. 1321919:   11339579..  11339610:     32:   11339594:
>>>>   24758:  1321920.. 1321951:   11339597..  11339628:     32:   11339611:
>>>>   24759:  1321952.. 1321983:   11339615..  11339646:     32:   11339629:
>>>>   24760:  1321984.. 1322015:   11339632..  11339663:     32:   11339647:
>>>>   24761:  1322016.. 1322047:   11339649..  11339680:     32:   11339664:
>>>>   24762:  1322048.. 1322079:   11339667..  11339698:     32:   11339681:
>>>>   24763:  1322080.. 1322111:   11339686..  11339717:     32:   11339699:
>>>>   24764:  1322112.. 1322143:   11339703..  11339734:     32:   11339718:
>>>>   24765:  1322144.. 1322175:   11339720..  11339751:     32:   11339735:
>>>>   24766:  1322176.. 1322207:   11339737..  11339768:     32:   11339752:
>>>>   24767:  1322208.. 1322239:   11339754..  11339785:     32:   11339769:
>>>>   24768:  1322240.. 1322271:   11339771..  11339802:     32:   11339786:
>>>>   24769:  1322272.. 1322303:   11339789..  11339820:     32:   11339803:

>>>> But again this is on a fresh empty Btrfs volume.

As I wrote, "their size is just limited by the compression code"
which results in "128KiB writes". On a "fresh empty Btrfs volume"
the compressed extents limited to 128KiB also happen to be pretty
physically contiguous, but on a more fragmented free space list
they can be more scattered.

As I already wrote the main issue here seems to be that we are
talking about a "RAID5 with 128KiB writes and a 768KiB stripe
size". On MD RAID5 the slowdown because of RMW seems only to be
around 30-40%, but it looks like that several back-to-back 128KiB
writes get merged by the Linux IO subsystem (not sure whether
that's thoroughly legal), and perhaps they get merged by the 3ware
firmware only if it has a persistent cache, and maybe your 3ware
does not have one, but you have kept your counsel as to that.

My impression is that you read the Btrfs documentation and my
replies with a lot less attention than I write them. Some of the
things you have done and said make me think that you did not read
https://btrfs.wiki.kernel.org/index.php/Compression and 'man 5
btrfs', for example:

   "How does compression interact with direct IO or COW?

     Compression does not work with DIO, does work with COW and
     does not work for NOCOW files. If a file is opened in DIO
     mode, it will fall back to buffered IO.

   Are there speed penalties when doing random access to a
   compressed file?

     Yes. The compression processes ranges of a file of maximum
     size 128 KiB and compresses each 4 KiB (or page-sized) block
     separately."

> I am currently defragmenting that mountpoint, ensuring that
> everrything is compressed with zlib.

Defragmenting the used space might help find more contiguous
allocations.

> p.s. any other suggestion that might help with the fragmentation
> and data allocation. Should I try and rebalance the data on the
> drive?

Yes, regularly, as that defragments the unused space.
