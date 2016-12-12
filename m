Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34416 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753956AbcLLETe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 23:19:34 -0500
Received: by mail-io0-f177.google.com with SMTP id p42so156682934ioo.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 20:19:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS=91WcH2s91DUG+RBv=kSKHrVF61Cn124EKskavTQMQg@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
 <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
 <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
 <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com>
 <CAJCQCtQLRRaAyCa8DBHmcizcLHTajmp_vzGU7MkEvshtO4bbNQ@mail.gmail.com>
 <CADph71yACvRhb6AWixoaR28+VHZeaGmZqawqY3MSBcSeJM=6Qw@mail.gmail.com>
 <CAJCQCtT1y+j2d9x907CZaT+g-21nQ1MkC1gR9eJdZ5xPRuPAng@mail.gmail.com>
 <CADph71xdM4A2zd0ACmm4GNVp=Jwdp7935q9ur8bkha4+PmVSHg@mail.gmail.com> <CAJCQCtS=91WcH2s91DUG+RBv=kSKHrVF61Cn124EKskavTQMQg@mail.gmail.com>
From: Markus Binsteiner <makkus@gmail.com>
Date: Mon, 12 Dec 2016 17:19:33 +1300
Message-ID: <CADph71wu8s_itjcbYq3KEiHQc7WR=YqjcHxqQyvDPkEb8pYfNw@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, some news. I chrooted into the old OS-root (Jessie), and low and
behold, old-version btrfs-find-root seemed to work:

# btrfs-find-root /dev/mapper/think--big-home
Super think's the tree root is at 138821632, chunk root 21020672
Well block 4194304 seems great, but generation doesn't match, have=2,
want=593818 level 0
Well block seems great, but generation doesn't match, have=3,
want=593818 level 0
Well block 29360128 seems great, but generation doesn't match,
have=593817, want=593818 level 1
Well block 29425664 seems great, but generation doesn't match,
have=593817, want=593818 level 0
Well block 29507584 seems great, but generation doesn't match,
have=593817, want=593818 level 0
Well block 29523968 seems great, but generation doesn't match,
have=593817, want=593818 level 0
Found tree root at 138821632 gen 593818 level 0

That's it though. Shouldn't there be many more lines for a filesytem that old?

I've tried btrfs restore for a few of those (both using old and new
btrfs restore versions), doesn't crash for the older generations:

# btrfs-find-root /dev/mapper/think--big-home
Super think's the tree root is at 138821632, chunk root 21020672
Well block 4194304 seems great, but generation doesn't match, have=2,
want=593818 level 0
Well block 4243456 seems great, but generation doesn't match, have=3,
want=593818 level 0
Well block 29360128 seems great, but generation doesn't match,
have=593817, want=593818 level 1
Well block 29425664 seems great, but generation doesn't match,
have=593817, want=593818 level 0
Well block 29507584 seems great, but generation doesn't match,
have=593817, want=593818 level 0
Well block 29523968 seems great, but generation doesn't match,
have=593817, want=593818 level 0
Found tree root at 138821632 gen 593818 level 0
root@think:/root# btrfs restore /dev/mapper/think--big-home /tmp -D -v
-i -t 4243456
parent transid verify failed on 4243456 wanted 593818 found 3
parent transid verify failed on 4243456 wanted 593818 found 3
Ignoring transid failure
This is a dry-run, no files are going to be restored
Reached the end of the tree searching the directory

But does crashes for 29360128 and 29425664:

# btrfs restore /dev/mapper/think--big-home /tmp -D -v -i -t 29360128
parent transid verify failed on 29360128 wanted 593818 found 593817
parent transid verify failed on 29360128 wanted 593818 found 593817
parent transid verify failed on 29360128 wanted 593818 found 593817
parent transid verify failed on 29360128 wanted 593818 found 593817
Ignoring transid failure
volumes.c:1554: btrfs_chunk_readonly: Assertion `!ce` failed.
btrfs[0x435f1e]
btrfs[0x435f42]
btrfs[0x4384f9]
btrfs[0x42f44a]
btrfs[0x42ab64]
btrfs[0x42aec5]
btrfs[0x42af74]
btrfs[0x41e7d9]
btrfs[0x40b46a]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f618e103b45]
btrfs[0x40b497]

and fails for 29507584 and 29523968:

# btrfs restore /dev/mapper/think--big-home /tmp -D -v -i -t 29507584
parent transid verify failed on 29507584 wanted 593818 found 593817
parent transid verify failed on 29507584 wanted 593818 found 593817
parent transid verify failed on 29507584 wanted 593818 found 593817
parent transid verify failed on 29507584 wanted 593818 found 593817
Ignoring transid failure
Couldn't setup extent tree
Couldn't setup device tree
Could not open root, trying backup super
parent transid verify failed on 29507584 wanted 593818 found 593817
parent transid verify failed on 29507584 wanted 593818 found 593817
parent transid verify failed on 29507584 wanted 593818 found 593817
parent transid verify failed on 29507584 wanted 593818 found 593817
Ignoring transid failure
Couldn't setup extent tree
Couldn't setup device tree
Could not open root, trying backup super
No valid Btrfs found on /dev/mapper/think--big-home
Could not open root, trying backup super


> The old chunk root and tree root might come in handy, from backup0,
> which is the generation prior to the one currently set in the super
> blocks. The bytes_used vs dev_item.bytes_used is also interesting,
> huge difference. So it looks like this was umounted very soon after
> you realized what you did.

Yes, Did that as soon as I realized something was amiss. To be honest,
I'm not even 100% sure anymore what exactly I did, I just assumed I
deleted my home directory because I was deleting a directory a minute
or so before everything fell to pieces and my home directory was gone.
Also, it wouldn't be totally unlike me to have done that :-)


> What do you get for
>
> btrfs restore -l <dev>
>
> Maybe just try this, which is the oldest generation we know about
> right now, which is found in backup root 2.
>
> sudo btrfs restore -D -v -t 138788864 /dev/mapper/brick1 .

# btrfs restore -D -v -t 138788864 /dev/mapper/think--big-home  .
checksum verify failed on 138788864 found 2E842E3E wanted 9D4DED61
checksum verify failed on 138788864 found 2E842E3E wanted 9D4DED61
checksum verify failed on 138788864 found 62A944D5 wanted 0C5CE041
checksum verify failed on 138788864 found 62A944D5 wanted 0C5CE041
bytenr mismatch, want=138788864, have=3463101449461224633
Couldn't read tree root
Could not open root, trying backup super
checksum verify failed on 138788864 found 2E842E3E wanted 9D4DED61
checksum verify failed on 138788864 found 2E842E3E wanted 9D4DED61
checksum verify failed on 138788864 found 62A944D5 wanted 0C5CE041
checksum verify failed on 138788864 found 62A944D5 wanted 0C5CE041
bytenr mismatch, want=138788864, have=3463101449461224633
Couldn't read tree root
Could not open root, trying backup super
ERROR: superblock bytenr 274877906944 is larger than device size 254007050240
Could not open root, trying backup super

Cheers,
Markus
