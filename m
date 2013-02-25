Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52164 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584Ab3BYXkN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 18:40:13 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 670F13EE0BC
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 08:40:11 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 4A83345DE54
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 08:40:11 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 35D7C45DE58
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 08:40:11 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 241F7E08001
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 08:40:11 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id C5214E08003
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 08:40:10 +0900 (JST)
Message-ID: <512BF648.1090602@jp.fujitsu.com>
Date: Tue, 26 Feb 2013 08:39:52 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Eric Sandeen <sandeen@redhat.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com> <5124EDAB.5020003@giantdisaster.de>
In-Reply-To: <5124EDAB.5020003@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/21 0:37, Stefan Behrens wrote:
> On Thu, 14 Feb 2013 12:30:03 -0600, Eric Sandeen wrote:
>> The core of this is shamelessly stolen from xfsprogs.
>>
>> Use blkid to detect an existing filesystem or partition
>> table on any of the target devices.  If something is found,
>> require the '-f' option to overwrite it, hopefully avoiding
>> disaster due to mistyped devicenames, etc.
>>
>> # mkfs.btrfs /dev/sda1
>>
>> WARNING! - Btrfs v0.20-rc1-59-gd00279c-dirty IS EXPERIMENTAL
>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>
>> /dev/sda1 appears to contain an existing filesystem (xfs).
>> Use the -f option to force overwrite.
>> #
>>
>> This does introduce a requirement on libblkid.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>
> This means that it is now required to change all occurrences of
> "mkfs.btrfs" to "mkfs.btrfs -f" everywhere. Can't we first establish a

I also think so.
It means -f is not significant to me, I think.
(Most of my test scripts fails without -f. So I'll always type "mkfs.btrfs -f")

Therefore I want you to revert commit:2a2d8e1962e8b6cda7b0a7584f6d2fb95d442cb6.
   btrfs-progs: require mkfs -f force option to overwrite filesystem or partition table

How do you think about it?

Thanks,
Tsutomu

> time period of 100 years where the -f option is tolerated and ignored,
> and then in 2113 we require that the users add the -f option?
>
> (Just had to do this string replacement everywhere, and had to add -f to
> xfstest's _scratch_mkfs in common.rc as well). Sigh.
>

