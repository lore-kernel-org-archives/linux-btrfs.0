Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3BYEjY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Feb 2013 23:39:24 -0500
Message-ID: <512AEAF3.1080100@oracle.com>
Date: Mon, 25 Feb 2013 12:39:15 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: kreijack@inwind.it, Hendrik Friedel <hendrik@friedels.name>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Needed change in Wiki
References: <512A2019.6000201@friedels.name> <512A4CD6.7050804@gmail.com>
In-Reply-To: <512A4CD6.7050804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



You may need to update the minimum version of
libblkid-dev that is required. Since.

latest btrfs-progs needs
   blkid_probe_get_wholedisk_devno()
from the libblkid-dev.
found libblkid-dev version 2.17.2 does not work,
and 2.22 works. Not sure which version introduced the
function required here.


HTH
Anand


On 02/25/2013 01:24 AM, Goffredo Baroncelli wrote:
> On 02/24/2013 03:13 PM, Hendrik Friedel wrote:
>> Hello,
>>
>> I don't see how to change the wiki, but it needs an update:
>>
>> apt-get build-dep btrfs-tools
>> -or-
>> apt-get install uuid-dev libattr1-dev zlib1g-dev libacl1-dev e2fslibs-dev
>>
>> here libblkid-dev is missing -at least for the latest git version of the
>> btrfs-progs.
>
> Updated, thanks
>
>> Greetings,
>> Hendrik
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
