Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:42045 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071AbaJVTlN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 15:41:13 -0400
Message-ID: <54480856.9020604@pobox.com>
Date: Wed, 22 Oct 2014 12:41:10 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Uh, 1COW?... what happens when someone does this...
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I've been considering some NOCOW files (for VM disk images), but some 
questions arose. IS there a "1COW" (copy on write only once) flag or are 
the following operations dangerous or undefined?

(1) The page https://btrfs.wiki.kernel.org/index.php/FAQ (section "Can 
copy-on-write be turned off for data blocks?") says "COW may still 
happen if a snapshot is taken." Is that a "may" or a "will", e.g. if I 
take a snapshot and then start the VM will the file in the snapshot 
still be frozen or will it update as I alter the VM? Does the 
read-only-or-not status of the snapshot matter in this outcome?

e.g. what does "may" mean in that section?

(2) If you copy a file using "cp --reflink" and the destination is in a 
directory marked NOCOW, what happens? How about when the resultant file 
is modified in place?

(3) when using a watever.qcow2 virtual machine image that does 
copy-on-write in the VM (such as QEMU) is it better, worse, or a no-op 
to have the NOCOW flag set on the file? All the advice on this matter I 
can find in Google seems to be "VM images bad, but will be addressed 
soon" and its old enough that I don't know if "soon" has come to pass.

It seems like there is a 1COW flag implicit somewhere.

Just curious.
