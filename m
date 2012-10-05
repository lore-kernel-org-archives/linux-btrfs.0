Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56989 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab2JEQ77 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 12:59:59 -0400
Message-ID: <506F11F1.5010803@jp.fujitsu.com>
Date: Sat, 06 Oct 2012 01:59:29 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: dave@jikos.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix error processing in btrfs_set_acl()
References: <201210050935.AA00014@FM-323941448.jp.fujitsu.com> <20121005100255.GC14582@twin.jikos.cz>
In-Reply-To: <20121005100255.GC14582@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/10/05 19:02), David Sterba wrote:
> Hi,
>
> On Fri, Oct 05, 2012 at 06:35:07PM +0900, Tsutomu Itoh wrote:
>> The error is only returned when kmalloc() fails.
>> Therefore, to return the error to the caller directly here, I changed the code.
>
>    "fix error processing in btrfs_set_acl()"
>
> what bug does it 'fix' ? IMHO this is a minor cleanup that is not much

Yes, this is a "cleanup". sorry.

- Tsutomu

> needed. The return path after 'posix_acl_to_xattr' uses the if/goto
> pattern in the same if (acl) { ... } block, visually this does not help
> the original code is correct and "looks ok".
>
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -136,10 +136,8 @@ static int btrfs_set_acl(struct btrfs_trans_handle *trans,
>>   	if (acl) {
>>   		size = posix_acl_xattr_size(acl->a_count);
>>   		value = kmalloc(size, GFP_NOFS);
>> -		if (!value) {
>> -			ret = -ENOMEM;
>> -			goto out;
>> -		}
>> +		if (!value)
>> +			return -ENOMEM;
>>
>>   		ret = posix_acl_to_xattr(acl, value, size);
>>   		if (ret < 0)
>
>
> david


