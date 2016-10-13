Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20873 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751993AbcJMH0j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 03:26:39 -0400
Subject: Re: Btrfs progs build fails for 4.8
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Abhay Sachan <lkp.abhay@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
 <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
 <20161012172657.GV11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <eabfbf45-6cca-043d-b60b-34bede02dfc7@cn.fujitsu.com>
Date: Thu, 13 Oct 2016 15:25:57 +0800
MIME-Version: 1.0
In-Reply-To: <20161012172657.GV11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/13/2016 01:26 AM, David Sterba wrote:
> On Wed, Oct 12, 2016 at 10:01:27PM +0800, Qu Wenruo wrote:
>>
>>
>> On 10/12/2016 09:58 PM, Abhay Sachan wrote:
>>> Hi,
>>> I tried building latest btrfs progs on CentOS 6, "./configure" failed
>>> with the error:
>>>
>>> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
>>> configure: error: no definition of FIEMAP_EXTENT_SHARED found
>>>
>>> Any ideas what am I lacking in the system?
>>
>> Your kernel is too old and its header doesn't support
>> FIEMAP_EXTENT_SHARED flag for fiemap ioctl.
>
> As this is not the first time, I wonder if we could provide a defintion
> of the macro in progs, regardless of the installed headers. Note that
> this does not mean the running kernel is old. Previously the user said
> he was running a 4.4 kernel [1] (or it could be any other kernel
> version). For that combination of headers and running kernel, I think
> it's ok to add a fallback definition.

Yes, fallback definition is good for case like running kernel supports 
SHARED_EXTENT flag, but not kernel header.

But I'm a little concerned about such fallback definition will lead to 
corrupted result for "fi du".

>
>> And since that flag is very important for tools like "btrfs filesystem
>> du", for old kernel doesn't support EXTENT_SHARED flag, we have no
>> choice but abort configuration.
>
> The check was added to configure so it's caught earlier than during
> build. The 'fi du' command is useful, but not IMO critical to stop the
> build.

What about just disabling subcommands using SHARED_EXTENT flag?
Like "fi du".

Thanks,
Qu

>
> [1] http://lkml.kernel.org/r/2f451ba15f1d3dc508ab5439cf4dc8b4@crc.id.au
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


