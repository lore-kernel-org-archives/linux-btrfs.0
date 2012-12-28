Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57784 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab2L1Tjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 14:39:49 -0500
Received: by mail-ee0-f48.google.com with SMTP id b57so5223792eek.7
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 11:39:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvhOMZopeVqb4A7PihLuyM2zo_ETN1G3wE_OJi27NfSzVg@mail.gmail.com>
References: <CACCfv7ot+WTV1eiBCujcyPkSt7SGqVvVCKpFo4rn8Y=FEZu_7w@mail.gmail.com>
	<CAE5mzvhOMZopeVqb4A7PihLuyM2zo_ETN1G3wE_OJi27NfSzVg@mail.gmail.com>
Date: Sat, 29 Dec 2012 06:04:00 +1030
Message-ID: <CACCfv7oFanOd1Yg=UgqEVhfHbD=JGkGT3CZy9KpQMgrsWixX=w@mail.gmail.com>
Subject: Re: parent transid verify failed on -- After moving btrfs closer to
 the beginning of drive with dd
From: Jordan Windsor <jordanw2@gmail.com>
To: cwillu <cwillu@cwillu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
thanks for the response!
Here's the output of "-o recovery"

[ 5473.725751] device label Storage devid 1 transid 116023 /dev/sdb1
[ 5473.726612] btrfs: enabling auto recovery
[ 5473.726615] btrfs: disk space caching is enabled
[ 5473.734581] parent transid verify failed on 1229060423680 wanted
116023 found 116027
[ 5473.734797] parent transid verify failed on 1229060423680 wanted
116023 found 116027
[ 5473.734801] btrfs: failed to read tree root on sdb1
[ 5473.735010] parent transid verify failed on 1229060423680 wanted
116023 found 116027
[ 5473.735259] parent transid verify failed on 1229060423680 wanted
116023 found 116027
[ 5473.735262] btrfs: failed to read tree root on sdb1
[ 5473.756367] parent transid verify failed on 1229060243456 wanted
116022 found 116028
[ 5473.761968] parent transid verify failed on 1229060243456 wanted
116022 found 116028
[ 5473.761975] btrfs: failed to read tree root on sdb1
[ 5475.561208] btrfs bad tree block start 7479324919942847850 1241518882816
[ 5475.567008] btrfs bad tree block start 13410158725948676859 1241518882816
[ 5475.567056] Failed to read block groups: -5
[ 5475.570200] btrfs: open_ctree failed

I'm on kernel 3.6.10 and have been before this problem.

Thanks.

On Sat, Dec 29, 2012 at 5:29 AM, cwillu <cwillu@cwillu.com> wrote:
> On Fri, Dec 28, 2012 at 12:09 PM, Jordan Windsor <jordanw2@gmail.com> wrote:
>> Hello,
>> I moved my btrfs to the beginning of my drive & updated the partition
>> table & also restarted, I'm currently unable to mount it, here's the
>> output in dmesg.
>>
>> [  481.513432] device label Storage devid 1 transid 116023 /dev/sdb1
>> [  481.514277] btrfs: disk space caching is enabled
>> [  481.522611] parent transid verify failed on 1229060423680 wanted
>> 116023 found 116027
>> [  481.522789] parent transid verify failed on 1229060423680 wanted
>> 116023 found 116027
>> [  481.522790] btrfs: failed to read tree root on sdb1
>> [  481.523656] btrfs: open_ctree failed
>>
>> What command should I run from here?
>
> The filesystem wasn't uncleanly unmounted, likely on an older kernel.
>
> Try mounting with -o recovery
