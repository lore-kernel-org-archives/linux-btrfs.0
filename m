Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab3BZEH2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 23:07:28 -0500
Message-ID: <512C34CC.3070904@redhat.com>
Date: Mon, 25 Feb 2013 22:06:36 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: chris.mason@fusionio.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com> <5124EDAB.5020003@giantdisaster.de> <512BF648.1090602@jp.fujitsu.com> <512BFCD1.3030709@redhat.com> <512C3230.8020305@jp.fujitsu.com>
In-Reply-To: <512C3230.8020305@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/25/13 9:55 PM, Tsutomu Itoh wrote:
> On 2013/02/26 9:07, Eric Sandeen wrote:
>> On 2/25/13 5:39 PM, Tsutomu Itoh wrote:
>>> On 2013/02/21 0:37, Stefan Behrens wrote:
>>>> On Thu, 14 Feb 2013 12:30:03 -0600, Eric Sandeen wrote:
>>>>> The core of this is shamelessly stolen from xfsprogs.
>>>>>
>>>>> Use blkid to detect an existing filesystem or partition
>>>>> table on any of the target devices.  If something is found,
>>>>> require the '-f' option to overwrite it, hopefully avoiding
>>>>> disaster due to mistyped devicenames, etc.
>>>>>
>>>>> # mkfs.btrfs /dev/sda1
>>>>>
>>>>> WARNING! - Btrfs v0.20-rc1-59-gd00279c-dirty IS EXPERIMENTAL
>>>>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>>>>
>>>>> /dev/sda1 appears to contain an existing filesystem (xfs).
>>>>> Use the -f option to force overwrite.
>>>>> #
>>>>>
>>>>> This does introduce a requirement on libblkid.
>>>>>
>>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>>
>>>> This means that it is now required to change all occurrences of
>>>> "mkfs.btrfs" to "mkfs.btrfs -f" everywhere. Can't we first establish a
>>>
>>> I also think so.
>>> It means -f is not significant to me, I think.
>>> (Most of my test scripts fails without -f. So I'll always type "mkfs.btrfs -f")
>>>
>>> Therefore I want you to revert commit:2a2d8e1962e8b6cda7b0a7584f6d2fb95d442cb6.
>>>    btrfs-progs: require mkfs -f force option to overwrite filesystem or partition table
>>>
>>> How do you think about it?
>>
>> What if you submit a patch to look at an environment variable,
>> BTRFS_CLOBBERS_ALL=1 which causes it to not require -f to overwrite?
>> Then you can just set it once at the top of your test environment,
>> and not change every instance?
> 
> Yes. But,
>>> (Most of my test scripts fails without -f. So I'll always type "mkfs.btrfs -f")
> is one example.
> 
> Almost everyone types "mkfs.btrfs -f" (or BTRFS_CLOBBERS_ALL=1 :)
> unconditionally, I think.
> So, I think -f option is almost meaningless.
> 
>> Otherwise, I guess I think:
>>
>> WARNING! - Btrfs v0.20-rc1-212-gf6ef8b5 IS EXPERIMENTAL
>>
>> and we need to expect that things might change ...
> 
> EXPERIMENTAL... It's certainly so.
> However, I think that we should not add the option that it troubles
> a lot of people.

Well, I sent it as an RFC.  Chris merged it; I'll defer to his judgement.

Thanks,
-Eric

> Thanks,
> Tsutomu
> 
>>
>> -Eric
>>
>>> Thanks,
>>> Tsutomu
>>>
>>>> time period of 100 years where the -f option is tolerated and ignored,
>>>> and then in 2113 we require that the users add the -f option?
>>>>
>>>> (Just had to do this string replacement everywhere, and had to add -f to
>>>> xfstest's _scratch_mkfs in common.rc as well). Sigh.
>>>>
>>>
>>
> 
> 

