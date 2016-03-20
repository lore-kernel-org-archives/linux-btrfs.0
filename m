Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35770 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbcCTL4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 07:56:55 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        clm@fb.com, dsterba@suse.cz
Subject: Re: [RFC] Experimental btrfs encryption
Date: Sun, 20 Mar 2016 12:56:51 +0100
Message-ID: <6811740.h4sZIklf13@merkaba>
In-Reply-To: <56D63CB1.5070202@cn.fujitsu.com>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com> <56D63CB1.5070202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mittwoch, 2. März 2016 09:06:57 CET Qu Wenruo wrote:
> And maybe I just missed something, but the filename seems not touched, 
> meaning it will leak a lot of information.
> Just like default eCryptfs behavior.
> 
> I understand that's an easy design and it's not a high priority thing, 
> but I hope we can encrypt the subvolume tree blocks too, if using 
> per-subvolume policy.
> To provide a feature near block-level encryption.

I´d really love an approach to at least optionally be able to hide the 
metadata structure completely except for which blocks on the block device are 
allocated. I.e. not just encrypting filenames, but encrypting the directory 
structure, amount of files, their dates, their sizes. I am not sure whether 
BTRFS can allow this and still be at least btrfs check´able without unlocking 
the encryption key. Ideally this could even be backuped by an btrfs send/
receive as a kind opaque stream.

This would excel BTRFS encryption support over anything thats available with 
Ext4, F2FS, ecryptfs and encfs. It would ideal for having encryption on SSD, 
no need to encrypted unallocated blocks, but still most of the advantages of 
block level encryption, even of some would argue that you can find something 
out when you check which blocks are allocated or not, and of course the total 
size of the subvolume and which chunks it allocates are known.

I would the this as requirement for any initial approach and be happy about 
anything that does file name encryption like ecryptfs or the Ext4/F2FS 
approach, but if the subvolume specifics of BTRFS can be used to encrypted 
more of the metadata then even better!

Thanks,
-- 
Martin
