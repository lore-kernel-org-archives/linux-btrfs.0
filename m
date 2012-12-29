Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:61487 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2L2NUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 08:20:33 -0500
Received: by mail-ea0-f170.google.com with SMTP id d11so4537846eaa.1
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2012 05:20:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACCfv7oFanOd1Yg=UgqEVhfHbD=JGkGT3CZy9KpQMgrsWixX=w@mail.gmail.com>
References: <CACCfv7ot+WTV1eiBCujcyPkSt7SGqVvVCKpFo4rn8Y=FEZu_7w@mail.gmail.com>
	<CAE5mzvhOMZopeVqb4A7PihLuyM2zo_ETN1G3wE_OJi27NfSzVg@mail.gmail.com>
	<CACCfv7oFanOd1Yg=UgqEVhfHbD=JGkGT3CZy9KpQMgrsWixX=w@mail.gmail.com>
Date: Sat, 29 Dec 2012 23:44:40 +1030
Message-ID: <CACCfv7r5zVx7UGWNLyeHT9t6VT8rWW8WgQwAb+ffjiUOyi6C2g@mail.gmail.com>
Subject: Re: parent transid verify failed on -- After moving btrfs closer to
 the beginning of drive with dd
From: Jordan Windsor <jordanw2@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also here's the output of btrfs-find-root:

./btrfs-find-root /dev/sdb1
Super think's the tree root is at 1229060866048, chunk root 1259695439872
Went past the fs size, exiting

Not sure where to go from here.

On Sat, Dec 29, 2012 at 6:04 AM, Jordan Windsor <jordanw2@gmail.com> wrote:
> Hello,
> thanks for the response!
> Here's the output of "-o recovery"
>
> [ 5473.725751] device label Storage devid 1 transid 116023 /dev/sdb1
> [ 5473.726612] btrfs: enabling auto recovery
> [ 5473.726615] btrfs: disk space caching is enabled
> [ 5473.734581] parent transid verify failed on 1229060423680 wanted
> 116023 found 116027
> [ 5473.734797] parent transid verify failed on 1229060423680 wanted
> 116023 found 116027
> [ 5473.734801] btrfs: failed to read tree root on sdb1
> [ 5473.735010] parent transid verify failed on 1229060423680 wanted
> 116023 found 116027
> [ 5473.735259] parent transid verify failed on 1229060423680 wanted
> 116023 found 116027
> [ 5473.735262] btrfs: failed to read tree root on sdb1
> [ 5473.756367] parent transid verify failed on 1229060243456 wanted
> 116022 found 116028
> [ 5473.761968] parent transid verify failed on 1229060243456 wanted
> 116022 found 116028
> [ 5473.761975] btrfs: failed to read tree root on sdb1
> [ 5475.561208] btrfs bad tree block start 7479324919942847850 1241518882816
> [ 5475.567008] btrfs bad tree block start 13410158725948676859 1241518882816
> [ 5475.567056] Failed to read block groups: -5
> [ 5475.570200] btrfs: open_ctree failed
>
> I'm on kernel 3.6.10 and have been before this problem.
>
> Thanks.
>
> On Sat, Dec 29, 2012 at 5:29 AM, cwillu <cwillu@cwillu.com> wrote:
>> On Fri, Dec 28, 2012 at 12:09 PM, Jordan Windsor <jordanw2@gmail.com> wrote:
>>> Hello,
>>> I moved my btrfs to the beginning of my drive & updated the partition
>>> table & also restarted, I'm currently unable to mount it, here's the
>>> output in dmesg.
>>>
>>> [  481.513432] device label Storage devid 1 transid 116023 /dev/sdb1
>>> [  481.514277] btrfs: disk space caching is enabled
>>> [  481.522611] parent transid verify failed on 1229060423680 wanted
>>> 116023 found 116027
>>> [  481.522789] parent transid verify failed on 1229060423680 wanted
>>> 116023 found 116027
>>> [  481.522790] btrfs: failed to read tree root on sdb1
>>> [  481.523656] btrfs: open_ctree failed
>>>
>>> What command should I run from here?
>>
>> The filesystem wasn't uncleanly unmounted, likely on an older kernel.
>>
>> Try mounting with -o recovery
