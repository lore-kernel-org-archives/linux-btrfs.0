Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:58170 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbdCRBGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 21:06:32 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:56326)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.to.sabi.co.uk>)
        id 1cp2YK-0038KE-Gv
        for linux-btrfs@vger.kernel.org; Sat, 18 Mar 2017 00:49:04 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cp2YF-0007G5-8N
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Mar 2017 00:48:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22732.33786.897187.853556@tree.ty.sabi.co.uk>
Date: Sat, 18 Mar 2017 00:48:58 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS Metadata Corruption Prevents Scrub and btrfs check
In-Reply-To: <CAAafysFBYkAe9pgmnky4-Rxd0r1Xau3rb2ueT0Yu+rjDT9+Atw@mail.gmail.com>
References: <CAAafysHAZ_1-4rTqsY4cw0rkBgq3f_F29nM+=XsDEhNvR8CkJQ@mail.gmail.com>
        <22731.59878.724789.333618@tree.ty.sabi.co.uk>
        <CAAafysFBYkAe9pgmnky4-Rxd0r1Xau3rb2ueT0Yu+rjDT9+Atw@mail.gmail.com>
From: pg@btrfs.list.to.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> How can I attempt to rebuild the metadata, with a treescan or
> otherwise?

I don't know unfortunately for backrefs.

>> In general metadata in Btrfs is fairly intricate and metadata
>> block loss is pretty fatal, that's why metadata should most
>> times be redundant as in 'dup' or 'raid1' or similar:

> All the data and metadata on this system is in raid1 or
> raid10, in fact I discovered this issue while trying to change
> my balance form raid1 to raid10.

> johnf@carbon:~$ sudo btrfs fi df /
> Data, RAID10: total=1.13TiB, used=1.12TiB
> Data, RAID1: total=5.17TiB, used=5.16TiB
> System, RAID1: total=32.00MiB, used=864.00KiB
> Metadata, RAID10: total=3.09GiB, used=3.08GiB
> Metadata, RAID1: total=13.00GiB, used=10.16GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

That's weird because as a rule when there is a checksum error
it is automatically corrected on read if there is a "good copy".
Also because you have both RAID1 and RAID10 data and metadata.
You should have just RAID1 metadata and RAID10 data or both
RAID10. There is probably an "interrupted" 'balance'.

Just had a look at your previous message and it reports out of
12.56TB 2 uncorrectable errors. But you have got everything
redundant ('raid1' or 'raid10', so it looks like somehow those
two blocks are supposed to be copies of each other and are bad:

* 'sdg1' at physical sector 5016524768 volume byte offset 9626194001920
* 'sdh1' at physical sector 5016524768 volume byte offset 9626194001920
* both sectors belong to the tree at byte offset 4804958584832.

Note: BTW I remember someone wrote a guide to decoding Btrfs
'dmesg' lines, but I can't find it anymore, so not sure that
interpretation is entirely correct.

It is a bit "strange" that it is the same sector, as Btrfs
'raid1' profile is not necessarily block-for-block, mirrored
chunks can be in different offsets.

The "strange" symptoms hint not just at disk issues, but also
some past attempts at conversion (I remember a previous message
from you) or recovery have messed up things a bit.

Someone mentioned in some mailing list articles various tools to
print out trees and subtrees and in general inspect. 'Knorrie'
has written a Python library (and a few inspection tools) with
which it is possible to traverse various Btrfs trees, but I
haven't used it:

 https://github.com/knorrie/python-btrfs/

I'd suggest searching the mailing list for related information.
Also the relevant tree is described here (the one on kernel.org
probably is more up-to-date):

  https://oss.oracle.com/projects/btrfs/dist/documentation/btrfs-backrefs.html
  https://btrfs.wiki.kernel.org/index.php/Btrfs_design#Explicit_Back_References
  https://btrfs.wiki.kernel.org/index.php/Data_Structures
  https://btrfs.wiki.kernel.org/index.php/Trees

You might want to use 'btrfs inspect-internal'.

Conceivably as the issue seems related to an extent backref
'btrfsck --repair' with '--init-extent-tree' might help, but I
cannot recommend that as I don't know if they are relevant to
your problem and/or safe in your situation. Consider this:

  http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg26816.html

I would use the very most recent version of 'btrfsprogs'.

One possibility I would consider is to move a sufficiently large
subtree of:

  /home/johnf/personal/projects/openwrt/trunk/build_dir/target-mips_r2_uClibc-0.9.32/hostapd-wpad-mini/hostapd-20110117/hostapd/hostapd.eap_user

into its own directory, create a new subvolume, 'cp --reflink'
everything except that directory into the new subvolume, and
then *perhaps* work on the new subvolume will not access the
damaged metadata block.
