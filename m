Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50703 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3JNCyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Oct 2013 22:54:44 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so1767908wgh.29
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Oct 2013 19:54:42 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 13 Oct 2013 23:54:42 -0300
Message-ID: <CAOtrxKPU4QBQzXoZO4Jii2n8xdW0vxpYNO5aPD1va8iUBP9nkg@mail.gmail.com>
Subject: Many questions from a potential btrfs user
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I am seriously considering employing btrfs on my systems, particularly due
to some space-saving features that it has (namely, deduplication and
compression).

In fact, I was (a few moments ago) trying to back up some of my systems to a
2TB HD that has an ext4 filesystem and, in the middle of the last one, I got
the error message that the backup HD was full.

Given that what I backup there are systems where I have some of the data
present multiple times (e.g., my mailbox that is sync'ed via offlineimap, or
videos that I download from online learning sites) and that such data
consists of many small files that are highly compressible (the e-mails) or
large files (the videos), I would like to employ btrfs.

So, after reading the documentation on https://btrfs.wiki.kernel.org/, I am
still unsure of some points and I would like to have some clarifications
and/or expectations set straight.


* I understand that I can convert an ext4 filesystem to btrfs. Will such
  conversion work with an almost full ext4 filesystem? How much overhead
  will be needed to perform the conversion? I can (temporarily) remove some
  files that already are on this backup.

* Is it possible to deduplicate the files that are already in it? As
  mentioned before, there are likely to be many, and some of them are on the
  order of 1 to 2GBs.

* Doing a defragmentation with the filesystem mounted with compression will
  recompress the files (if they are deemed compressible by the
  filesystem). Is that understanding correct?  Will compressed blocks among
  many files also be deduplicated?

* How exactly do the recently merged offline deduplication features in the
  kernel interfere with what was (in my limited understanding) already
  possible with userspace tools like <https://github.com/g2p/bedup>?  Are
  such third-party tools likely to be integrated into btrfs-progs? Are they
  supposed to be kept separate?

* Does this change the on-disk format? Putting it another way, will it be
  safe to possibly go back to a previous kernel, if there is some problem
  with the current kernels? (Not that I necessarily want to go back to a
  previous kernel, but, sometimes, one would need to, say, git bisect the
  kernel).

* I most likely *don't* want to use online deduplication (given my bad
  experiences with ZFS).  With that in mind, is the current userspace
  deduplicaton intended to be run as a cron job? Is the offline
  deduplication too memory intensive?  How much RAM would it be needed for a
  2TB filesystem? Are 2GB enough? How about 4GB?

* Will further runs of the offline deduplication be "incremental" in some
  imprecise sense of the word? That is, if I run the deduplication once and
  immediately run it again (supposing nothing changes), will the 2nd time be
  faster than the first?  (If the disk caches are dropped?)

* Will I be able to add further HDs to my btrfs filesystem, once I get some
  more money to run something like a RAID0 configuration? If I get more HDs
  later, will I be able to change the configuration to, say, RAID5 or RAID6?
  I don't intend to use lvm, unless I have to.


I think that I had other questions, but since it is now past bed time, I
can't remember them. :)

Any further comments and/or guidance will be gladly accepted.


Thanks in advance,

Rogério Brito.


-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://cynic.cc/blog/ : github.com/rbrito : profiles.google.com/rbrito
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
