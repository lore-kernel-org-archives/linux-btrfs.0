Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43105 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaA0I6v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 03:58:51 -0500
Message-ID: <52E621FC.4010908@oracle.com>
Date: Mon, 27 Jan 2014 17:08:12 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com> <1390812770-11720-2-git-send-email-anand.jain@oracle.com> <20140127084709.GK3314@carfax.org.uk>
In-Reply-To: <20140127084709.GK3314@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/27/2014 04:47 PM, Hugo Mills wrote:
> On Mon, Jan 27, 2014 at 04:52:50PM +0800, Anand Jain wrote:
>> The user land progs needs   a simple way to read
>> the raw list of disks and its parameters as
>> btrfs kernel understands it. This patch will
>> introduce BTRFS_IOC_GET_DEVS which dumps
>> every thing under fs_devices.
>>
>> As of now btrfs-devlist uses this ioctl.
>>
>> In the long run this ioctl would help to optimize
>> some part of btrfs-progs, mainly the current
>> btrfs filesystem show
>
>     Just thinking out loud here, really, but can we export this
> information in /sys instead, rather than adding yet more ioctls?
>

  I was more inclined towards (live) memory dump. But I need to fix
  btrfs-progs as well so ioctl.
