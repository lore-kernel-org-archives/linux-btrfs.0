Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbaAFBAw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:00:52 -0500
Message-ID: <52CA0077.4040308@cn.fujitsu.com>
Date: Mon, 06 Jan 2014 09:01:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] btrfs: Add missing pairing mount options.
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com> <20140103175828.GS6498@twin.jikos.cz>
In-Reply-To: <20140103175828.GS6498@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 3 Jan 2014 18:58:28 +0100, David Sterba wrote:
> On Fri, Jan 03, 2014 at 02:10:23PM +0800, Qu Wenruo wrote:
>> Some options should be paired to support triggering different functions
>> when remounting.
>> This patchset add these missing pairing mount options.
> Thanks!
>
>>    btrfs: Add nocheck_int mount option.
>>    btrfs: Add noinode_cache mount option.
> Commented separately, imho not to be merged in current state.
>
>>    btrfs: Add "barrier" option to support "-o remount,barrier"
>>    btrfs: Add noautodefrag mount option.
>>    btrfs: Add nodiscard mount option.
>>    btrfs: Add noenospc_debug mount option.
>>    btrfs: Add noflushoncommit mount option.
>>    btrfs: Add acl mount option.
>>    btrfs: Add datacow mount option.
>>    btrfs: Add datasum mount option.
>>    btrfs: Add treelog mount option.
> All ok.
>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Thanks for your commenting.
nocheck_int and noinode_cache will be remove in next version,
and noinode_cache will be resent as a independent patch after more
investigation and tests.

Also remounting test case will be added to xfstest soon.

Qu
