Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([125.16.236.3]:50635 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbcAEDWa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 22:22:30 -0500
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 5 Jan 2016 08:52:27 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id BFC1EE0054
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jan 2016 08:53:36 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u053MNa710027232
	for <linux-btrfs@vger.kernel.org>; Tue, 5 Jan 2016 08:52:23 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u053MMKU026533
	for <linux-btrfs@vger.kernel.org>; Tue, 5 Jan 2016 08:52:23 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: james harvey <jamespharvey20@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@gmail.com,
        chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: Intialize btrfs_root->highest_objectid when loading tree root and subvolume roots
Date: Tue, 05 Jan 2016 08:52:22 +0530
Message-ID: <5978134.q4ybM9MPWz@localhost.localdomain>
In-Reply-To: <CA+X5Wn5EKaSwD1B1H9Sd+QRcKezOMmE6GaGMVjPFZRNAwhe4oA@mail.gmail.com>
References: <1444063465-5641-1-git-send-email-chandan@linux.vnet.ibm.com> <8703019.0plYdL21k7@localhost.localdomain> <CA+X5Wn5EKaSwD1B1H9Sd+QRcKezOMmE6GaGMVjPFZRNAwhe4oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 03 Jan 2016 00:02:18 james harvey wrote:
> Bump.
> 
> Pretty sure I just ran into this, outside of a testing scenario.  See
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/51796
> 
> Looks like the patch was never committed.
>

Thanks for pointing this out. I will rebase & test the patch on top of current
integration branch and post it again.

-- 
chandan

