Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50219 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbaKMSBY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 13:01:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xoyhu-0000go-PF
	for linux-btrfs@vger.kernel.org; Thu, 13 Nov 2014 19:01:22 +0100
Received: from pd953ede5.dip0.t-ipconnect.de ([217.83.237.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 19:01:22 +0100
Received: from holger.hoffstaette by pd953ede5.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 19:01:22 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: don't ignore log btree writeback errors
Date: Thu, 13 Nov 2014 18:01:07 +0000 (UTC)
Message-ID: <pan.2014.11.13.18.01.07@googlemail.com>
References: <1415897993-7556-1-git-send-email-fdmanana@suse.com>
	<pan.2014.11.13.17.33.19@googlemail.com>
	<pan.2014.11.13.17.43.12@googlemail.com>
	<CAL3q7H60L=5-w4377ddhrpbN3yDXAX_e9iCrtWPTxHHsus-OYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 13 Nov 2014 17:50:44 +0000, Filipe David Manana wrote:

[snip]

>>> This first hunk didn't apply to my 3.14.x tree that is 99.999% in sync with
>>> btrfs-3.18+, as a line is missing from the context. See:
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/tree/fs/btrfs/tree-log.c?h=for-linus#n2605
>>>
>>> Any idea where that missing btrfs_free_logged_extents() went?
>>
>> Found it: it went away with Josef's recent patch on Nov 6:
>> "Btrfs: make sure we wait on logged extents when fsycning two subvols"
>> (http://permalink.gmane.org/gmane.comp.file-systems.btrfs/40005)
>>
>> ..which I have applied. boohoo.
>>
>> That patch also adds another call to btrfs_wait_marked_extents(), which should
>> then probably also have its return value handled?
> 
> No, it's a different call - btrfs_wait_logged_extents().

Of course, you are right. I can't read (it's late :)

cheers
-h

