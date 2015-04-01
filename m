Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35634 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbDAKyl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Apr 2015 06:54:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YdGIA-0001jq-Ua
	for linux-btrfs@vger.kernel.org; Wed, 01 Apr 2015 12:54:39 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 12:54:33 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 12:54:33 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: ERROR: error removing the device '/dev/sdXN' - Inappropriate
 ioctl for device
Date: Wed, 01 Apr 2015 11:54:21 +0100
Message-ID: <mfgiot$3ck$1@ger.gmane.org>
References: <mfcdep$d97$1@ger.gmane.org> <20150331173756.GF6821@twin.jikos.cz> <mfeo14$sib$1@ger.gmane.org> <551B98FF.8070000@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <551B98FF.8070000@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/04/15 08:06, Anand Jain wrote:
> 
>>>> btrfs device delete /dev/sdf5 /mnt/data2
>>>>
>>>> ERROR: error removing the device '/dev/sdf5' - Inappropriate ioctl for
>>>> device
> 
>  very strange. 'btrfs fi show -m' shows btrfs fs(s) that are mounted.

Looks like my /dev/sdf isn't responding with anything useful at all... A
firmware crash?... (This is for a 256GB SSD.)


# btrfs fi show -m

[...]

Label: 'btrfs_data2'  uuid: 3aaee716-b98b-4c86-ba5a-53456994f152
        Total devices 3 FS bytes used 159.31GiB
        devid    1 size 206.47GiB used 206.02GiB path /dev/sdb5
        devid    2 size 206.47GiB used 206.47GiB path /dev/sdd5
        devid    3 size 206.47GiB used 206.47GiB path /dev/sdf5


btrfs-progs v3.19.1



# smartctl -i /dev/sdf
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.14.10-gentoo_s03a_11]
(local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               /7:0:0:0
Product:
Compliance:           SPC-5
User Capacity:        600,332,565,813,390,450 bytes [600 PB]
Logical block size:   774843950 bytes
scsiModePageOffset: response length too short, resp_len=47 offset=50
bd_len=46
scsiModePageOffset: response length too short, resp_len=47 offset=50
bd_len=46
>> Terminate command early due to bad response to IEC mode page
A mandatory SMART command failed: exiting. To continue, add one or more
'-T permissive' options.



And btrfs is still running ok so far... I'll be swapping that device at
the weekend. (First chance I have for a Sunday shutdown. :-( )


Still... For administering btrfs, it is a little disturbing not to be
able to remove/delete a device unless that device is both mounted and
working...

Or is that where the "missing" option comes in?



Comments welcomed,

Thanks,
Martin





