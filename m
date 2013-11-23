Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34511 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab3KWADD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 19:03:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vk0gc-00009H-Ph
	for linux-btrfs@vger.kernel.org; Sat, 23 Nov 2013 01:02:58 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 01:02:58 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 01:02:58 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Sat, 23 Nov 2013 00:02:46 +0000
Message-ID: <l6oras$9ra$1@ger.gmane.org>
References: <20131108220135.3802.39092@localhost.localdomain> <l5jtgo$6q1$1@ger.gmane.org> <20131121233751.5312.13383@localhost.localdomain> <l6n6l2$ln6$1@ger.gmane.org> <20131122134038.5312.42200@localhost.localdomain> <l6oche$7sa$1@ger.gmane.org> <20131122195729.5312.20671@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20131122195729.5312.20671@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/11/13 19:57, Chris Mason wrote:
> Quoting Martin (2013-11-22 14:50:17)
>> On 22/11/13 13:40, Chris Mason wrote:
>>> Quoting Martin (2013-11-22 04:03:41)
>>
>>>>  * QA Notice: Package triggers severe warnings which indicate that it
>>>>  *            may exhibit random runtime failures.
>>>>  * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
>>>> strict-aliasing rules [-Wstrict-aliasing]
>>>>  * volumes.c:1930:5: warning: dereferencing type-punned pointer will
>>>> break strict-aliasing rules [-Wstrict-aliasing]
>>>>  * volumes.c:1931:6: warning: dereferencing type-punned pointer will
>>>> break strict-aliasing rules [-Wstrict-aliasing]
>>>
>>> Does gentoo modify the optimizations from the Makefile?  We actually
>>> have many strict-aliasing warnings, but I didn't think they came up
>>> until -O2.
>>
>> For that system, I have -Os set in the Gentoo "make.conf".
>>
>>
>>> At any rate, I'm adding -fno-strict-aliasing just to be sure.
>>
>> Good to catch to avoid unexpectedness,
> 
> Ok, please try with the current master to make sure the options are
> being picked up properly.  If you're overriding the
> -fno-strict-aliasing, please don't ;)

No changes my side for that system and...

btrfs-progs now compiles with no warnings given. That looks like a "fixed".


# emerge -vD btrfs-progs

These are the packages that would be merged, in order:

Calculating dependencies... done!
[ebuild   R   *] sys-fs/btrfs-progs-9999  0 kB

Total: 1 package (1 reinstall), Size of downloads: 0 kB


>>> Verifying ebuild manifests

>>> Emerging (1 of 1) sys-fs/btrfs-progs-9999
>>> Unpacking source...
GIT update -->
   repository:
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
   at the commit:            8116550e16628794b76051b6b8ea503055c08d6f
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

... And then a clean compile. No warnings.


Thanks,
Martin



