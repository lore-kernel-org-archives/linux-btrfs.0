Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36774 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbbDQPEV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 11:04:21 -0400
Received: by igblo3 with SMTP id lo3so13793223igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 08:04:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5530D8E7.90301@codepoets.co.uk>
References: <SNT150-W75F9A63B7062DE5A608491A1E30@phx.gbl>
	<5530D8E7.90301@codepoets.co.uk>
Date: Fri, 17 Apr 2015 09:04:19 -0600
Message-ID: <CAJCQCtTKxdwNFQU3nvq9Xt-kXkTRSt8JAxsC-J0Tide9Rn7k4g@mail.gmail.com>
Subject: Re: Mount multiple file system with the same UUID
From: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like XFS v5 and ext4 checksums include fs UUID throughout the
filesystem metadata. For XFS changing the UUID has been disabled in
xfs_admin whereas tune2fs supports changing it (which I'd think could
take quite a while). Btrfs supports it via seed device + device add +
removing seed which also can take quite a while.

Anyway, three file systems are (or are about to be) affected by this
so a general purpose solution seems in order.

http://oss.sgi.com/archives/xfs/2015-04/msg00023.html
http://comments.gmane.org/gmane.comp.file-systems.ext4/44464
https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Checksums

Chris Murphy
