Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855B5C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 18:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463DB2184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 18:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfCNS6x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 14:58:53 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:54450 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfCNS6w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 14:58:52 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id DA04A60064;
        Thu, 14 Mar 2019 18:58:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id X5Z7ATOaGgd2; Thu, 14 Mar 2019 18:58:47 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Thu, 14 Mar 2019 18:58:47 +0000 (UTC)
Message-ID: <beebed47702d783e00d3478f217ffc646d47bb92.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Thu, 14 Mar 2019 19:58:45 +0100
In-Reply-To: <20190307200712.GG23918@hungrycats.org>
References: <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
         <20190212165916.GA23918@hungrycats.org>
         <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
         <20190212181328.GB23918@hungrycats.org>
         <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
         <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
         <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
         <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
         <20190215054031.GC9995@hungrycats.org>
         <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
         <20190307200712.GG23918@hungrycats.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey again.

And again thanks for your time and further elaborate explanations :-)


On Thu, 2019-03-07 at 15:07 -0500, Zygo Blaxell wrote:
> In 2016 there were two kernel bugs that silently corrupted reads of
> compressed data.  In 2015 there were...4?  5?  Before 2015 the
> problems
> are worse, also damaging on-disk compressed data and crashing the
> kernel.
> The bugs that were present in 2014 were present since compression was
> introduced in 2008.

