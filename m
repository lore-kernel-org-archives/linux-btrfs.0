Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34422 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3BYU7O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 15:59:14 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so3989530wib.7
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 12:59:13 -0800 (PST)
Message-ID: <512BD0EC.8040707@gmail.com>
Date: Mon, 25 Feb 2013 22:00:28 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: kreijack@inwind.it, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings allocation/deallocation.
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com> <1361627171-8246-2-git-send-email-goffredo.baroncelli@yahoo.com> <512ACA84.3010408@redhat.com> <512BC2B2.2010108@tiscalinet.it> <20130225201950.GC1658@lenny.home.zabbo.net>
In-Reply-To: <20130225201950.GC1658@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2013 09:19 PM, Zach Brown wrote:
>>    printf("Disk size:\t\t%*s\n", width,
>>         df_pretty_sizes(total_disk, mode));
>>
>> it would be translated (note the '%*s'):
>>
>>    if (mode == DF_HUMAN_UNIT)
>> 	   printf("Disk size:\t\t%*s%s\n", width-2,
>>         	df_pretty_sizes_number(total_disk),
>> 		df_pretty_sizes_unit(total_disk));
>>    else
>> 	   printf("Disk size:\t\t%*lld\n", width, total_disk);
> 
> So use mode as the argument in the second case, just like you did in the
> first.
> 
> printf("Disk dize:\t\t"sz_fmt"\n", sz_arg(total_disk, mode, width));

> 
> #define sz_fmt "%*llu%s"
> #define sz_fmt(v,m,w) width(w, m), scaled(v, m), units(v, m)
I suppose s/sz_fmt/sz_arg/

> And again, the reason we jump through these mildly distasteful hoops is
> that *it gets rid of allocated strings entirely*.
I am not entirely convinced, however if you prepare a patch I will
integrate it quickly

> That bug in df_pretty_sizes() where it allocates a 20 byte buffer to
> store a string that can be 21 bytes long with its null?  It'd just
> vanish.  Not needed.
Good catch

>> To avoid all this mess, we should add another conversion specifier with
>> the function register_printf_function(). Unfortunately I was not able to
>> find the equivalent one for sprintf().
> 
> Doesn't that prevent compile-time verification that the types of the
> format specifiers match the arguments?

Yes this was another cons...

> 
> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
