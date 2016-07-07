Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 206-248-167-68.dsl.teksavvy.com ([206.248.167.68]:40695 "EHLO
	mail.isoar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbcGGWjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 18:39:41 -0400
Message-ID: <577EDA03.9000308@isoar.ca>
Date: Thu, 07 Jul 2016 18:38:59 -0400
From: "Andrew E. Mileski" <andrewm@isoar.ca>
MIME-Version: 1.0
To: Francesco Turco <fturco@fastmail.fm>, linux-btrfs@vger.kernel.org
Subject: Re: Frequent btrfs corruption on a USB flash drive
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm> <577EC57C.8060607@isoar.ca> <0ad5fc23-9b10-5e95-888d-9717a8fb480d@fastmail.fm>
In-Reply-To: <0ad5fc23-9b10-5e95-888d-9717a8fb480d@fastmail.fm>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 17:13, Francesco Turco wrote:
>
> On 2016-07-07 23:11, Andrew E. Mileski wrote:
>> How large is this USB flash device?
>
> 64 GB.
>

I don't know if there is an official recommended minimum size for btrfs, but I 
would expect 64 GB to be okay.

I've personally set my minimum recommendation for btrfs at 120 GB based on my 
experience with failures in various flash devices from 4 to 30 GB.

If you want to experiment, I have a theory that formatting single volumes with 
"-m single" can avoid a potential controller race in one specific situation, 
plus it helps to reduce the meta overhead on smaller devices.

Lastly, the last two USB issues I investigated were both fixed by replacing the 
cables.  Something to try if it is a cabled device.

~~
Andrew E. Mileski
