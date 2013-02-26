Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38024 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab3BZDzu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 22:55:50 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id F3BDB44DD81
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 12:55:48 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id DC05F45DE4E
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 12:55:48 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id B9E0D45DE51
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 12:55:48 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A9D641DB8037
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 12:55:48 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 628711DB802F
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 12:55:48 +0900 (JST)
Message-ID: <512C3230.8020305@jp.fujitsu.com>
Date: Tue, 26 Feb 2013 12:55:28 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: chris.mason@fusionio.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com> <5124EDAB.5020003@giantdisaster.de> <512BF648.1090602@jp.fujitsu.com> <512BFCD1.3030709@redhat.com>
In-Reply-To: <512BFCD1.3030709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/26 9:07, Eric Sandeen wrote:
> On 2/25/13 5:39 PM, Tsutomu Itoh wrote:
>> On 2013/02/21 0:37, Stefan Behrens wrote:
>>> On Thu, 14 Feb 2013 12:30:03 -0600, Eric Sandeen wrote:
>>>> The core of this is shamelessly stolen from xfsprogs.
>>>>
>>>> Use blkid to detect an existing filesystem or partition
>>>> table on any of the target devices.  If something is found,
>>>> require the '-f' option to overwrite it, hopefully avoiding
>>>> disaster due to mistyped devicenames, etc.
>>>>
>>>> # mkfs.btrfs /dev/sda1
>>>>
>>>> WARNING! - Btrfs v0.20-rc1-59-gd00279c-dirty IS EXPERIMENTAL
>>>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>>>
>>>> /dev/sda1 appears to contain an existing filesystem (xfs).
>>>> Use the -f option to force overwrite.
>>>> #
>>>>
>>>> This does introduce a requirement on libblkid.
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>
>>> This means that it is now required to change all occurrences of
>>> "mkfs.btrfs" to "mkfs.btrfs -f" everywhere. Can't we first establish a
>>
>> I also think so.
>> It means -f is not significant to me, I think.
>> (Most of my test scripts fails without -f. So I'll always type "mkfs.btrfs -f")
>>
>> Therefore I want you to revert commit:2a2d8e1962e8b6cda7b0a7584f6d2fb95d442cb6.
>>    btrfs-progs: require mkfs -f force option to overwrite filesystem or partition table
>>
>> How do you think about it?
>
> What if you submit a patch to look at an environment variable,
> BTRFS_CLOBBERS_ALL=1 which causes it to not require -f to overwrite?
> Then you can just set it once at the top of your test environment,
> and not change every instance?

Yes. But,
 >> (Most of my test scripts fails without -f. So I'll always type "mkfs.btrfs -f")
is one example.

Almost everyone types "mkfs.btrfs -f" (or BTRFS_CLOBBERS_ALL=1 :)
unconditionally, I think.
So, I think -f option is almost meaningless.

> Otherwise, I guess I think:
>
> WARNING! - Btrfs v0.20-rc1-212-gf6ef8b5 IS EXPERIMENTAL
>
> and we need to expect that things might change ...

EXPERIMENTAL... It's certainly so.
However, I think that we should not add the option that it troubles
a lot of people.

Thanks,
Tsutomu

>
> -Eric
>
>> Thanks,
>> Tsutomu
>>
>>> time period of 100 years where the -f option is tolerated and ignored,
>>> and then in 2113 we require that the users add the -f option?
>>>
>>> (Just had to do this string replacement everywhere, and had to add -f to
>>> xfstest's _scratch_mkfs in common.rc as well). Sigh.
>>>
>>
>


