Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5388 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933064AbbCRN6N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 09:58:13 -0400
Message-ID: <55098447.3030300@fb.com>
Date: Wed, 18 Mar 2015 09:57:27 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] Btrfs: just free dummy extent buffers
References: <1426624683-3085-1-git-send-email-jbacik@fb.com> <1426624683-3085-3-git-send-email-jbacik@fb.com> <20150318135600.GB20767@twin.jikos.cz>
In-Reply-To: <20150318135600.GB20767@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/18/2015 09:56 AM, David Sterba wrote:
> On Tue, Mar 17, 2015 at 04:38:01PM -0400, Josef Bacik wrote:
>> If we fail during our sanity tests we could get NULL deref's because we unload
>> the module before the dummy extent buffers are free'd via RCU.  So check for
>> this case and just free the things directly.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>   fs/btrfs/extent_io.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 29850d4..d13cead 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4968,6 +4968,12 @@ static int release_extent_buffer(struct extent_buffer *eb)
>>
>>   		/* Should be safe to release our pages at this point */
>>   		btrfs_release_extent_buffer_page(eb);
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>
> Please use btrfs_test_is_dummy_root, it's there to avoid the #ifdefs

Don't have a root here.  Thanks,

Josef
