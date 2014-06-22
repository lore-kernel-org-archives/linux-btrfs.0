Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob08.myregisteredsite.com ([209.17.115.46]:39983 "EHLO
	atl4mhob08.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbaFVNnO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 09:43:14 -0400
Received: from mailpod1.hostingplatform.com (atl4obmail01pod1.mgt.hosting.qts.netsol.com [10.30.71.113])
	by atl4mhob08.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s5MDhC4d007705
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Jun 2014 09:43:12 -0400
Message-ID: <53A6DDAD.8070804@chinilu.com>
Date: Sun, 22 Jun 2014 06:44:13 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on whole disk (no partitions)
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>	<2316027.LZEnVG8laK@xev>	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com> <CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
In-Reply-To: <CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2014 12:49 AM, Imran Geriskovan wrote:
>> The 64KB Btrfs bootloader pad is 8 sector aligned, so for 512e AF disks
>> there's no problem formatting the whole drive. The alignment problem
>> actually happens when partitioning it, using old partition tools that don't
>> align on 8 sector boundaries. There are some such tools still floating
>> around.
> A 'somewhat' related question:
>
> So called Advanced Format drives has 4K physical sector size,
> however they report 512B logical sector size.
>
> How does linux kernel access those drives?
> 512B or 4K at a time?
>
> Imran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
This is a problem related to Western Digital drives.  They lie in order 
to be compatible with older versions of Windows.  Seagate AF drives 
report 4K, not 512B.  Western Digital took this path in order to make 
the drives work with older Windows operating systems because Microsoft 
chose not to include support for AF drives until the last minute.  As 
far as I know, btrfs defaults to 4K UNLESS you specify 512B when you 
create the file system and the kernel follows the filesystem, not the 
(in this case incorrect) info the drive reports, I could not find the 
documentation to confirm this, perhaps someone else can confirm it.  
Actually a 4K format will work just fine on a 512B drive AS LONG as the 
alignment is correct.  The larger problem occurs when a 4K drive is 
formatted as 512B.  But it is a real pain that the WD AF drives report 
as being conventional drives in order to not confuse Windows.
