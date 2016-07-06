Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33162 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbcGFLhX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 07:37:23 -0400
Received: by mail-it0-f66.google.com with SMTP id y93so14360518ita.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 04:37:23 -0700 (PDT)
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, praiskup@redhat.com,
        adilger@dilger.ca
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
Cc: linux-btrfs@vger.kernel.org, bug-tar@gnu.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
Date: Wed, 6 Jul 2016 07:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-05 05:28, Joerg Schilling wrote:
> Andreas Dilger <adilger@dilger.ca> wrote:
>
>> I think in addition to fixing btrfs (because it needs to work with existing
>> tar/rsync/etc. tools) it makes sense to *also* fix the heuristics of tar
>> to handle this situation more robustly.  One option is if st_blocks == 0 then
>> tar should also check if st_mtime is less than 60s in the past, and if yes
>> then it should call fsync() on the file to flush any unwritten data to disk,
>> or assume the file is not sparse and read the whole file, so that it doesn't
>> incorrectly assume that the file is sparse and skip archiving the file data.
>
> A broken filesystem is a broken filesystem.
>
> If you try to change gtar to work around a specific problem, it may fail in
> other situations.
The problem with this is that tar is assuming things that are not 
guaranteed to be true.  There is absolutely nothing that says that 
st_blocks has to be non-zero if there's data in the file.  In fact, the 
behavior that BTRFS used to have of reporting st_blocks to be 0 for 
files entirely inlined in the metadata is absolutely correct given the 
description of the field by POSIX, because there _are_ no blocks 
allocated to the file (because the metadata block is technically 
equivalent to the inode, which isn't counted by st_blocks).  This is yet 
another example of an old interface (in this case, sparse file 
detection) being short-sighted (read in this case as non-existent).

The proper fix for this is that tar (and anything else that handles 
sparse files differently) should be parsing the file regardless.  It has 
to anyway for a normal sparse file to figure out where the sparse 
regions are, and optimizing for a file that's completely sparse (and 
therefore probably pre-allocated with fallocate) is not all that 
reasonable considering that this is going to be a very rare case in 
normal usage.

