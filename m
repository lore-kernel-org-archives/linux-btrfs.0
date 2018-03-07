Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49210 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753857AbeCGDMj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 22:12:39 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1etPT4-0003qc-3w
        for linux-btrfs@vger.kernel.org; Wed, 07 Mar 2018 04:10:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: spurious full btrfs corruption
Date: Wed, 7 Mar 2018 03:09:58 +0000 (UTC)
Message-ID: <pan$b11ce$9c4dcdf2$ebac9a1f$a7f5a212@cox.net>
References: <26306A4D-2D8E-4661-B89E-9F050FD184D5@scientia.net>
        <BF03A3DF-684D-47FE-A9AD-320256F64763@scientia.net>
        <b6b4ed0e-9569-158d-19ad-82c885bab4ec@gmx.com>
        <BB977A40-847C-4611-A468-9BF1137CE711@scientia.net>
        <d2a14d69-dfa9-8794-6375-03d1b209632f@gmx.com>
        <68697875-6E77-49C4-B54E-0FADB94700DA@scientia.net>
        <99ee9b31-a38a-d479-5b1d-30e9c942d577@gmx.com>
        <A19E863A-F83C-4630-9675-4309CECB318E@scientia.net>
        <1b24e69e-2c1e-71af-fb1d-9d32f72cc78c@gmx.com>
        <8DB99A3B-6238-497D-A70F-8834CC014DCF@gmail.com>
        <c88d6721-ad20-c45d-0ac1-a49f2bab66cb@gmx.com>
        <1519833022.3714.122.camel@scientia.net>
        <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
        <1520297878.4428.39.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 06 Mar 2018 01:57:58 +0100 as
excerpted:

> In the meantime I had a look of the remaining files that I got from the
> btrfs-restore (haven't run it again so far, from the OLD notebook, so
> only the results from the NEW notebook here:):
> 
> The remaining ones were multi-GB qcow2 images for some qemu VMs.
> I think I had non of these files open (i.e. VMs running) while in the
> final corruption phase... but at least I'm sure that not *all* of them
> were running.
> 
> However, all the qcow2 files from the restore are more or less garbage.
> During the btrfs-restore it already complained on them, that it would
> loop too often on them and whether I want to continue or not (I choose n
> and on another full run I choose y).
> 
> Some still contain a partition table, some partitions even filesystems
> (btrfs again)... but I cannot mount them.

Just a note on format choices FWIW, nothing at all to do with your 
current problem...

As my own use-case doesn't involve VMs I'm /far/ from an expert here, but 
if I'm screwing things up I'm sure someone will correct me and I'll learn 
something too, but it does /sound/ reasonable, so assuming I'm 
remembering correctly from a discussion here...

Tip: Btrfs and qcow2 are both copy-on-write/COW (it's in the qcow2 name, 
after all), and doing multiple layers of COW is both inefficient and a 
good candidate to test for corner-case bugs that wouldn't show up in 
more normal use-cases.  Assuming bug-free it /should/ work properly, of 
course, but equally of course, bug-free isn't an entirely realistic 
assumption. =8^0

... And you're putting btrfs on qcow2 on btrfs... THREE layers of COW!

The recommendation was thus to pick what layer you wish to COW at, and 
use something that's not COW-based at the other layers.  Apparently, qemu 
has raw-format as a choice as well as qcow2, and that was recommended as 
preferred for use with btrfs (and IIRC what the recommender was using 
himself).

But of course that still leaves cow-based btrfs on both the top and the 
bottom layers.  I suppose which of those is best to remain btrfs, while 
making the other say ext4 as widest used and hopefully safest general 
purpose non-COW alternative, depends on the use-case.

Of course keeping btrfs at both levels but nocowing the image files on 
the host btrfs is a possibility as well, but nocow on btrfs has enough 
limits and caveats that I consider it a second-class "really should have 
used a different filesystem for this but didn't want to bother setting up 
a dedicated one" choice, and as such, don't consider it a viable option 
here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

