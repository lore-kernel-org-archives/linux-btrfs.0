Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab3CUVmV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 17:42:21 -0400
Message-ID: <514B7EBA.7000205@redhat.com>
Date: Thu, 21 Mar 2013 16:42:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Joseph Moore <japlha@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Problems with compiling btrfs
References: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
In-Reply-To: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/21/13 4:11 PM, Joseph Moore wrote:
> I'm trying to compile the btrfs source code but I'm getting an error.
> Any suggestions?

Older libblkid doesn't have that function.

This is where a configure script would really help :(

Locally I currently am keeping a patch around to just remove it;
you could comment out the call to is_ssd() and put a giant #if 0
around the function itself, for now, to get things going.

I keep threatening to add a -DHAVE_BLAHBLAH kind of switch
to the Makefile but that seems a little ick.  Better than
nothing I guess.

-Eric

> Thanks
> Joe
> 
> [root@ol6 btrfs-progs]# uname -a
> Linux ol6.localdomain 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13
> 12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux
> 
> [root@ol6 src]# git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> Initialized empty Git repository in /usr/local/src/btrfs-progs/.git/
> remote: Counting objects: 3539, done.
> remote: Compressing objects: 100% (1289/1289), done.
> remote: Total 3539 (delta 2633), reused 3015 (delta 2246)
> Receiving objects: 100% (3539/3539), 1.02 MiB | 613 KiB/s, done.
> Resolving deltas: 100% (2633/2633), done.
> 
> [root@ol6 src]# cd btrfs-progs
> [root@ol6 btrfs-progs]# pwd
> /usr/local/src/btrfs-progs
> 
> [root@ol6 btrfs-progs]# make
>     [LD]     mkfs.btrfs
> mkfs.o: In function `is_ssd':
> /usr/local/src/btrfs-progs/mkfs.c:1234: undefined reference to
> `blkid_probe_get_wholedisk_devno'
> collect2: ld returned 1 exit status
> make: *** [mkfs.btrfs] Error 1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

