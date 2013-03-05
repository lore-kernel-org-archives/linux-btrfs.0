Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38311 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab3CEBTD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 20:19:03 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 3C6BF3EE0AE
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 10:19:01 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 207A545DE58
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 10:19:01 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 07E2345DE54
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 10:19:01 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id EEEF6E08003
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 10:19:00 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id A62DB1DB804B
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 10:19:00 +0900 (JST)
Message-ID: <513547FA.5060403@jp.fujitsu.com>
Date: Tue, 05 Mar 2013 10:18:50 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs-progs: check out if the swap device
References: <201302140753.AA00021@FM-323941448.jp.fujitsu.com> <51337EB2.7090607@swiftspirit.co.za>
In-Reply-To: <51337EB2.7090607@swiftspirit.co.za>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/03/04 1:47, Brendan Hide wrote:
> On 2013/02/14 09:53 AM, Tsutomu Itoh wrote:
>> +        if (ret < 0) {
>> +            fprintf(stderr, "error checking %s status: %s\n", file,
>> +                strerror(-ret));
>> +            exit(1);
>> +        }
>>
>> ...
>>
>> +        /* check if the device is busy */
>> +        fd = open(file, O_RDWR|O_EXCL);
>> +        if (fd < 0) {
>> +            fprintf(stderr, "unable to open %s: %s\n", file,
>> +                strerror(errno));
>> +            exit(1);
>> +        }
> This is fine and works (as tested by David) - but I'm not sure if the below
  suggestions from Zach were taken into account.
>
> 1. If the check with "open(file, O_RDWR|O_EXCL)" shows that the device is
> available, there's no point in checking if it is mounted as a swap device.
> A preliminary check using this could precede all other checks which should
> be skipped if it shows success.
>
> 2. If there's an error checking the status (for example lets say /proc/swaps
> is deprecated), we should print the informational message but not error out.

If "open(file, O_RDWR|O_EXCL)" failed, we should output an appropriate message
why it failed. So, I'm testing is_swap_device() and check_mounted() first.
But is_swap_device() is not perfect, so I'm trying to open O_EXCL after all
other tests, as a last safety check.

Thanks,
Tsutomu

>
> On 2013/02/13 11:58 AM, Zach Brown wrote:
>> - First always open with O_EXCL.  If it succeeds then there's no reason
>>    to check /proc/swaps at all.  (Maybe it doesn't need to try
>>    check_mounted() there either?  Not sure if it's protecting against
>>    accidentally mounting mounted shared storage or not.)
>>
>> ...
>>
>> - At no point is failure of any of the /proc/swaps parsing fatal.  It'd
>>    carry on ignoring errors until it doesnt have work to do.  It'd only
>>    ever print the nice message when it finds a match.
>
>


