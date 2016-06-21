Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:58866 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbcFUAh3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 20:37:29 -0400
Subject: Re: Confusing output from fi us/df
To: Marc Grondin <marcfgrondin@gmail.com>, linux-btrfs@vger.kernel.org
References: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <4c73e55f-aabb-4ec3-c419-e970b9506d7d@mendix.com>
Date: Tue, 21 Jun 2016 02:25:20 +0200
MIME-Version: 1.0
In-Reply-To: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 06/21/2016 01:30 AM, Marc Grondin wrote:
>
> I have a btrfs filesystem ontop of a 4x1tb mdraid raid5 array and I've
> been getting confusing output on metadata usage. Seems that even tho
> both data and metadata are in single profile metadata is reporting
> double the space(as if it was in dupe profile)

I guess that's a coincidence.

 From the total amount of space you have (on top of the mdraid), there's 
3 GiB allocated/reserved for use as metadata. Inside that 3 GiB, 1.53GiB 
of actual metadata is present.

>[...]
> Metadata,single: Size:3.00GiB, Used:1.53GiB
> /dev/mapper/storage2 3.00GiB

> Metadata, single: total=3.00GiB, used=1.53GiB

If you'd change to DUP, it would look like:

for fi usage:

Metadata,single: Size:3.00GiB, Used:1.53GiB
/dev/mapper/storage2 6.00GiB

for fi df:

Metadata, single: total=3.00GiB, used=1.53GiB

Except for the 6.00GiB which would show the actual usage on disk, the 
other metadata numbers all hide the profile ratio.

Hans
