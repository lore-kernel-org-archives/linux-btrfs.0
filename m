Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38416 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbeC0UlP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 16:41:15 -0400
Subject: Re: [PATCH 2/8] btrfs: return required error from
 btrfs_check_super_csum
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-3-anand.jain@oracle.com>
 <4203fb44-3fd4-1e26-bf03-40d640de09af@suse.com>
 <20180327191636.GE30422@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ac89e7e0-dd67-d606-859d-dd784157e453@oracle.com>
Date: Wed, 28 Mar 2018 04:43:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180327191636.GE30422@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/28/2018 03:16 AM, David Sterba wrote:
> On Tue, Mar 27, 2018 at 11:05:53AM +0300, Nikolay Borisov wrote:
>>> +	if (err) {
>>> +		if (err == -EINVAL)
>>> +			pr_err("BTRFS error (device %pg): "\
>>> +				"unsupported checksum algorithm",
>>> +				fs_devices->latest_bdev);
>>
>> I don't think strings should be idented. I.e the correct thing here
>> should be to have only fs_devices->latest_bdev on a new line, even if
>> the string goes above the char limit of 80. In any case the \ is not
>> needed due to gcc's support for string literal concatenation:
>>
>> pr_err("BTRFS error (device %pg): "
>>         "unsupported checksum algorithm",
>>         fs_devices->latest_bdev)
>>
>> should work equally well. But as I said I don't think this is even
>> needed. Let's wait and see what David says.
> 
> The strings should not be split, because we want to be able to grep the
> sources for the error messages. If the string does not fit 80 chars
> per line, then it can be moved to the next line and un-indented to the
> left. Plenty of examples.

  I understand reason behind string should not be split, but I
  thought here will be an exception, as if you want to search
  for the string you will still use "unsupported checksum algorithm"
  which is still in one line.
  About the grep not able to find the string which are split,
  I look at it as fixing the wrong end of the problem. That is Grep
  end problem being fixes at the c code end. Anyway as its kind of
  linux general guidlines, I shall fix my patch.

Thanks, Anand
