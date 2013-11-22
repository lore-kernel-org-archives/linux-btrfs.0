Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55116 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3KVJD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 04:03:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjmeX-0002ab-Qs
	for linux-btrfs@vger.kernel.org; Fri, 22 Nov 2013 10:03:53 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 10:03:53 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 10:03:53 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Fri, 22 Nov 2013 09:03:41 +0000
Message-ID: <l6n6l2$ln6$1@ger.gmane.org>
References: <20131108220135.3802.39092@localhost.localdomain> <l5jtgo$6q1$1@ger.gmane.org> <20131121233751.5312.13383@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20131121233751.5312.13383@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/11/13 23:37, Chris Mason wrote:
> Quoting Martin (2013-11-08 18:53:06)
>> On 08/11/13 22:01, Chris Mason wrote:
>>> Hi everyone,
>>>
>>> This patch is now the tip of the master branch for btrfs-progs, which
>>> has been updated to include most of the backlogged progs patches.
>>> Please take a look and give it a shake.  This was based on Dave's
>>> integration tree (many thanks Dave!) minus the patches for online dedup.
>>> I've pulled in the coverity fixes and a few others from the list as
>>> well.
>>>
>>> The patch below switches our default mkfs leafsize up to 16K.  This
>>> should be a better choice in almost every workload, but now is your
>>> chance to complain if it causes trouble.
>>
>> Thanks for that and nicely timely!
>>
>> Compiling on Gentoo (3.11.5-gentoo, sys-fs/btrfs-progs-9999) gives:
>>
>>
>>  * QA Notice: Package triggers severe warnings which indicate that it
>>  *            may exhibit random runtime failures.
>>  * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
>> strict-aliasing rules [-Wstrict-aliasing]
>>  * volumes.c:1930:5: warning: dereferencing type-punned pointer will
>> break strict-aliasing rules [-Wstrict-aliasing]
>>  * volumes.c:1931:6: warning: dereferencing type-punned pointer will
>> break strict-aliasing rules [-Wstrict-aliasing]
> 
> I'm not seeing these warnings with the current master branch, could you
> please rerun?

>From just now:


 * QA Notice: Package triggers severe warnings which indicate that it
 *            may exhibit random runtime failures.
 * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
strict-aliasing rules [-Wstrict-aliasing]
 * volumes.c:1930:5: warning: dereferencing type-punned pointer will
break strict-aliasing rules [-Wstrict-aliasing]
 * volumes.c:1931:6: warning: dereferencing type-punned pointer will
break strict-aliasing rules [-Wstrict-aliasing]

 * Please do not file a Gentoo bug and instead report the above QA
 * issues directly to the upstream developers of this software.
 * Homepage: https://btrfs.wiki.kernel.org

>>> Installing (1 of 1) sys-fs/btrfs-progs-9999


... Which is exactly the same.

This is for Gentoo for:

gcc: x86_64-pc-linux-gnu-4.7.3

# gcc --version
gcc (Gentoo 4.7.3-r1 p1.3, pie-0.5.5) 4.7.3

Kernel: 3.11.9-gentoo

# btrfs version
Btrfs v0.20-rc1-597-g5aff090



And the "-9999" pulls the code in from:

>From git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs
   9f0c53f..5aff090  master     -> master
GIT update -->
   repository:
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
   updating from commit:     9f0c53f574b242b0d5988db2972c8aac77ef35a9
   to commit:                5aff090a3951e7d787b32bb5c49adfec65091385
 cmds-filesystem.c | 79
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs.c            | 18 +++++++++---------
 2 files changed, 88 insertions(+), 9 deletions(-)
   branch:                   master
   storage directory:
"/usr/portage/distfiles/egit-src/btrfs-progs.git"
   checkout type:            bare repository
Cloning into
'/var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999'...
done.
Checking connectivity... done
Branch branch-master set up to track remote branch master from origin.
Switched to a new branch 'branch-master'


Hope that helps,

Regards,
Martin





