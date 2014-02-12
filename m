Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36580 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaBLHgy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 02:36:54 -0500
Message-ID: <52FB2490.1030207@oracle.com>
Date: Wed, 12 Feb 2014 15:36:48 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs multiple mounts stacked on the same mount point
References: <52F9DCBA.1010002@oracle.com> <pan$9211b$42bef7b0$dd1350ae$978558c5@cox.net> <52FAEC7F.4050707@oracle.com> <pan$783b9$6da610c9$6ead6d9b$966fb3d6@cox.net>
In-Reply-To: <pan$783b9$6da610c9$6ead6d9b$966fb3d6@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> BTW, another (general) reason over-mounts are sometimes used is to
> deliberately obscure what's underneath.  It's worth noting that anything
> with a file already open on the underlying filesystem still has access to
> that file after something else is mounted over top, and that fact is
> sometimes used to control access to certain files/filesystems, by
> starting whatever it is that needs to access them and letting them open
> the files they need, then over-mounting a different filesystem, often
> empty, so no other applications can access the under-mounted files.


  Thanks. Makes sense theoretically. Any eg of real practical 
application ? Any product in the market using it that way ?


  looks btrfs-progs shouldn't depend on the mnt-point driven ioctls
  to manage the FS. Now that's a set of challenges.


Thanks, Anand

