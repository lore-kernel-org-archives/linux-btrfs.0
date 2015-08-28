Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43051 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbH1ORR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 10:17:17 -0400
Message-ID: <55E06D5E.90605@oracle.com>
Date: Fri, 28 Aug 2015 22:17:02 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
CC: clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: device delete to accept devid
In-Reply-To: <55D5BA12.20007@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1439548611-29730-1-git-send-email-anand.jain@oracle.com>
 <1439548611-29730-3-git-send-email-anand.jain@oracle.com>
 <55D5BA12.20007@inwind.it>


Hi Goffredo,

  sorry to have missed this.


On 08/20/2015 07:29 PM, Goffredo Baroncelli wrote:
> Hi Anand
> On 2015-08-14 12:36, Anand Jain wrote:
>> This patch introduces new option <devid> for the command
>>
> [...]
>
>> +
>> +		if (is_numerical(argv[i])) {
>> +			argv3.devid = arg_strtou64(argv[i]);
>> +			its_num = true;
>> +		} else if (is_block_device(argv[i])) {
>
>
> please be aware that is_block_device(), returns
> - 1 if the file is a block device,
> - < 0 in case of an error (eg: file not found)
> - 0 otherwise
>
> so I suggest to change the check in
>
>   +		} else if (is_block_device(argv[i]) == 1) {
>
> [...]
>

oh yes. I didn't notice that.

In fact everywhere we didn't check the return properly.
I wrote a new patch to fix this.

Thanks, Anand

