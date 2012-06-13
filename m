Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31633 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2FMKdb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 06:33:31 -0400
Message-ID: <4FD86BD0.5090606@oracle.com>
Date: Wed, 13 Jun 2012 18:30:40 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: Roman Mamedov <rm@romanrm.ru>, linux-btrfs@vger.kernel.org
Subject: Re: Massive metadata size increase after upgrade from 3.2.18 to 3.4.1
References: <20120609013822.6b06a008@natsu> <1339522697.2990.10.camel@ayu>
In-Reply-To: <1339522697.2990.10.camel@ayu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Did you try balance ? (also there is a balance option
  to pick the least utilized metadata chunks).

  in long run when you have the understanding of your
  files and sizes tuning using mount option metadata_ratio
  might help.

  but not sure how the  metadata expanded to 84.38G
  was there any major delete operation on the filesystem?

thanks, Anand
   

On 13/06/12 01:38, Calvin Walton wrote:
> On Sat, 2012-06-09 at 01:38 +0600, Roman Mamedov wrote:
>> Hello,
>>
>> Before the upgrade (on 3.2.18):
>>
>> Metadata, DUP: total=9.38GB, used=5.94GB
>>
>> After the FS has been mounted once with 3.4.1:
>>
>> Data: total=3.44TB, used=2.67TB
>> System, DUP: total=8.00MB, used=412.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=84.38GB, used=5.94GB
>>
>> Where did my 75 GB of free space just went?
>
> Btrfs tries to keep a certain ratio of allocated data space to allocated
> metadata space at all times, in order to ensure that there is always
> some free metadata space available. In 3.3 (I believe, but haven't
> actually checked...) this ratio was increased, since people were still
> complaining about btrfs reporting out of space errors too soon.
>
> On a filesystem containing (a relatively small number of) large files,
> it probably over-allocates the metadata space, which is what you're
> seeing. I'm not sure if the ratio is tunable.
>
> But better to have a bit of unused metadata space than to get 'out of
> space' errors once you've filled your disk and you're trying to delete
> some files!
>
