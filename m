Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23304 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753074AbcGKLaN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 07:30:13 -0400
Subject: Re: [PATCH 2/2] btrfs: fix free space calculation in
 dump_space_info()
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160629051216.16876-1-wangxg.fnst@cn.fujitsu.com>
 <20160704171025.GL13336@twin.jikos.cz> <577CDA66.1050309@cn.fujitsu.com>
 <20160708142832.GJ13336@twin.jikos.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <578382B0.3000702@cn.fujitsu.com>
Date: Mon, 11 Jul 2016 19:27:44 +0800
MIME-Version: 1.0
In-Reply-To: <20160708142832.GJ13336@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/08/2016 10:28 PM, David Sterba wrote:
> On Wed, Jul 06, 2016 at 06:16:06PM +0800, Wang Xiaoguang wrote:
>> hello,
>>
>> On 07/05/2016 01:10 AM, David Sterba wrote:
>>> On Wed, Jun 29, 2016 at 01:12:16PM +0800, Wang Xiaoguang wrote:
>>>
>>> Can you please describe in more detail what is this patch fixing?
>> In original dump_space_info(), free space info is calculated by
>> info->total_bytes - info->bytes_used - info->bytes_pinned -
>> info->bytes_reserved - info->bytes_readonly,
>> but I think free space info should also minus info->bytes_may_use :)
> Not really what I expected. The change is correct but the changelog
> should say something "the 'used space' formula is missing the
> bytes_may_used, that is used elsewhere eg. __reserve_metadata_bytes or
> space_info_add_old_bytes". That way I have something to verify during
> the review.
Sorry, later I'll try to make my patches more cleaner, thanks.

Regards,
Xiaoguang Wang

>
>



