Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44737 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJFTsg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 15:48:36 -0400
Message-ID: <5432F205.8010002@prnet.org>
Date: Mon, 06 Oct 2014 21:48:21 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send and kernel 3.17
References: <5432E466.9070604@prnet.org> <1412622378.31886.3@mail.thefacebook.com>
In-Reply-To: <1412622378.31886.3@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have upgraded from kernel 3.16.3.

emerge-fetch.log is a simple append-only log file. Other files having
the problems after deleting them one by one have been emerge.log,
mysql.log, freshclam.log and main.cvd from clamav. At this one, I
stopped deleting.

On 10/06/2014 09:06 PM, Chris Mason wrote:
> On Mon, Oct 6, 2014 at 2:50 PM, David Arendt <admin@prnet.org> wrote:
>> Hi,
>>
>> After upgrading to kernel 3.17 btrfs send has stopped working.
>>
>> ERROR: send ioctl failed with -5: Input/output error
>>
>> The following message is printed by kernel:
>>
>> [75322.782197] BTRFS error (device sda2): did not find backref in
>> send_root. inode=461, offset=0, disk_byte=1094713344 found
>> extent=1094713344
>>
>> btrfs inspect-internal inode-resolve -v 461 /u00/root.snapshot returns:
>>
>> /var/log/emerge-fetch.log
>>
>> After removing this file, the error moves on to another file.
>>
>> btrfs scrub output:
>>
>> scrub status for bc31b068-2c36-4ff2-ac5c-7ce55af5371d
>>     scrub started at Mon Oct  6 19:49:25 2014 and finished after 1748
>> seconds
>>     total bytes scrubbed: 94.21GiB with 0 errors
>>
>> Other then the btrfs send problem, the filesystem works normally.
>>
>> Is this a bug in btrfs-send or is my filesystem corrupted and should be
>> restored from backup ?
>>
>> Please tell me if I can do anything else to help debugging this issue.
>
> Which kernel did you upgrade from?  I don't think we have changes in
> 3.17 that should impact this.
>
> Is merge-fetch.log just a simple append-only log file?
>
> -chris
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

