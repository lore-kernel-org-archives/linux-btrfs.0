Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:45347 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbaDWXGF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 19:06:05 -0400
Message-ID: <535845ED.9060000@pobox.com>
Date: Wed, 23 Apr 2014 15:59:57 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: hung task timer + btrfs_convert or btrfs balance = OOPS
References: <53582625.3030800@pobox.com> <20140423211238.GI26949@merlins.org>
In-Reply-To: <20140423211238.GI26949@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/23/2014 02:12 PM, Marc MERLIN wrote:
> On Wed, Apr 23, 2014 at 01:44:21PM -0700, Robert White wrote:
>> As it is, the two options are not happy together. Be sure to
>>
>> echo 0 > /proc/sys/kernel/hung_task_timeout_secs
>>
>> to disable the timer before doing a mount or balance after a
>
> But this only removes the messages from syslog, it doesn't actually
> fix/remove any hangs, unless I'm missing something.

All I know for sure is instant prompt return after the oops and trashed 
file system.

Maybe I have the cause and effect backwards and the btrfs_convert had 
some subtle fail that led to the delay coincidentally. With the drive 
trashed I assumed the oops was causative because I had to jump right on 
rebuilding the system.



-- Rob.
