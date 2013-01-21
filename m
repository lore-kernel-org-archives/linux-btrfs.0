Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40842 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3AUK2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 05:28:23 -0500
Message-ID: <50FD19DC.2080704@oracle.com>
Date: Mon, 21 Jan 2013 18:35:08 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11 V3] add show command to the subvol sub command
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com> <1357818083-15531-1-git-send-email-anand.jain@oracle.com> <50FC898A.1070208@czarc.net>
In-Reply-To: <50FC898A.1070208@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Gene,

  I should do that in couple of days. Thanks.

Anand


On 01/21/2013 08:19 AM, Gene Czarcinski wrote:
> On 01/10/2013 06:41 AM, Anand Jain wrote:
>> This is an attempt to make btrfs cli more end user friendly.
>> And adds show subcommand to display all known (as of now)
>> information of the given subvol including its snapshot(s).
>>
>> The below patch:
>>   "Btrfs-progs: accommodate different layout for printing subvol list"
>> obsoletes the previosuly submitted patch
>>   "Btrfs-progs: make provision to print subvol list tree format"
>>
>> Please provide your review comments. Thanks.
>>
>> An example output:
>>
>> First list out all the subvols/snapshots using the list subcommand.
>>
>> btrfs su list /btrfs
>> ID 256 gen 10 top level 5 path sv1
>> ID 259 gen 6 top level 5 path sv1/snap
>> ID 260 gen 7 top level 5 path snap
>> ID 261 gen 8 top level 5 path sv2
>> ID 262 gen 9 top level 5 path sv1/snap2
>> ID 263 gen 10 top level 5 path sv1/snap3
>>
>> Then use show subcommand to know all known information about the
>> given subvol.
>>
>> btrfs su show /btrfs/sv1
>> /btrfs/sv1
>>     uuid:             508b12a5-ed2a-3942-af63-830967201070
>>     Parent uuid:         -
>>     Creation time:         2013-01-07 13:53:30
>>     Object ID:         256
>>     Generation (Gen):     10
>>     Gen at creation:     5
>>     Parent:         5
>>     Top Level:         5
>>     Snapshot(s):
>>                 sv1/snap
>>                 sv1/snap2
>>                 sv1/snap3
>>
>>
>> v2->v3: List snapshots of the given subvol if any.
>>          Uses a more simple approach to obtain the snapshots.
>>
>>
> You have certainly been busy.  However, your patches need to be rebased
> considering some of the patch-sets currently sent to the mailing list.
> If nothing else, I would appreciate it if you could rebase to David
> Sterba's set.  And then there are the two patch-sets I submitted.
>
> BTW, I do not claim anything except for the effort to scrapes these off
> the list to attempt getting btrfs-progs a bit more current with respect
> to bugfixes.  I was going to include "su show" but your latest
> submission is a bit too much for now.
>
> Gene
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
