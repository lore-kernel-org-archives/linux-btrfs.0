Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob12.myregisteredsite.com ([209.17.115.50]:57747 "EHLO
	atl4mhob12.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab3FCCTo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Jun 2013 22:19:44 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob12.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r532JgLb020517
	for <linux-btrfs@vger.kernel.org>; Sun, 2 Jun 2013 22:19:42 -0400
Message-ID: <51ABFD46.90601@chinilu.com>
Date: Sun, 02 Jun 2013 19:19:50 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: Is there a way to flag specific directories "nodatacow"?
References: <51AB5974.3080803@chinilu.com> <20130603012848.GA26016@liubo.jp.oracle.com>
In-Reply-To: <20130603012848.GA26016@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/02/2013 06:28 PM, Liu Bo wrote:
> On Sun, Jun 02, 2013 at 07:40:52AM -0700, George Mitchell wrote:
>> I am seeing massive journal corruptions that seem to be unique to
>> btrfs and I am suspecting that cow might be causing them.  My
>> bandaid fix for this will be to mark the /var filesystem "nodatacow"
>> at boot.  But I am wondering if their is any way to flag a
>> particular directory as "nodatacow" outside of the mount process.  I
>> would like to be able to mark /var/log/journal as "nodatacow" for
>> example, without having to declare it a subvolume and mount it
>> separately.
> Hi George,
>
> We actually have per-file/directory nodatacow :)
>
> But please note if you set nodatacow on the particular directory, only
> new-created or zero-size files in the directory can follow the nocow rule.
>
> 'chattr' in the latest e2fsprogs can fit your requirements,
> # chattr +C /var/log/journal
>
> Also, what kind of massive journal corruptions?  Does it look like a
> btrfs specific bug?
>
> thanks,
> liubo
>
>
I am also assuming that all directories later created under 
/var/log/journal will inherit the nodatacow profile?
