Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60394 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750775AbaJOVMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 17:12:34 -0400
Date: Wed, 15 Oct 2014 17:11:55 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Revert "Btrfs: race free update of commit root for ro
 snapshots"
To: Filipe Manana <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <stable@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Message-ID: <1413407515.18175.0@mail.thefacebook.com>
In-Reply-To: <1413398246-17324-1-git-send-email-fdmanana@suse.com>
References: <1413398246-17324-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, Oct 15, 2014 at 2:37 PM, Filipe Manana <fdmanana@gmail.com> 
wrote:
> This reverts commit 9c3b306e1c9e6be4be09e99a8fe2227d1005effc.
> 
> Switching only one commit root during a transaction is wrong because 
> it leads
> the fs into an inconsistent state. All commit roots should be 
> switched at once,
> at transaction commit time, otherwise backref walking can often miss 
> important
> references that were only accessible through the old commit root.
> Plus, the root item for the snapshot's root wasn't getting updated 
> and preventing
> the next transaction commit to do it.
> 
> This made several users get into random corruption issues after 
> creation of
> readonly snapshots.

Thanks Filipe and everyone else that helped nail this down.  I 
convinced myself that working on readonly roots made the original 
commit ok, but clearly I was horribly wrong.  Sorry guys, I'll get this 
off to Linus as soon as I do a quick cook here.

-chris


