Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:41419 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaBMTtF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:49:05 -0500
Message-ID: <52FD21B4.4050502@libero.it>
Date: Thu, 13 Feb 2014 20:49:08 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
In-Reply-To: <20140214012810.26297146@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <52FD1AD6.50500@libero.it>
 <20140214012810.26297146@natsu>

Hi Roman

On 02/13/2014 08:28 PM, Roman Mamedov wrote:
> On Thu, 13 Feb 2014 20:19:50 +0100
> Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
[...]
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index fc85eef..d4cab63 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>> @@ -798,6 +798,9 @@ const struct cmd_group filesystem_cmd_group = {
>>  		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
>>  		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
>>  		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
>> +		{ "disk-usage", cmd_filesystem_disk_usage,
>> +			cmd_filesystem_disk_usage_usage, NULL, 0 },
>> +
> 
> Same here, I'd suggest "du" or "usage".
> As currently in the patch it's not shorthand-friendly, you basically propose
> that people wishing a shorter invocation use it as "btrfs fi di" or "btrfs fi
> disk", which seems awkward and not intuitive.

Thanks for the comments, however I don't like du not usage; but you are right 
when you don't like "disk-usage". What about "btrfs filesystem chunk-usage" ? The short form would be 

	btrfs fi chunk

which is coherent with the data displayed

Regards
Goffredo

P.S.
Please the next time, cut the email lines which are not relevant to your
replay


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
