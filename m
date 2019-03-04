Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE4EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 15:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B6E320815
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 15:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbfCDPer (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 10:34:47 -0500
Received: from mailgw-02.dd24.net ([193.46.215.43]:46610 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfCDPeq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2019 10:34:46 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 9FB445FDC0;
        Mon,  4 Mar 2019 15:34:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id ePxiwJSVcfTw; Mon,  4 Mar 2019 15:34:41 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Mon,  4 Mar 2019 15:34:41 +0000 (UTC)
Message-ID: <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Mon, 04 Mar 2019 16:34:39 +0100
In-Reply-To: <20190215054031.GC9995@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
         <20190212030838.GB9995@hungrycats.org>
         <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
         <20190212165916.GA23918@hungrycats.org>
         <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
         <20190212181328.GB23918@hungrycats.org>
         <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
         <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
         <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
         <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
         <20190215054031.GC9995@hungrycats.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey.


Thanks for your elaborate explanations :-)


On Fri, 2019-02-15 at 00:40 -0500, Zygo Blaxell wrote:
> The problem occurs only on reads.  Data that is written to disk will
> be OK, and can be read correctly by a fixed kernel.
> 
> A kernel without the fix will give corrupt data on reads with no
> indication of corruption other than the changes to the data itself.
> 
> Applications that copy data may read corrupted data and write it back
> to the filesystem.  This will make the corruption permanent in the
> copied data.

So that basically means even a cp (without refcopy) or a btrfs
send/receive could already cause permanent silent data corruption.
Of course, only if the conditions you've described below are met.


> Given the age of the bug

Since when was it in the kernel?


> Even
> if
> compression is enabled, the file data must be compressed for the bug
> to
> corrupt it.

Is there a simple way to find files (i.e. pathnames) that were actually
compressed?


> 	- you never punch holes in files

Is there any "standard application" (like cp, tar, etc.) that would do
this?


> 	- you never dedupe or clone files

What do you mean by clone? refcopy? Would btrfs snapshots or btrfs
send/receive be affected?


Or is there anything in btrfs itself which does any of the two per
default or on a typical system (i.e. I didn't use dedupe).


Also, did the bug only affect data, or could metadata also be
affected... basically should such filesystems be re-created since they
may also hold corruptions in the meta-data like trees and so on?


> > compression),... or only when specific file operations were done (I
> > did
> > e.g. cp with refcopy, but I think none of the standard tools does
> > hole-
> > punching)?
> That depends on whether you consider fallocate or qemu to be standard
> tools.

I assume you mean the fallocate(1) program,... cause I wouldn't know
whether any of cp/mv/etc. does the system call fallocate(2) per
default.


My scenario looks about the following, and given your explanations, I'd
assume I should probably be safe:

- my normal laptop doesn't use compress, so it's safe anyway

- my cp has an alias to always have --reflink=auto

- two 8TB data archive disks, each with two backup disks to which the
  data of the two master disks is btrfs sent/received,... which were
  all mounted with compress


- typically I either cp or mv data from the laptop to these disks,
  => should then be safe as the laptop fs didn't use compress,...

- or I directly create the files on the data disks (which use compress)
  by means of wget, scp or similar from other sources
  => should be safe, too, as they probably don't do dedupe/hole
     punching by default

- or I cp/mv from them camera SD cards, which use some *FAT
  => so again I'd expect that to be fine

- on vacation I had the case that I put large amount of picture/videos
  from SD cards to some btrfs-with-compress mobile HDDs, and back home
  from these HDDs to my actual data HDDs.
  => here I do have the read / re-write pattern, so data could have
     been corrupted if it was compressed + deduped/hole-punched
     I'd guess that's anyway not the case (JPEGs/MPEGs don't compress
     well)... and AFAIU there would be no deduping/hole-punching 
     involved here


- on my main data disks, I do snapshots... and these snapshots I 
  send/receive to the other (also compress-mounted) btrfs disks.
  => could these operations involve deduping/hole-punching and thus the
     corruption?


Another thing:
I always store SHA512 hashsums of files as an XATTR of them (like
"directly after" creating such files).
I assume there would be no deduping/hole-punching involved till then,
so the sums should be from correct data, right?

But when I e.g. copy data from SD, to mobile btrfs-HDD and then to the
final archive HDD... corruption could in principle occur when copying
from mobile HDD to archive HDD.
In that case, would a diff between the two show me the corruption? I
guess not because the diff would likely get the same corruption on
read?


> "Ordinary" sparse files (made by seeking forward while writing, as
> done
> by older Unix utilities including cp, tar, rsync, cpio, binutils) do
> not
> trigger this bug.  An ordinary sparse file has two distinct data
> extents
> from two different writes separated by a hole which has never
> contained
> file data.  A punched hole splits an existing single data extent into
> two
> pieces with a newly created hole between them that replaces
> previously
> existing file data.  These actions create different extent reference
> patterns and only the hole-punching one is affected by the bug.
> Files that contain no blocks full of zeros will not be affected by
> fallocate-d-style hole punching (it searches for existing zeros and
> punches holes over them--no zeros, no holes).  If the the hole
> punching
> intentionally introduces zeros where zeros did not exist before (e.g.
> qemu
> discard operations on raw image files) then it may trigger the bug.

So long story short, "normal" file operations (cp/mv, etc.) should not
trigger the bug.


qemu with discard would be a prominent example of triggering the bug,
but luckily for me, I only use this on an fs with compress disabled :-D
Any other such prominent examples?

I assume normal mv of refcopy (i.e. cp --reflink=auto) would not punch
holes and thus be not affected?

Further, I'd assume XATTRs couldn't be affected?


So what remains unanswered is send/receive:

> btrfs send and receive may be affected, but I don't use them so I
> don't
> have any experience of the bug related to these tools.  It seems from
> reading the btrfs receive code that it lacks any code capable of
> punching
> a hole, but I'm only doing a quick search for words like "punch", not
> a detailed code analysis.

Is there some other developer who possibly knows whether send/receive
would have been vulnerable to the issue?


But since I use send/receive anyway in just one direction from the
master to the backup disks... only the later could be affected.


Thanks,
Chris.

