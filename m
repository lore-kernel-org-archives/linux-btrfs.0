Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:50257 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaIORPz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 13:15:55 -0400
Message-ID: <54171EC6.7040704@codethink.co.uk>
Date: Mon, 15 Sep 2014 18:15:50 +0100
From: Sam Thursfield <sam.thursfield@codethink.co.uk>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
CC: baserock-dev@baserock.org, johannes.hirte@datenkhaos.de,
        xavier.gnata@gmail.com, 1i5t5.duncan@cox.net
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54171711.8010107@oracle.com>
In-Reply-To: <54171711.8010107@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15/09/14 17:42, Anand Jain wrote:
>
>   Logs from Sam, tells the problem clearly.  mount is using
>   /dev/sda, but mount error message and kernel is using /dev/vda.
>
> ----------------------
> $ mount /dev/sda /home -t btrfs -o subvol=/state/home,defaults,rw,noatime
> mount: /dev/vda is already mounted or /home busy
>         /dev/vda is already mounted on /

Sorry for the confusion here. I typed in the shell commands into the log 
manually and obviously put /dev/sda when I meant /dev/vda.

I've retested with /dev/vda and the same error occurs.

> On 15/09/2014 23:13, Sam Thursfield wrote:
>> Hi!
>>
>> I'm having an issue with the 3.17rc5 kernel which prevents having
>> multiple subvolumes of the same disk mounted.
>>
>> I'm not sure exactly the cause. I thought it might be because in my
>> system the root file system is itself a subvolume of the disk I'm trying
>> to mount. But if I create a second disk image with two subvolumes, the
>> same thing occurs -- I can only mount one of them at a time.
>>
>> I've attached the output of a few commands, please let me know if you
>> want more info (I'm not subscribed to the list, please keep me in To:).
>>
>> We've bisected and found that the exact commit that changed the
>> behaviour is this one:
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b96de000bc8bc9688b3a2abea4332bd57648a49f
>>
>>
>>
>> I'm afraid I'm not familiar with the Btrfs code base and so I don't
>> understand the exact meaning of the comments in that commit.
>>
>> Thanks
>> Sam
>>


-- 
Sam Thursfield, Codethink Ltd.
Office telephone: +44 161 236 5575
