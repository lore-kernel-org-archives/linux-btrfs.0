Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:39169 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaBMToG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:44:06 -0500
Message-ID: <52FD2086.6060105@libero.it>
Date: Thu, 13 Feb 2014 20:44:06 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/8] Add btrfs device disk-usage command
In-Reply-To: <20140214012343.19792fb0@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <52FD1AEC.1020700@libero.it>
 <20140214012343.19792fb0@natsu>

Hi Roman,
On 02/13/2014 08:23 PM, Roman Mamedov wrote:
> On Thu, 13 Feb 2014 20:20:12 +0100
> Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
[...]

> 
> Why not just name it "du"? Think about the current handy feature of shortening
> commands by only specifying parts of the keywords. "btrfs dev du" would seem
> more intuitive than calling it as "btrfs dev disk" or "btrfs dev disk-u".
> 
> Or simply "usage", because "...device disk..." is redundant, device is already
> a disk, so it can easily be "btrfs device usage".

Yes, I agree about "usage"
GB


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
