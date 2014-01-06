Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6274 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbaAFA6E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 19:58:04 -0500
Message-ID: <52C9FFCE.9030203@cn.fujitsu.com>
Date: Mon, 06 Jan 2014 08:58:54 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] btrfs: Add missing pairing mount options.
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com> <52C6F8C7.9080902@redhat.com>
In-Reply-To: <52C6F8C7.9080902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 03 Jan 2014 11:52:07 -0600, Eric Sandeen wrote:
> On 1/3/14, 12:10 AM, Qu Wenruo wrote:
>> Some options should be paired to support triggering different functions
>> when remounting.
>>
>> This patchset add these missing pairing mount options.
> I think this really would benefit from a regression test which
> ensures that every remount transition works properly...
>
> Thanks,
> -Eric
Xfstests test case for the remounting test is under development and will
submit soon.(for both generic and btrfs mount options)

As far as I tested, no problem occurs in my test environment but since
the IO pressure is low, a more heavier test case is needed though.

Qu
>
>> changelog:
>> v1: Initial commit with only barrier option
>> v2: Add other missing pairing options
>>
>> Qu Wenruo (11):
>>    btrfs: Add "barrier" option to support "-o remount,barrier"
>>    btrfs: Add noautodefrag mount option.
>>    btrfs: Add nocheck_int mount option.
>>    btrfs: Add nodiscard mount option.
>>    btrfs: Add noenospc_debug mount option.
>>    btrfs: Add noflushoncommit mount option.
>>    btrfs: Add noinode_cache mount option.
>>    btrfs: Add acl mount option.
>>    btrfs: Add datacow mount option.
>>    btrfs: Add datasum mount option.
>>    btrfs: Add treelog mount option.
>>
>>   Documentation/filesystems/btrfs.txt | 56 ++++++++++++++++++----------
>>   fs/btrfs/super.c                    | 74 ++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 110 insertions(+), 20 deletions(-)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

