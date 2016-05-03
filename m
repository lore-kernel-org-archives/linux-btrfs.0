Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54516 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933639AbcECBAB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 21:00:01 -0400
Subject: Re: [PATCH] btrfs-progs: Restrict e2fsprogs version for new convert
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160415111726.GD28775@twin.jikos.cz> <57143652.20206@cn.fujitsu.com>
 <20160425145532.GA29353@twin.jikos.cz> <20160502123321.GH29353@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0c6be9c0-c2ef-9356-a100-3f457be5648b@cn.fujitsu.com>
Date: Tue, 3 May 2016 08:59:58 +0800
MIME-Version: 1.0
In-Reply-To: <20160502123321.GH29353@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/02 14:33 +0200:
> On Mon, Apr 25, 2016 at 04:55:32PM +0200, David Sterba wrote:
>> On Mon, Apr 18, 2016 at 09:20:18AM +0800, Qu Wenruo wrote:
>>>
>>>
>>> David Sterba wrote on 2016/04/15 13:17 +0200:
>>>> On Thu, Apr 14, 2016 at 02:24:34PM +0800, Qu Wenruo wrote:
>>>>> New btrfs-convert is using a lot of new macro in e2fsprogs 1.42.
>>>>> Unfortunately the new compatible layer for older e2fsprogs is still
>>>>> under development.
>>>>
>>>> It hasn't been released yet so it's not really a big problem, although
>>>> it makes testing on my side a bit harder. The configure-time check
>>>> should be 1.41 and until it's fixed we can print a warning.
>>>>
>>>>
>>> Did I missed something?
>>>
>>> I checkout 1.41.14 and it shows no cluster support in ext2fs.h.
>>>
>>> Also git describe shows it's v1.41.14-36-g1da5ef7, after the last v1.41
>>> version.
>>>
>>> So I think the check should be 1.42, just as the patch.
>>
>> The idea is to keep lowest supported version 1.41, because this version
>> can be commonly found on enterprise distros. The lack of cluster is
>> expected and needs to be dealt with both build- and run-time.
>
> I've committed the following patch, as it was your idea to add the
> version check:

I'm fine to 1.41 for now, but I'm afraid that the compatible layer won't 
be any time soon.
So it may still broke 1.41 e2fsprogs.

(My fault, I still didn't quite know how e2fsprogs are handling the new 
RO compact feature)

Thanks,
Qu

>
> btrfs-progs: Restrict e2fsprogs version for convert
>
> We want to support version 1.41 due to longterm and enterprise distros,
> make the check explicit.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
>
> diff --git a/configure.ac b/configure.ac
> index fc343ea1aa5d..797eb7903520 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -105,7 +105,7 @@ AS_IF([test "x$enable_convert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFS
>  AC_SUBST([DISABLE_BTRFSCONVERT])
>
>  if test "x$enable_convert" = xyes; then
> -       PKG_CHECK_MODULES(EXT2FS, [ext2fs])
> +       PKG_CHECK_MODULES(EXT2FS, [ext2fs >= 1.41])
>         PKG_CHECK_MODULES(COM_ERR, [com_err])
>  fi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


