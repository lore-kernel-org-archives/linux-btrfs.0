Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17330 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbaHSP2G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:28:06 -0400
Message-ID: <53F36CFF.3090001@fb.com>
Date: Tue, 19 Aug 2014 11:27:59 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>, Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix leak in qgroup_subtree_accounting() error
 path
References: <53F10BF1.6070602@redhat.com> <20140818214201.GC2203@wotan.suse.de>
In-Reply-To: <20140818214201.GC2203@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/18/2014 05:42 PM, Mark Fasheh wrote:
> On Sun, Aug 17, 2014 at 03:09:21PM -0500, Eric Sandeen wrote:
>> Coverity pointed this out; in the newly added
>> qgroup_subtree_accounting(), if btrfs_find_all_roots()
>> returns an error, we leak at least the parents pointer,
>> and possibly the roots pointer, depending on what failure
>> occurs.
>>
>> If btrfs_find_all_roots() returns an error, we need to
>> free up all allocations before we return.  "roots" is
>> initialized to NULL, so it should be safe to free
>> it unconditionally (ulist_free() handles that case).
> 
> Great, thanks for this Eric.
> 
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> 

Thanks guys, this is queued.

-chris

