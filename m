Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32366 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754676AbcFAD0H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 23:26:07 -0400
Subject: Re: [PATCH] btrfs-progs: make btrfs-image restore to support dup
To: <dsterba@suse.cz>
References: <1464255780-14429-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160530164518.GE29147@twin.jikos.cz>
 <691c5c1d-4d11-c1c9-956d-bc5b8d553236@cn.fujitsu.com>
 <20160531160108.GH29147@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: luke <lufq.fnst@cn.fujitsu.com>
Message-ID: <1857cd49-a5f2-a338-47a0-ce5a54ab5f8c@cn.fujitsu.com>
Date: Wed, 1 Jun 2016 11:25:57 +0800
MIME-Version: 1.0
In-Reply-To: <20160531160108.GH29147@suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/01/2016 12:01 AM, David Sterba wrote:
> On Tue, May 31, 2016 at 03:14:25PM +0800, luke wrote:
>>>> @@ -68,6 +68,12 @@ struct meta_cluster {
>>>>    struct fs_chunk {
>>>>    	u64 logical;
>>>>    	u64 physical;
>>>> +	/* physical_dup only store additonal physical for BTRFS_BLOCK_GROUP_DUP
>>>> +	 * currently restore only support single and dup
>>>> +	 * TODO: modify this structure and the function related to this
>>>> +	 * structure for support raid*
>>> What does it do in case of RAID? Can we do runtime checks and report
>>> potential problems? btrfs-image on multiple device was always somehow
>>> tricky so I'll merge the patch.
>> For multiple device,  if the number of  target devices equal to the
>> number of source devices, obviously we can offer the enough disk size
>> and keep the original offset. However, if restore the multi-device
>> metadata to one disk, we should remap all chunk and use other profile to
>> instead of raid*(for example, raid0 -> single, raid1 -> dup). Currently
>> I have only a rough idea, it may need to refactor a lot of function.
>> We can report some warnings when we find raid* profile in the restore
>> process. Should I add these warnings?
> Yes please, that's what I was asking for. If you're going to do
> intrusive refactorin, please add tests.
>
>
OK. When I started to refactor, I'll add these.

Thanks,
Lu


