Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserver1.prnet.org ([195.46.254.69]:52112 "EHLO
	extserver1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2KYUPT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Nov 2012 15:15:19 -0500
Message-ID: <50B27C4A.7040702@prnet.org>
Date: Sun, 25 Nov 2012 21:15:06 +0100
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
References: <50AFB620.6040707@prnet.org> <2925363.jTFvA7mLni@vfr> <50AFE5FC.7040304@prnet.org> <20121124033910.GA5680@gmail.com>
In-Reply-To: <20121124033910.GA5680@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have made some more tests:

./testxattr /u00/root.20121121.210102.full/var/lib/nfs/sm
processing file /u00/root.20121121.210102.full/var/lib/nfs/sm
processing attribute system.posix_acl_default
lgetxattr failed: No data available

getfattr /u00/root.20121121.210102.full/var/lib/nfs/sm
(no result)

setfattr -x system.posix_acl_default
/u00/root.20121121.210102.full/var/lib/nfs/sm

testxattr /u00/root.20121121.210102.full/var/lib/nfs/sm
processing file /u00/root.20121121.210102.full/var/lib/nfs/sm
processing attribute system.posix_acl_access

setfattr -x system.posix_acl_access
/u00/root.20121121.210102.full/var/lib/nfs/sm

./testxattr /u00/root.20121121.210102.full/var/lib/nfs/sm
processing file /u00/root.20121121.210102.full/var/lib/nfs/sm

Now a test with a manually set attribute:

setfattr -n user.testattribute -v testvalue
/u00/root.20121121.210102.full/var/lib/nfs/sm

getfattr /u00/root.20121121.210102.full/var/lib/nfs/sm
getfattr: Removing leading '/' from absolute path names
# file: u00/root.20121121.210102.full/var/lib/nfs/sm
user.testattribute

./testxattr /u00/root.20121121.210102.full/var/lib/nfs/smprocessing file
/u00/root.20121121.210102.full/var/lib/nfs/sm
processing attribute user.testattribute
value testvalue

Thanks in advance,
David Arendt

On 11/24/12 04:39, Liu Bo wrote:
> On Fri, Nov 23, 2012 at 10:09:16PM +0100, David Arendt wrote:
>> Well, this is only code to demonstrate the problem, the ; is normally a
>> silly mistake, but for my test case valuelen is < 0 so, the ; doesn't
>> change anything. With this corrected, the problem stays the same.
>>
>> On 11/23/12 21:43, Garry T. Williams wrote:
>>> On Friday, November 23, 2012 18:45:04 David Arendt wrote:
>>>>   for (i = 0; i < attrslen; i+= strlen(&attrs[i]) + 1)
>>>>   {
>>>>     printf("processing attribute %s\n", &attrs[i]);
>>>>
>>>>     valuelen = lgetxattr(argv[1], &attrs[i], value, 1024);
>>>>
>>>>     if (valuelen < 0);
>>>   Hmmm ----------------^
> Hi David,
>
> Any dmesg output for this?
>
> thanks,
> liubo
>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

