Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vivaldi.com ([82.221.99.164]:38744 "EHLO mail.vivaldi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbbEBRUM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 May 2015 13:20:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.vivaldi.com (Postfix) with ESMTP id 0F5C4D4161E
	for <linux-btrfs@vger.kernel.org>; Sat,  2 May 2015 17:20:11 +0000 (GMT)
Received: from mail.vivaldi.com ([127.0.0.1])
	by localhost (haydn.viv.ext [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RCbmu65K27Ch for <linux-btrfs@vger.kernel.org>;
	Sat,  2 May 2015 17:20:10 +0000 (GMT)
Message-ID: <55450740.2010100@vivaldi.com>
Date: Sat, 02 May 2015 13:20:00 -0400
From: Christian Dysthe <christian@vivaldi.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Manana <fdmanana@gmail.com>
Subject: Re: 3.19.3: check tree block failed + WARNING: device 0 not present
 on scrub
References: <20150502163010.GK13624@merlins.org> <55450046.6040100@vivaldi.com> <20150502170509.GM13624@merlins.org>
In-Reply-To: <20150502170509.GM13624@merlins.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/02/2015 01:05 PM, Marc MERLIN wrote:
> On Sat, May 02, 2015 at 12:50:14PM -0400, Christian Dysthe wrote:
>> Mine is still doing it. This is from today's log:
>>
>> /etc/cron.daily/btrfs-scrub:
>> WARNING: device 0 not present
>> scrub device /dev/sda3 (id 1) done
>> 	scrub started at Sat May  2 08:03:46 2015 and finished after 241 seconds
>> 	total bytes scrubbed: 109.06GiB with 0 errors
>> scrub device  (id 0) canceled
>> 	scrub started at Sat May  2 08:03:46 2015 and was aborted after 0 seconds
>> 	total bytes scrubbed: 0.00B with 0 errors
>>
>> It doesn't seem to cause any problems but it would of course be good to know what it is and even get rid of it. This is my laptop with a SSD containing a small ext4 /boot partition and a latrge btrfs partition / with a /home subvolume (close to Ubuntu standard for btrfs).
>   
> Please run the equivalent of this on your filesystem:
> btrfs-debug-tree -t 2 /dev/mapper/cryptroot 2>&1 | tee /tmp/debug_2.txt
>
> And see if it completes or fails in the middle.
All I get is: Could not open /dev/mapper/cryptroot  The only thing in 
that directory is -control I do not have any kinds of encryption on 
anything.
>
> Marc

-- 
Regards,
Christian Dysthe - Vivaldi Technlologies
Download Vivaldi at: https://vivaldi.com
Discuss it at: https://vivaldi.net

