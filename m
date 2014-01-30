Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ec2-54-200-0-65.us-west-2.compute.amazonaws.com ([54.200.0.65]:53135
	"EHLO wecheer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaA3VlP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 16:41:15 -0500
Received: from localhost (localhost [127.0.0.1])
	by wecheer.com (Postfix) with ESMTP id 7F75C455F1
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 21:41:18 +0000 (UTC)
Received: from wecheer.com ([127.0.0.1])
	by localhost (ip-172-31-45-254.us-west-2.compute.internal [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gi1fTsRUXMD2 for <linux-btrfs@vger.kernel.org>;
	Thu, 30 Jan 2014 21:41:15 +0000 (UTC)
Received: from [10.10.22.177] (unknown [207.194.255.202])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: m)
	by wecheer.com (Postfix) with ESMTPSA id E7BD14313C
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 21:41:15 +0000 (UTC)
Message-ID: <52EAC6F8.9040005@matthewlai.ca>
Date: Thu, 30 Jan 2014 13:41:12 -0800
From: Matthew Lai <m@matthewlai.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send requires root
References: <52E955F2.60608@matthewlai.ca> <20140130183007.GD1364@twin.jikos.cz>
In-Reply-To: <20140130183007.GD1364@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ah I see. Thanks for clarifying!

Matthew

On 30/01/2014 10:30 AM, David Sterba wrote:
> On Wed, Jan 29, 2014 at 11:26:42AM -0800, Matthew Lai wrote:
>> I have just started playing with btrfs, and noticed that "btrfs send" only
>> works for root (ERROR: failed to initialize subvol search. Operation not
>> permitted), even on subvolumes created by the user.
>>
>> Am I doing something wrong? Or is this the intended behaviour?
> Intended but can be revisited to allow non-root owner's to send their
> snapshots.
>
>> Returns:
>> ERROR: can't perform the search- Operation not permitted
>> ERROR: failed to initialize subvol search. Operation not permitted
> The SEARCH_TREE ioctl is also root-only and a unconstrained interface to
> the filesystem internals, so a new ioctl would have to be introduced to
> do what send needs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

