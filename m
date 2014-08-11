Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32953 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaHKXvo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 19:51:44 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id AB1383EE174
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:51:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id B9402AC0214
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:51:41 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id EB57FE08001
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:51:40 +0900 (JST)
Message-ID: <53E95703.9050705@jp.fujitsu.com>
Date: Tue, 12 Aug 2014 08:51:31 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs-progs: random fixes of btrfs-filesystem documentation
References: <53E888C3.70807@jp.fujitsu.com> <53E8F7F0.3060300@redhat.com>
In-Reply-To: <53E8F7F0.3060300@redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

(2014/08/12 2:05), Eric Sandeen wrote:
> On 8/11/14, 2:11 AM, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>>   - Simplify and unify the description of both man and usage.
>>   - Fix to show -m and -d is not exclusive
>>     with "<path>|<uuid>|<device>|<label>".
>>   - Add the description about short options for "--mounted" and
>>     "--all-devices", "-m" and "-d" respectively.
>>   - Move the descriptions of options to "Options" section.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> ---
>>   Documentation/btrfs-filesystem.txt | 22 ++++++++++++++--------
>>   cmds-filesystem.c                  | 15 ++++++++++-----
>>   2 files changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
>> index c9c0b00..fe68496 100644
>> --- a/Documentation/btrfs-filesystem.txt
>> +++ b/Documentation/btrfs-filesystem.txt
>> @@ -20,15 +20,21 @@ SUBCOMMAND
>>   *df* <path> [<path>...]::
>>   Show space usage information for a mount point.
>>   
>> -*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
>> -Show the btrfs filesystem with some additional info.
>> +*show* [-d|-m] [<path>|<uuid>|<device>|<label>]::
>> +Show the structure of btrfs filesystem(s).
>>   +
>> -If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
>> -information of all the btrfs filesystem both mounted and unmounted.
>> -If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
>> -filesystem(s);
>> -If '--all-devices' is passed, all the devices under /dev are scanned;
>> -otherwise the devices list is extracted from the /proc/partitions file.
> 
>> +If none of '<path>|<uuid>|<device>|<label>' is passed, btrfs shows
>> +information of all the btrfs filesystems both mounted and unmounted.
> 
> that doesn't seem quite correct;
> 
> # btrfs filesystem show -m
> 
> does not specify '<path>|<uuid>|<device>|<label>' but it only shows
> mounted filesystems, not all filesystems.

Oh, I forgot to add "[" and "]". 

> 
> As I understand it, the -d and -m options control how the command
> finds devices; the '<path>|<uuid>|<device>|<label>' argument is
> used as a filter for what is found.

Yes, my understanding is so too.

> 
>> ++
>> +The show command finds btrfs filesystems by scanning all the devices
>> +in /proc/partitions by default.
> 
> I think I would document it something like this:
> 
> show [-m|-d] [<path>|<uuid>|<device>|<label>]
> 	Show the structure of btrfs filesystem(s).
> 
> 	By default, the show command scans all devices found in /proc/partitions.	
> 	If [-d|--all-devices] is specified, all devices found under /dev are scanned.
> 	If [-m|--mounted] is specified, only mounted (btrfs?) devices are scanned.
> 
> 	By default, the structure of all discovered filesystems is shown.
> 	If any one of [<path>|<uuid>|<device>|<label>] is specified, only filesystems
> 	matching that identifier are shown.

OK, I'll fix my patch based on your comment.
# Of course, I'll replace "(btrfs?)" with something proper words.

Can I add your "Signed-off-by" to my v2 patch?

> 
> (What seems to be missing, though, is why would the user ever choose to use '-d?')

I'm not sure. I guess, for example, in large systems, -d takes too
many times for scanning all devices under /dev or something?

Thank you for your comments!

Satoru

> 
> -Eric
> 

