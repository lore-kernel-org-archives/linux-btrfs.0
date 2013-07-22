Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:52654 "EHLO
	homiemail-a68.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752410Ab3GVELQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 00:11:16 -0400
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: george@chinilu.com
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: autodefrag by default, was: Lots of harddrive chatter
Date: Mon, 22 Jul 2013 09:41:12 +0530
Message-ID: <3865098.S4o5hbA3km@bheem>
In-Reply-To: <51ECACC6.1090104@chinilu.com>
References: <ksf42h$suu$1@ger.gmane.org> <5436903.bmHYcuMpfJ@bheem> <51ECACC6.1090104@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, July 21, 2013 08:53:42 PM George Mitchell wrote:
> > system files typically are installed once and never rewritten in place, so
> > they should not be much fragmented to begin with.
> > 
> > now their directory objects, is a different story and so is things like
> > systemd journal, log files, or database files.
> 
> Never rewritten in place?  I wouldn't go that far.  In the case of many 
> distros there is a continual flow of updates which results in some 
> degree of data churning throughout the system filesystems. Just a kernel 
> update, for example, can affect a rather large number of files and 
> directories with new writes while application updates (KDE or even Gnome 
> for example) can cause a large number of files to be rewritten in place.

While it is true that large number of files are changed with each update, most 
of the update delete the existing files and install new one. That does not 
lead to fragmentation of a file.

Unless the packages are patching the files in place(AFAIK, even delta RPMs 
patch the RPM and not the individual files), it would not lead to the 
defragmentation that is problematic on btrfs.

There are two types of defragmentations. first is where files are continually 
added/deleted to the file system, e.g. a mail server. IME btrfs handles that 
quite well.

Another is where a file is constantly updated in place e.g. a 
postgresql/sqlite database. In the second case, COW nature of btrfs causes the 
defragmentation which directly affects the performance, at least on spinning 
hard disks.
-- 
Regards
 Shridhar
