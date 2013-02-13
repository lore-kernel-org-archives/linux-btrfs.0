Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab3BMV7V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 16:59:21 -0500
Date: Wed, 13 Feb 2013 13:58:33 -0800
From: Zach Brown <zab@redhat.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        chris.mason@fusionio.com, dsterba@suse.cz, kreijack@gmail.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
Message-ID: <20130213215833.GC22221@lenny.home.zabbo.net>
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
 <5119C379.7080305@redhat.com>
 <5119D813.40101@jp.fujitsu.com>
 <511A8228.9060109@redhat.com>
 <20130212205731.GA11872@lenny.home.zabbo.net>
 <511B18BD.7070706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <511B18BD.7070706@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >why it failed.  But it might not be able to because /proc/swaps is
> >fundamentally unreliable.
> 
> Then, how should we do?    I have no idea...

Hmm.  I think I'd do something like:

- First always open with O_EXCL.  If it succeeds then there's no reason
  to check /proc/swaps at all.  (Maybe it doesn't need to try
  check_mounted() there either?  Not sure if it's protecting against 
  accidentally mounting mounted shared storage or not.)

- Try stat()ing the /proc/swaps paths and the command line path.  If they
  point to the same inode then print a helpful message that the open
  might have failed because the file is an active swap file.

- Use realpath() to resolve the relative path into an absolute path.
  Copy it and escape control chars ("\n\t\\") with their \0xxx octal
  equivalents.  If the mangled absolute path matches the path in
  /proc/swaps (without opening), print the helpful message.

- At no point is failure of any of the /proc/swaps parsing fatal.  It'd
  carry on ignoring errors until it doesnt have work to do.  It'd only
  ever print the nice message when it finds a match.
  
That seems reasonable to me.  It costs nothing in the vast majority of
invocations when nothing goes wrong, it doesn't *cause* problems, and
it'd print helpful messages on boring normal systems when someone really
does accidentally try and mkfs a swapfile.

In very rare cases /proc/swaps won't be of any help.  The user would
only see the open failure.  That's fine, it's just not worth worrying
about.

- z
