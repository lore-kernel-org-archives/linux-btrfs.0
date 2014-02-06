Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42572 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBFF1z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 00:27:55 -0500
Received: by mail-pd0-f178.google.com with SMTP id y13so1262631pdi.37
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 21:27:55 -0800 (PST)
Message-ID: <52F31D51.8040609@gmail.com>
Date: Thu, 06 Feb 2014 16:27:45 +1100
From: Thermionix <thermionix@gmail.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: device delete missing panic
References: <52F30422.8@gmail.com> <52F3112C.3070309@oracle.com> <52F31726.7000200@gmail.com> <52F31BAF.5040507@oracle.com>
In-Reply-To: <52F31BAF.5040507@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

~ # dmesg | tail
[  351.083338] btrfs: failed to read chunk tree on sdg
[  351.088283] btrfs: open_ctree failed
[  392.541465] device label pool devid 7 transid 55056 /dev/sdh
[  393.558496] btrfs: allowing degraded mounts
[  393.558503] btrfs: disk space caching is enabled
[  393.605461] BTRFS critical (device sdg): unable to find logical 1563838812160 len 4096
[  393.605479] BTRFS critical (device sdg): unable to find logical 1563838812160 len 4096
[  393.605491] BTRFS critical (device sdg): unable to find logical 1563838812160 len 4096
[  393.605495] btrfs: failed to read tree root on sdg
[  393.612297] btrfs: open_ctree failed

On 06/02/14 16:20, Anand Jain wrote:
> 
> 
> 
>> as I now can't mount (open_ctree failed)
> 
>  at around open_ctree failed message should help.
> 
> Thanks, Anand
