Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33986 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3EREgA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 May 2013 00:36:00 -0400
Message-ID: <51970527.8020604@oracle.com>
Date: Sat, 18 May 2013 12:35:51 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Gabriel de Perthuis <g2p.code@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] a structure for the disks scan for btrfs
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com> <519612B1.7050601@gmail.com>
In-Reply-To: <519612B1.7050601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17/05/2013 19:21, Gabriel de Perthuis wrote:
> On Fri, 17 May 2013 18:54:38 +0800, Anand Jain wrote:
>> The idea was to introduce /dev/mapper to find for btrfs disk,
>> However I found first we need to congregate the disk scan
>> procedure at a function so it would help to consistently tune
>> it across the btrfs-progs. As of now both fi show and
>> dev scan use the disks scan they do it on their own.
>>
>> So here it would congregate btrfs-disk scans at the function
>> scan_devs_for_btrfs, adds /dev/mapper to be used to scan
>> for btrfs, and updates its calling functions and few bug fixes.
>
> Just scan /dev/block/*.  That contains all block devices.

  That does not help. /dev/mapper has unified dev path,
  /dev/block/ don't. when multipath is enabled for a disk,
  we don't have to bother to probe its non multipath block
  path. using /dev/mapper helps in this context.

Thanks
Anand