Phew... too much [silent] corruption bugs in btrfs... :-(

Actually I didn't even notice the others (which unfortunately doesn't
mean I'm definitely not affected), so I probably cannot much do/check
about them now... but only about the "recent" one that was fixed now.

But maybe there should be something like a btrfs-announce list, i.e. a
low volume mailing list, in which (interested) users are informed about
more grave issues.
Such things can happen and there's no one to blame about that... but if
they happen it would be good for users to get notified so that they can
check their systems and possibly recover data from (still existing)
other sources.


> Run compsize (sometimes the package is named btrfs-compsize) and see
> if
> there are any lines referring to zlib, zstd, or lzo in the output.
> If it's all "total" and "none" then there's no compression in that
> file.
> 
> filefrag -v reports non-inline compressed data extents with the
> "encoded"
> flag, so
> 
> 	if filefrag -v "$file" | grep -qw encoded; then
> 		echo "$file" is compressed, do something here
> 	fi
> 
> might also be a solution (assuming your filename doesn't include the
> string 'encoded').

Will have a look at this.


As for all the following:

> > > 	- you never punch holes in files
> > 
> > Is there any "standard application" (like cp, tar, etc.) that would
> > do
> > this?
> 
> Legacy POSIX doesn't have the hole-punching concept, so legacy
> tools won't do it; however, people add features to GNU tools all the
> time, so it's hard to be 100% sure without downloading the code and
> reading/auditing/scanning it.  I'm 99% sure cp and tar are OK.
> 
> > What do you mean by clone? refcopy? Would btrfs snapshots or btrfs
> > send/receive be affected?
> 
> clone is part of some file operation syscalls (e.g. clone_file_range,
> dedupe_range) which make two different files, or two different
> offsets in
> the same file, refer to the same physical extent.  This is the basis
> of
> deduplication (replacing separate copies with references to a single
> copy) and also of punching holes (a single reference is split into
> two references to the original extent with a hole object inserted in
> the middle).
> 
> "reflink copy" is a synonym for "cp --reflink", which is
> clone_file_range
> using 0 as the start of range and EOF as the end.  The term 'reflink'
> is sometimes used to refer to any extent shared between files that is
> not the result of a snapshot.  reflink is to extents what a hardlink
> is
> to inodes, if you ignore some details.
> 
> To trigger the bug you need to clone the same compressed source range
> to two nearly adjacent locations in the destination file (i.e. two or
> more ranges in the source overlap).  cp --reflink never overlaps
> ranges,
> so it can't create the extent pattern that triggers this bug *by
> itself*.
> 
> If the source file already has extent references arranged in a way
> that triggers the bug, then the copy made with cp --reflink will copy
> the arrangement to the new file (i.e. if you upgrade the kernel, you
> can correctly read both copies, and if you don't upgrade the kernel,
> both copies will appear to be corrupted, probably the same way).
> 
> I would expect btrfs receive may be affected, but I did not find any
> code in receive that would be affected.  There are a number of
> different
> ways to make a file with a hole in it, and btrfs receive could use a
> different one not affected by this bug.  I don't use send/receive
> myself,
> so I don't have historical corruption data to guess from.
> 
> > Or is there anything in btrfs itself which does any of the two per
> > default or on a typical system (i.e. I didn't use dedupe).
> 
> 'btrfs' (the command-line utility) doesn't do these operations as far
> as I can tell.  The kernel only does these when requested by
> applications.
> 
> > Also, did the bug only affect data, or could metadata also be
> > affected... basically should such filesystems be re-created since
> > they
> > may also hold corruptions in the meta-data like trees and so on?
> 
> Metadata is not affected by this bug.  The bug only corrupts btrfs
> data
> (specificially, the contents of files) in memory, not disk.

So all the above, AFAIU, basically boils down to the following:


Unless such hole-punched files were brought into the filesystem by one
of the rather special things like:

- dedupe
- an application that by itself does the hole-punching of which most
  users will probably only have qemu which can do it 

...a normal user should probably not have encountered the issue, as
it's not triggered by typical end-user operations (cp, mv, tar, btrfs
send/receive, cp --reflink=always/auto).

With the exception that cp --reflink=always/auto, will duplicate (but
by itself not corrupt) a file that *ALREADY* has a reflink/hole
pattern, that is prone to the issue.
So, AFAIU, such a file would be correctly copied, but on read it would
also suffer from the curruption, just like the original.
But again, if nothing like qemu was used in the first place, such file
shouldn't be in the filesystem.

Further, I'd expect that if users followed the advise and used
nodatacow on their qemu images,... compression would be disabled for
these as well, and they'd be safe again, right?


=> Summarising... the issue is (with the exception of qemu and dedupe
users) likely not that much of an issue for normal end-users.




What about the direct IO issues that may be still present and which
you've mentioned above... is this used somewhere per default / under
normal circumstances?



> > - or I directly create the files on the data disks (which use
> > compress)
> >   by means of wget, scp or similar from other sources
> >   => should be safe, too, as they probably don't do dedupe/hole
> >      punching by default
> > 
> > - or I cp/mv from them camera SD cards, which use some *FAT
> >   => so again I'd expect that to be fine
> > 
> > - on vacation I had the case that I put large amount of
> > picture/videos
> >   from SD cards to some btrfs-with-compress mobile HDDs, and back
> > home
> >   from these HDDs to my actual data HDDs.
> >   => here I do have the read / re-write pattern, so data could have
> >      been corrupted if it was compressed + deduped/hole-punched
> >      I'd guess that's anyway not the case (JPEGs/MPEGs don't
> > compress
> >      well)... and AFAIU there would be no deduping/hole-punching 
> >      involved here
> 
> dedupe doesn't happen by itself on btrfs.  You have to run dedupe
> userspace software (e.g. duperemove, bees, dduper, rmlint, jdupes,
> bedup,
> etc...) or build a kernel with dedupe patches.

Which I both have not, so should be fine.


> It's highly likely
> that
> the hashes match the input data, because the file will usually be
> cached
> in host RAM from when it was written, so the bug has no opportunity
> to
> appear.

That's what I had in mind.


> It's not impossible for other system activity to evict those
> cached pages between the copy and hash, so the hash function might
> reread
> the data from disk again and thus be exposed to the bug.

Sure... which is especially very likely to be the case for any bigger
amounts of data that I've copied.
But anything bigger is typically pictures/videos, which I would
guess/assume not to be compressed at all.
But even then I should be still safe, as cp --reflink=auto/always
doesn't introduce the bug by itself, as you've said above.
Right?


> Contrast with a copy tool which integrates the SHA512 function, so
> the SHA hash and the copy consume their data from the same RAM
> buffers.
> This reduces the risk of undetected error but still does not
> eliminate it.

Hehe, I'd like to see that in GNU coreutils ;-)


> A DRAM access failure could corrupt either the data or SHA hash but
> not
> both

Unless, against all odds in the universe... you get that one special
hash collision where corrupted file and/or hash match again :D


>  so the hash will fail verification later, but you won't know if
> the hash is incorrect or the data.

Sure, but at least I would notice could try to recover from some backup
then.




> > But when I e.g. copy data from SD, to mobile btrfs-HDD and then to
> > the
> > final archive HDD... corruption could in principle occur when
> > copying
> > from mobile HDD to archive HDD.
> > In that case, would a diff between the two show me the corruption?
> > I
> > guess not because the diff would likely get the same corruption on
> > read?
> 
> Upgrade your kernel before doing any verification activity; otherwise
> you'll just get false results.

Well that's clear if I do the verification *now* ... I rather meant
here: would a diff have noticed it the past (where I still had the
originals)... for which the answer seems to be: possibly not


> > But since I use send/receive anyway in just one direction from the
> > master to the backup disks... only the later could be affected.
> 
> I presume from this line of questioning that you are not in the habit
> of verifying the SHA512 hashes on your data every few weeks or
> months.

Actually I do about every half year... my main point in the
"investigation" of my typical usage scenarios above was, whether any of
them could have introduced corruption in which my hashes wouldn't have
noticed it.

I guess all of my patterns of moving/copying data to these main data
HDDs that used btrfs+compressions should be safe (since you said cp/mv
is even with --reflink=always)...


The only questionable one is, where I copied data from some SD card to
an intermediate btrfs (that also used compression) and from there to
the final location on the main data HDDs.

Over time, I've used different ways to calc the XATTRs there:
In earlier times I did it on the intermediate btrfs (which would make
it in principle suspicious to not noticing corruption - if(!) I had not
used cp only, which should be safe as you say)... followed (after
clearing the kernel cache) by a recursive diff between SD and
intermediate btrfs (assuming that btrfs' checksuming would show me any
corruption error when re-reading from disk).

Later I did it similarly to what you suggested above:
Creating hash lists from the data on the SD... also creating the hashes
for the XATTR on the intermediate btrfs (which would have again been in
principle prone to the bug)... but then diffing the two, which should
have shown me any corruption.


> If you had that step in your scheduled backup routine, then you would
> already be aware of data corruption bugs that affect you--or you'd
> already be reasonably confident that this bug has no impact on your
> setup.

I think by now I'm pretty confident that I, personally, am safe.

The main points for this were:
- XATTRs not being affected
- cp (with any value for --reflink=) never creating the corruption
(as you've said both above)

and with
- send/receive likely being safe
- snapshots being not affected
means that my backup disks are likely unaffected as well.
But obviously I'll check this (by verifying all hashes on the master
disks... and by diffing the masters with the copies) on a fixed kernel,
which I think has just landed in Debian unstable.


Some time ago I had to split the previously one 8TiB master disk into
two (both using compress) as the one ran out of space.
But this should be also safe, as I've used just cp --reflink=auto which
shouldn't introduce the bug by itself AFAIU, followed by extensive
diff-ing... so especially the XATTRs should be still safe, too.

Also, I always create a list of all hash+pathname from the XATTRs
(basically in sha512sum(1) format and if I do another snapshot, I
compare previous lists with the fresh one... so I'd have noticed any
corruption there.
So for me the main point was really, whether data could have been
already corrupted when "introduced" to the filesystem via (especially)
cp or a series of cp.


> If you had asked questions like "is this bug the reason why I've been
> seeing random SHA hash verification failures for several years?" then
> you should worry about this bug; otherwise, it probably didn't affect
> you.

I think you're right... but my data with many thousands of pictures,
etc. from all life is really precious to me, so I better wanted to
understand the issue in "depth"... and I think these questions and your
answers may still benefit others who may also want to find out whether
they could have been silently affected :-)


Cheers and thanks,
Chris.

