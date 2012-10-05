Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:49376 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2JEG7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 02:59:52 -0400
Message-ID: <3705968.4334561349420385200.JavaMail.root@wmail79>
Date: Fri, 5 Oct 2012 08:59:45 +0200 (CEST)
From: "kreijack@inwind.it" <kreijack@inwind.it>
Reply-To: "kreijack@inwind.it" <kreijack@inwind.it>
To: <chris.mason@fusionio.com>
Subject: R: Re: [RESPOST][BTRFS-PROGS][PATCH] btrfs_read_dev_super():
 uninitialized variable
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>----Messaggio originale----
>Da: chris.mason@fusionio.com
>Data: 05/10/2012 2.30
>A: "kreijack@inwind.it"<kreijack@inwind.it>
>Cc: "Chris Mason"<clmason@fusionio.com>
>Ogg: Re: [RESPOST][BTRFS-PROGS][PATCH] btrfs_read_dev_super(): uninitialized 
variable
>
>On Tue, Sep 11, 2012 at 11:55:49AM -0600, Goffredo Baroncelli wrote:
>> This is a repost because I rebased the change. The first attempt was 
>> done with the email "[BTRFS-PROGS][BUG][PATCH] Incorrect detection of a 
>> removed device  [was Re: “Bug”-report: inconsistency kernel <-> tools]" 
>> dated 08/31/2012.
>> 
>> In the function btrfs_read_dev_super() it is possible to use the 
>> variable fsid without initialisation.
>> 
>> In btrfs_read_dev_super(), during the scan of the superblock the 
>> variable fsid is initialised with the value of fsid of the first 
>> superblock. But if the first superblock contains an incorrect signature 
>> this initialisation is skipped.

[...]
+               } else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+                       /*
+                        * the superblocks (the original one and
+                        * its backups) contain data of different
+                        * filesystems -> the super cannot be trusted
+                        */
+                       return -1;
+               }
[...]


>This does make sense, but it ends up causing problems.  It is possible
>that you do something like this:
>
>mkfs.btrfs /dev/sda
>do a test
>mkfs.btrfs -b some_really_small_size /dev/sda
>do a test
>
>xfstests does this to test enospc.  The very small device doesn't have
>as many supers as the large device, and the end result is your check for
>the fsids on the supers makes mkfs fail.
>
>I've replaced the return -1 with a continue for now, but I'm open to
>other suggestions.

I had to give a look to the commitdiff to understand what you meant :-)
Because the superblock are protected by a checksum, we can detect a currupted 
block;
so the first valid fsid are more trusted than the following ones. If the other 
superblocks have 
a different fsid, skipping them should be the right thing to do.

>
>-chris
>


