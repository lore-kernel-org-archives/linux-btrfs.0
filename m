Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45980 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3ESOmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 10:42:14 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, chris.mason@fusionio.com,
        Ilya Dryomov <idryomov@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Date: Sun, 19 May 2013 16:42:12 +0200
Message-ID: <5257426.BsHKpgdZ78@merkaba>
In-Reply-To: <CAEH94LjW-5azrjN+fz8YDMqT4jW3hjm3mLj7HVeuSKrXWS=MBQ@mail.gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com> <10727333.ycOo9UTNXM@merkaba> <CAEH94LjW-5azrjN+fz8YDMqT4jW3hjm3mLj7HVeuSKrXWS=MBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 19. Mai 2013, 21:43:14 schrieb Zhi Yong Wu:
> On Sun, May 19, 2013 at 6:41 PM, Martin Steigerwald <Martin@lichtvoll.de> 
wrote:
> > Am Donnerstag, 9. Mai 2013, 07:13:56 schrieb Zhi Yong Wu:
[…]
> > ZFS and BTRFS have shown that RAID support within the filesystem can make
> > a lot of sense. I think hot relocation is another area which can be done
> > more accurate within the filesystem. I think there are several features
> > only possible by going this route:
> > 
> > 1) Mark files as hot via ioctl. MySQL can mark InnoDB journal files for
> > example.
> It has been implemented to get its hot status of one specified file
> via ioctl. It is not hard to enable its set function. Before it is
> done, i more hope that the core of VFS hot tracking can get merged by
> kernel upstream. You know, it is harder if too new functions have been
> done.
> We can put it in to-do list at first, what do you think?

Yes, of course. I didn´t want to imply that you have to implement it. I didn´t 
contribute to BTRFS code yet, so I do not see myself in a position to request 
anything from you – and even if I did, what you code is still your decision. 
Many thanks for your work on this!

I just wanted to note that IMHO its possible with the VFS approach while its 
at least difficult to do with the block layer based approaches.

> > 2) Proper BTRFS RAID support (as noted elsewhere in this thread)
> > 
> > 3) Easier setup. With BTRFS flexibility I would expect that a SSD as hot
> > data cache can be added and removed on the fly during filesystem is
> > mounted. Only seems supported at mkfs-time as I read the patch docs, but
> > from my basic technical understanding of BTRFS it can be extented to be
> > done on the fly with a mounted FS as well.
> 
> Yes, it is supported only at mkfs time. It shouldn't be hard to enable
> adding or removing a nonrotating disk as hot cache on the fly. You
> know, before this is done, i would like to make sure that the current
> design for BTRFS hot relocation is this RFC patchset is going in the
> direction and is appropriate. If it is going in wrong direction, we
> will be doing a lot of meanless work. E.g. How about the current idea
> on introducing one new block group for nonrotating disks.
> When working on this work, i were trying to change the least current
> btrfs code as far as possible. You know, if we change too many current
> btrfs code, it will introduce regression bug more easily, and so the
> patchset will be also harder to get accepted by btrfs upstream.
> 
> What do you think?

Yes, see above. Keep it simple and extend later I´d say :)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
