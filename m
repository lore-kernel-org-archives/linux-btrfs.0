Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:35184 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAWIU1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 03:20:27 -0500
Message-ID: <52E0D0C8.3090502@giantdisaster.de>
Date: Thu, 23 Jan 2014 09:20:24 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: enclose uuid tree compat code with ifdefs
References: <1390319767-11201-1-git-send-email-dsterba@suse.cz> <52E0C7ED.3000709@cn.fujitsu.com>
In-Reply-To: <52E0C7ED.3000709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23 Jan 2014 15:42:37 +0800, Wang Shilong wrote:
> Hi David,
> 
> On 01/21/2014 11:56 PM, David Sterba wrote:
>> Commit "Btrfs-progs: make send/receive compatible with older kernels"
>> adds code that will become deprecated, let's clearly mark it in the
>> sources.
>>
>> CC: Stefan Behrens <sbehrens@giantdisaster.de>
>> CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Signed-off-by: David Sterba <dsterba@suse.cz>
>> ---
>>   send-utils.c |   28 ++++++++++++++++++++++++++++
>>   send-utils.h |   10 ++++++++++
>>   2 files changed, 38 insertions(+), 0 deletions(-)
>>
>> diff --git a/send-utils.c b/send-utils.c
[...]
>> +#else
>> +void subvol_uuid_search_add(struct subvol_uuid_search *s,
>> +                struct subvol_info *si)
>> +{
>> +    if (si) {
>> +        free(si->path);
>> +        free(si);
>> +    }
>> +}
>> +#endif
> I noticed subvol_uuid_search_add() function before, anyway
> it is not called anywhere before, aslo IMO it is a little strange that
> we free
> memory here.

The old code calls subvol_uuid_search_add() when btrfs receive finishes
receiving a snapshot. This is required when you receive an incremental
stream which includes multiple snapshots, and each snapshot is
incremental to the previous one in the stream. If the uuid-tree is not
available and the old code is used, subvol_uuid_search_add() needs to be
called in finish_subvol().

The free()s in subvol_uuid_search_add() in the new code are correct. And
that this function is not called in the new code is correct as well. It
is only there since it is part of the exported functions of the
"btrfs-lib". And since the old code used subvol_uuid_search_add()
instead of free(), to add the pointers to the database, which does not
exist anymore in the new code, now it's just a free() of the memory, to
prevent a memory leak in existing applications that use the "btrfs-lib".


