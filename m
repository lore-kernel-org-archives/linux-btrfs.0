Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:54378 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965934AbaLMIQl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 03:16:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 13 Dec 2014 09:16:37 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Robert White <rwhite@pobox.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
In-Reply-To: <548B7329.80208@pobox.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>
 <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
 <438e043f73392614d1453892b7fe225c@admin.virtall.com>
 <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
 <548B5FD6.5080306@pobox.com>
 <ce7dba343916e4262a92071af863d014@admin.virtall.com>
 <548B6D58.6080804@pobox.com>
 <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com>
 <548B7329.80208@pobox.com>
Message-ID: <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-12 23:58, Robert White wrote:

> I don't have the history to answer this definitively, but I don't
> think you have a choice. Nothing else is going to touch that error.
> 
> I have not seen any "oh my god, btrfsck just ate my filesystem errors"
> since I joined the list -- but I am a relative newcomer.
> 
> I know that you, of course, as a contentious and well-traveled system
> administrator, already have a current backup since you are doing
> storage maintenance... right? 8-)

Who needs backups with btrfs, right? :)

So apparently btrfsck --repair fixed some issues, the fs is still 
mountable and looks fine.

Running balance again, but that will take many days there.

# btrfsck --repair /dev/sdc1
fixing root item for root 8681, current bytenr 5568935395328, current 
gen 70315, current level 2, new bytenr 5569014104064, new gen 70316, new 
level 2
Fixed 1 roots.
checking extents
checking free space cache
checking fs roots
root 696 inode 2765103 errors 400, nbytes wrong
root 696 inode 2831256 errors 400, nbytes wrong
root 9466 inode 2831256 errors 400, nbytes wrong
root 9505 inode 2831256 errors 400, nbytes wrong
root 10139 inode 2831256 errors 400, nbytes wrong
root 10525 inode 2831256 errors 400, nbytes wrong
root 10561 inode 2831256 errors 400, nbytes wrong
root 10633 inode 2765103 errors 400, nbytes wrong
root 10633 inode 2831256 errors 400, nbytes wrong
root 10650 inode 2765103 errors 400, nbytes wrong
root 10650 inode 2831256 errors 400, nbytes wrong
root 10680 inode 2765103 errors 400, nbytes wrong
root 10680 inode 2831256 errors 400, nbytes wrong
root 10681 inode 2765103 errors 400, nbytes wrong
root 10681 inode 2831256 errors 400, nbytes wrong
root 10701 inode 2765103 errors 400, nbytes wrong
root 10701 inode 2831256 errors 400, nbytes wrong
root 10718 inode 2765103 errors 400, nbytes wrong
root 10718 inode 2831256 errors 400, nbytes wrong
root 10735 inode 2765103 errors 400, nbytes wrong
root 10735 inode 2831256 errors 400, nbytes wrong
enabling repair mode
Checking filesystem on /dev/sdc1
UUID: 371af1dc-d88b-4dee-90ba-91fec2bee6c3
cache and super generation don't match, space cache will be invalidated
found 942113871627 bytes used err is 1
total csum bytes: 2445349244
total tree bytes: 28743073792
total fs tree bytes: 22880043008
total extent tree bytes: 2890547200
btree space waste bytes: 5339534781
file data blocks allocated: 2779865800704
  referenced 3446026993664
Btrfs v3.17.3

real    76m27.845s
user    19m1.470s
sys     2m55.690s


-- 
Tomasz Chmielewski
http://www.sslrack.com

