Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44438 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab3A1PKk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 10:10:40 -0500
Date: Mon, 28 Jan 2013 10:10:37 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Andrew McNabb <amcnabb@mcnabbs.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs stability
Message-ID: <20130128151037.GD3257@localhost.localdomain>
References: <20130125200514.GD4217@mcnabbs.org>
 <20130125205322.GB3257@localhost.localdomain>
 <20130125213950.GF4217@mcnabbs.org>
 <20130126202711.GB30537@mcnabbs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130126202711.GB30537@mcnabbs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 26, 2013 at 01:27:11PM -0700, Andrew McNabb wrote:
> Here's an update.  I tried the new kernel, and I seem to be having some
> new (possibly worse problems.  In my ssh session, I'm seeing many errors
> of this sort:
> 
> Message from syslogd@guru at Jan 26 13:13:14 ...
>  kernel:[  308.223834] BUG: soft lockup - CPU#0 stuck for 23s!
>  [btrfs-endio-wri:2073]
> 
> Message from syslogd@guru at Jan 26 13:13:14 ...
>  kernel:[  308.248754] BUG: soft lockup - CPU#2 stuck for 23s!
>  [btrfs-delalloc-:594]
> 
> In the logs, I'm seeing several warnings and bugs, including:
> 
> WARNING: at fs/btrfs/extent_map.c:78 free_extent_map+0x79/0x90 [btrfs]()
> WARNING: at lib/list_debug.c:62 __list_del_entry+0x82/0xd0()
> BUG: unable to handle kernel NULL pointer dereference at     (null)
> BUG: soft lockup - CPU#0 stuck for 22s! [btrfs-endio-wri:1489]
> BUG: soft lockup - CPU#1 stuck for 22s! [btrfs-delalloc-:607]
> 
> Kernel logs (across a few reboots) are at:
> 
> http://students.cs.byu.edu/~amcnabb/messages2
> 

Ok I think I figured it out, can you give this a whirl?  Let me know when you
get testers fatigue ;)

http://koji.fedoraproject.org/koji/taskinfo?taskID=4908932

Thanks,

Josef
