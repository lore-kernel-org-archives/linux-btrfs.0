Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:62959 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbcAOAPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 19:15:15 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 2E4FFAC0ADA
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 09:15:08 +0900 (JST)
Subject: Re: [PATCH V2] Btrfs: fix output of compression message in
 btrfs_parse_options()
To: dsterba@suse.cz
References: <201601060803.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160113123343.GP4227@twin.jikos.cz> <5696E72A.9080904@jp.fujitsu.com>
 <20160114142043.GX4227@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <569839F9.20405@jp.fujitsu.com>
Date: Fri, 15 Jan 2016 09:14:49 +0900
MIME-Version: 1.0
In-Reply-To: <20160114142043.GX4227@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/01/14 23:20, David Sterba wrote:
> On Thu, Jan 14, 2016 at 09:09:14AM +0900, Tsutomu Itoh wrote:
>> On 2016/01/13 21:33, David Sterba wrote:
>>> On Wed, Jan 06, 2016 at 05:03:40PM +0900, Tsutomu Itoh wrote:
>>>>    			} else if (strncmp(args[0].from, "no", 2) == 0) {
>>>>    				compress_type = "no";
>>>>    				btrfs_clear_opt(info->mount_opt, COMPRESS);
>>>>    				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
>>>>    				compress_force = false;
>>>> +				no_compress++;
>>>>    			} else {
>>> ...
>>>> +			if ((btrfs_test_opt(root, COMPRESS) &&
>>>> +			     (info->compress_type != saved_compress_type ||
>>>> +			      compress_force != saved_compress_force)) ||
>>>> +			    (!btrfs_test_opt(root, COMPRESS) &&
>>>> +			     no_compress == 1)) {
>>>
>>> If there are more than one 'compress=no' then the message won't be
>>> printed. I don't see a reason for doing no_compress++ above.
>>
>> I want to output message as follows. Therefore, no_compress++ is necessary.
>>
>> # mount -o compress,compress,compress=no,compress=no,compress,compress=no <dev> <path>
>>
>> [  162.048033] BTRFS: device fsid a7f6e96e-653e-42d0-8469-13025396caa2 devid 1 transid 3 <dev>
>> [  185.349034] BTRFS info (device <dev>): use zlib compression
>> [  185.349041] BTRFS info (device <dev>): use no compression
>> [  185.349045] BTRFS info (device <dev>): use zlib compression
>> [  185.349048] BTRFS info (device <dev>): use no compression
>> [  185.349050] BTRFS info (device <dev>): disk space caching is enabled
>
> I don't think it's necessary ty print all the options. Only the last one
> is applied so I'd expect to see only "... use no compression".

I see.
However, the output of other options are also the same as the above-mentioned.

e.g.
# mount -o discard,nodiscard,discard <dev> <path>

[56714.781948] BTRFS: device fsid 22f3af7e-0f1c-40fe-8eb1-091df7bd1da2 devid 1 transid 3 <dev>
[56736.296779] BTRFS info (device <dev>): turning on discard
[56736.296785] BTRFS info (device <dev>): turning off discard
[56736.296789] BTRFS info (device <dev>): turning on discard
[56736.296792] BTRFS info (device <dev>): disk space caching is enabled

Thanks,
Tsutomu

