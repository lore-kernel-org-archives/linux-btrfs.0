Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752730AbcJNRA6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 13:00:58 -0400
Subject: Re: Btrfs progs build fails for 4.8
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Abhay Sachan <lkp.abhay@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
 <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
 <20161012172657.GV11398@twin.jikos.cz>
 <eabfbf45-6cca-043d-b60b-34bede02dfc7@cn.fujitsu.com>
 <20161014154942.GB11398@twin.jikos.cz>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <3caf7539-5eae-d085-1fc6-b48ce0ae99a2@redhat.com>
Date: Fri, 14 Oct 2016 12:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <20161014154942.GB11398@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/14/16 10:49 AM, David Sterba wrote:
> On Thu, Oct 13, 2016 at 03:25:57PM +0800, Qu Wenruo wrote:
>> At 10/13/2016 01:26 AM, David Sterba wrote:
>>> On Wed, Oct 12, 2016 at 10:01:27PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 10/12/2016 09:58 PM, Abhay Sachan wrote:
>>>>> Hi,
>>>>> I tried building latest btrfs progs on CentOS 6, "./configure" failed
>>>>> with the error:
>>>>>
>>>>> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
>>>>> configure: error: no definition of FIEMAP_EXTENT_SHARED found
>>>>>
>>>>> Any ideas what am I lacking in the system?
>>>>
>>>> Your kernel is too old and its header doesn't support
>>>> FIEMAP_EXTENT_SHARED flag for fiemap ioctl.
>>>
>>> As this is not the first time, I wonder if we could provide a defintion
>>> of the macro in progs, regardless of the installed headers. Note that
>>> this does not mean the running kernel is old. Previously the user said
>>> he was running a 4.4 kernel [1] (or it could be any other kernel
>>> version). For that combination of headers and running kernel, I think
>>> it's ok to add a fallback definition.
>>
>> Yes, fallback definition is good for case like running kernel supports 
>> SHARED_EXTENT flag, but not kernel header.
>>
>> But I'm a little concerned about such fallback definition will lead to 
>> corrupted result for "fi du".
> 
> Well, not corrupted bug wrong. The shared data will be reported as
> exclusive.
> 
>>>> And since that flag is very important for tools like "btrfs filesystem
>>>> du", for old kernel doesn't support EXTENT_SHARED flag, we have no
>>>> choice but abort configuration.
>>>
>>> The check was added to configure so it's caught earlier than during
>>> build. The 'fi du' command is useful, but not IMO critical to stop the
>>> build.
>>
>> What about just disabling subcommands using SHARED_EXTENT flag?
>> Like "fi du".
> 
> This would need to be checked at runtime, based only on kernel version.
> I think we can do that, print a warning in 'fi du' but otherwise let it
> continue.

Checking kernel version is pretty unreliable - distro kernels that backport
will quite possibly fail the version test.  Sure, it's possible to patch
the check back out of userspace in the distro, but one must first know that
such things exist, and look out for them...

Maybe warn on kernel version < 2.6.33 /and/ no shared extents found.

Or, why not just:

1) #ifndef FIEMAP_EXTENT_SHARED / #define FIEMAP_EXTENT_SHARED 0x00002000 / #endif
2) carry on as usual.

Worst case is that you don't get shared accounting on very old kernels.

And FIEMAP_EXTENT_SHARED has been around since 2.6.33 so it's not going
to bite too many people, right?

(If you really wanted to, you could export has_fiemap_shared in the btrfs
features sysfs file, and runtime could see if shared extents are
detectable and if not, print a warning or something ... but given that
this would be a new feature much newer than the fiemap flag I'm not
sure that would do much good.)

-Eric
 

