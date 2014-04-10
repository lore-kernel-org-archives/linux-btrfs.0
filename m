Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:32512 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030477AbaDJNYK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 09:24:10 -0400
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 15:21:01 +0200
Message-ID: <4783411.VVGoQz5kVU@fuchsia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


SMART indicates that my notebook disk may soon be failing (an 
unreadable/uncorrectable sector), therefore I intend to exchange it. The 
disk contains a single btrfs filesystem with several nested(!) 
subvolumes, each with several read-only snapshots in a .snapshots 
subdirectory.

As far as I can tell, btrfs currently does not offer a sensible way to  
duplicate the entire contents of the old disk onto a new one. I can use 
cp, rsync, or send/receive to copy the "main" subvolumes. But unless I'm 
missing something obvious, the snapshots are effectively lost. btrfs 
send optionally takes multiple clone sources, but I've never seen an 
example of its usage.

If that's what "experimental" means, I'm willing to accept it. However, 
I'd like to emphasize that there's still something missing. Of course, 
most of all I'd like to be proved wrong.

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/
