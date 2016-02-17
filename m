Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fep28.mx.upcmail.net ([62.179.121.48]:50415 "EHLO
	fep28.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161499AbcBQV1H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 16:27:07 -0500
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep28-int.chello.at
          (InterMail vM.8.01.05.21 201-2260-151-156-20141103) with ESMTP
          id <20160217212702.UYPL24578.viefep28-int.chello.at@edge04.upcmail.net>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 17 Feb 2016 22:27:02 +0100
Date: Wed, 17 Feb 2016 22:26:02 +0100
Message-Id: <201602172126.u1HLQ2H9020811@webminal.org>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
To: David Sterba <dsterba@suse.cz>, Btrfs <linux-btrfs@vger.kernel.org>,
        lakshmipathi <lakshmipathi.g@giis.co.in>
Subject: Re: [PATCH][btrfs-progs] Include file verification with convert-tests
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think its a good idea to populate fs and verify them after conversion.
I'm not sure about existing tools, simply we can create local script to
this testsuite. Some thoughts on possible data set:

--
a) regular files
   - empty files (touch)
   - smaller files dd if=/dev/zero 
   - smaller files dd if=/dev/urandom 
   
b) directory
   - empty dirs.
   - dir with files 
   - dir depth upto N
   - dir with no file but lot of unlinked entries.
       
c) fast/slow symlink
   - to dir
   - to file

d) hardlink :
   - between files
   - between files in different sub-dir

e) fifo files and sparsefile, broken symlink

f) file and dir with special inode attribute: 
    - immutable flag
    - sticky bit etc

g) file/directory acls:
   - large no.of acls

--
fs images with debugfs tool:

a) an valid image with bad blocks.

b) corrupted images:
Ex: Create duplicate blocks and convert it & expect btrfs-check to catch issue?

Any thoughts on above list, suggestions/comments? thanks!


Cheers,
Lakshmipathi.G 
