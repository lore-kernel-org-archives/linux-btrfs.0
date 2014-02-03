Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wecheer.com ([54.200.0.65]:57575 "EHLO wecheer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbaBCS1L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:27:11 -0500
Received: from localhost (localhost [127.0.0.1])
	by wecheer.com (Postfix) with ESMTP id 8EE8745607
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:19:29 +0000 (UTC)
Received: from wecheer.com ([127.0.0.1])
	by localhost (ip-172-31-45-254.us-west-2.compute.internal [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VsjVccPXSn6h for <linux-btrfs@vger.kernel.org>;
	Mon,  3 Feb 2014 18:19:26 +0000 (UTC)
Received: from [10.10.22.177] (unknown [207.194.255.202])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: m)
	by wecheer.com (Postfix) with ESMTPSA id A863045B72
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:19:26 +0000 (UTC)
Message-ID: <52EFDDA6.2060907@matthewlai.ca>
Date: Mon, 03 Feb 2014 10:19:18 -0800
From: Matthew Lai <m@matthewlai.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Receive on same subvolume
References: <52E9721D.6000908@matthewlai.ca> <4D0416BE-42D6-4458-9519-9836CC979005@colorremedies.com>
In-Reply-To: <4D0416BE-42D6-4458-9519-9836CC979005@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks. I should clarify what I'm trying to do.

I'm trying to use btrfs send for backup, without having another btrfs 
volume.

So the initial backup is a complete send, piped to Amazon Glacier (so my 
machine never has the whole file, and doesn't have space for one).

At the same time I'm keeping a snapshot of the current volume.

On the next incremental backup, I would use the first snapshot as the 
parent, and send the differences to Glacier again (without having the 
entire file on the system at any time).

It looks like the problem now is the sent file can't be applied to the 
original volume (for restore).

Thanks
Matthew

On 03/02/2014 9:30 AM, Chris Murphy wrote:
> On Jan 29, 2014, at 2:26 PM, Matthew Lai <m@matthewlai.ca> wrote:
>
>> Hello,
>>
>> Is this supposed to work? (/data is the root volume, /data/a is a subvolume)
>>
>> btrfs subvolume snapshot /data/a /data/b
>> # make some changes in b
>> btrfs send -p /data/a /data/b > delta
>> btrfs receive /data/a < delta
>>
>> I'm getting "ERROR: could not find parent subvolume" on receive.
>> What I'm trying to do is to back up using send/receive, but I don't have 50% free space, and (please correct me if I'm wrong) since receive doesn't do deduplication, I want to use snapshot to do the initial bootstrapping, instead of send/receive without a parent.
> I think you've oversimplified your commands, because it looks like you're using send/receive on the same file system. But if it's a backup, necessarily you'd have to be sending the subvolume(s) to another file system on another disk (either on the same system or remotely). So that needs some clarification.
>
> Also, btrfs send requires subvolumes to be read only. Are they?
>
> And btrfs incremental receive expects the identical parent already on the destination. Is it?
>
> Also, while I'm not certain it matters, man page says to use -f to specify files. I haven't tested < and >. But then also the step where you create this intermediate snapshot file isn't necessary, just combine the send receive commands through pipe.
>
>
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

