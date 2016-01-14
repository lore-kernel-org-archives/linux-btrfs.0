Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:58939 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbcANAJh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 19:09:37 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A298EAC01F3
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 09:09:32 +0900 (JST)
Subject: Re: [PATCH V2] Btrfs: fix output of compression message in
 btrfs_parse_options()
To: dsterba@suse.cz
References: <201601060803.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160113123343.GP4227@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <5696E72A.9080904@jp.fujitsu.com>
Date: Thu, 14 Jan 2016 09:09:14 +0900
MIME-Version: 1.0
In-Reply-To: <20160113123343.GP4227@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/01/13 21:33, David Sterba wrote:
> On Wed, Jan 06, 2016 at 05:03:40PM +0900, Tsutomu Itoh wrote:
>>   			} else if (strncmp(args[0].from, "no", 2) == 0) {
>>   				compress_type = "no";
>>   				btrfs_clear_opt(info->mount_opt, COMPRESS);
>>   				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
>>   				compress_force = false;
>> +				no_compress++;
>>   			} else {
> ...
>> +			if ((btrfs_test_opt(root, COMPRESS) &&
>> +			     (info->compress_type != saved_compress_type ||
>> +			      compress_force != saved_compress_force)) ||
>> +			    (!btrfs_test_opt(root, COMPRESS) &&
>> +			     no_compress == 1)) {
>
> If there are more than one 'compress=no' then the message won't be
> printed. I don't see a reason for doing no_compress++ above.

I want to output message as follows. Therefore, no_compress++ is necessary.

# mount -o compress,compress,compress=no,compress=no,compress,compress=no <dev> <path>

[  162.048033] BTRFS: device fsid a7f6e96e-653e-42d0-8469-13025396caa2 devid 1 transid 3 <dev>
[  185.349034] BTRFS info (device <dev>): use zlib compression
[  185.349041] BTRFS info (device <dev>): use no compression
[  185.349045] BTRFS info (device <dev>): use zlib compression
[  185.349048] BTRFS info (device <dev>): use no compression
[  185.349050] BTRFS info (device <dev>): disk space caching is enabled

Thanks,
Tsutomu

>
>> +				btrfs_info(root->fs_info,
>> +					   "%s %s compression",
>> +					   (compress_force) ? "force" : "use",
>> +					   compress_type);
>> +			}
>> +			compress_force = false;
>>   			break;
>>   		case Opt_ssd:
>>   			btrfs_set_and_info(root, SSD,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

