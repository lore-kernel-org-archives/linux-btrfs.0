Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wecheer.com ([54.200.0.65]:58095 "EHLO wecheer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbaBDBHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 20:07:04 -0500
Received: from localhost (localhost [127.0.0.1])
	by wecheer.com (Postfix) with ESMTP id 4FC5145BBF
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 01:07:11 +0000 (UTC)
Received: from wecheer.com ([127.0.0.1])
	by localhost (ip-172-31-45-254.us-west-2.compute.internal [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BoFP-343kTjS for <linux-btrfs@vger.kernel.org>;
	Tue,  4 Feb 2014 01:07:07 +0000 (UTC)
Received: from [10.10.22.177] (unknown [207.194.255.202])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: m)
	by wecheer.com (Postfix) with ESMTPSA id 148C943811
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 01:07:07 +0000 (UTC)
Message-ID: <52F03D31.3030400@matthewlai.ca>
Date: Mon, 03 Feb 2014 17:06:57 -0800
From: Matthew Lai <m@matthewlai.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Receive on same subvolume
References: <52E9721D.6000908@matthewlai.ca> <4D0416BE-42D6-4458-9519-9836CC979005@colorremedies.com> <52EFDDA6.2060907@matthewlai.ca> <8BD36B4A-F9AF-40C6-81B8-85FD14CD5EA1@colorremedies.com> <52F01DE1.7030102@matthewlai.ca> <1696955D-7E67-4976-9933-43210C892262@colorremedies.com>
In-Reply-To: <1696955D-7E67-4976-9933-43210C892262@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/02/2014 4:34 PM, Chris Murphy wrote:
> On Feb 3, 2014, at 3:53 PM, Matthew Lai <m@matthewlai.ca> wrote:
>
>> On 03/02/2014 11:26 AM, Chris Murphy wrote:
>>> On Feb 3, 2014, at 11:19 AM, Matthew Lai <m@matthewlai.ca> wrote:
>>>
>>>> Thanks. I should clarify what I'm trying to do.
>>>>
>>>> I'm trying to use btrfs send for backup, without having another btrfs volume.
>>>>
>>>> So the initial backup is a complete send, piped to Amazon Glacier (so my machine never has the whole file, and doesn't have space for one).
>>> OK so you've use btrfs send piped to Glacier which creates a *file*, I'll call it "initial", not a navigable directory of files? Right?
>> That is correct.
>>>> It looks like the problem now is the sent file can't be applied to the original volume (for restore).
>>> I'm counting two sent files: initial, increment1. I'm not sure which one you're applying. If you have the exact same read-only snapshot that the btrfs send file "initial" is based on, then you'd apply the increment1 to that read-only snapshot which will cause a new read-only snapshot to be created with the incremental data applied to it. The error you're getting sounds like the parent read-only snapshot isn't available?
>>>
>> That is also correct. There are 2 sent files. I am trying to apply increment1, on a snapshot of the parent (that was used to create increment1).
> I don't understand how you can apply increment1 to the snapshot of increment1; and also I don't understand how the parent is also increment1.
>
>
>
>
>> I added -vv. Here is the test script for reproducing this entire setup.
>>
>> -----------------------------------------------------------------------
>> #!/bin/sh
>>
>> btrfs subvolume create data
>> btrfs subvolume snapshot -r data first_backup
>> touch data/a
>> btrfs subvolume snapshot -r data second_backup
>> btrfs send -p first_backup second_backup > increment
>> btrfs subvolume snapshot first_backup first_backup_rw
>> btrfs receive -vv first_backup_rw < increment
>> -----------------------------------------------------------------------
>>
>> Output:
>> -----------------------------------------------------------------------
>> Create subvolume './data'
>> Create a readonly snapshot of 'data' in './first_backup'
>> Create a readonly snapshot of 'data' in './second_backup'
>> At subvol second_backup
>> Create a snapshot of 'first_backup' in './first_backup_rw'
>> At snapshot second_backup
>> receiving snapshot second_backup uuid=e6159a2a-3430-344a-a23d-b9bb83851a63, ctransid=28 parent_uuid=20c4ff66-a9ec-fc44-93c6-2c12637e95e6, parent_ctransid=26
>> ERROR: could not find parent subvolume
>> -----------------------------------------------------------------------
>>
>> I would think applying the "patch" to first_backup_rw should succeed, because it's exactly the same as first_backup, which is the parent for the send, but it doesn't.
> btrfs sub snap -r subvol.1 subvol
> btrfs send subvol.1 -f <toglacier>/subvol.1.btrfs
> #write some more files to subvol
> btrfs sub snap -r subvol.2 subvol
> btrfs send -p subvol.1 subvol.2 -f <toglacier>/subvol.2.btrfs
>
> #To make subvol.1 into subvol.2 by applying subvol.2.btrfs to subvol.1, the actual original subvol.1 must be present first or you need to "receive" it from subvol.1.btrfs first. And also, I'm pretty sure you can't have subvol.2 already present because receive must create it.
>
> Again, I haven't tried > and < so I don't know they work. Have you tried -f to point to the files?
According to the manpage, -f is the same as output redirection.
"Output is normally written to stdout. To write to a file, use this 
option.  An alternative would be to use pipes."

The reason why I can't use something like your sequence of commands 
(assuming the order of arguments for snap should be reversed) is that I 
want to be able to verify that the diff is correct, since there are 
still integrity problems with send/receive.

I was planning to do that by applying the "patch" to a snapshot of the 
parent right away, and make sure the patched volume is equal to the 
current snapshot (by trying another send, and making sure the output is 0).

Thanks
Matthew
