Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:40230 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaIQEWM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 00:22:12 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.9])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XU6kr-00066P-0F
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 00:22:09 -0400
Message-ID: <54190C70.1030501@intellasoft.net>
Date: Wed, 17 Sep 2014 00:22:08 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs listing is wrong
References: <5411B5A6.50103@intellasoft.net> <5413E3CB.4050800@oracle.com>
In-Reply-To: <5413E3CB.4050800@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Root is mounted.   This is the same picture after several reboots.


I've actually did some switching things around, drive swaps and some 
expansions but it's still oddly displayed.

Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 5.81GiB
         devid    3 size 10.00GiB used 6.78GiB path /dev/sdd6
         devid    4 size 10.00GiB used 6.78GiB path 
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa

cartman {~} root# ls -al 
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
lrwxrwxrwx 1 root root 10 Sep 16 16:05 
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa -> ../../sdd6


cartman {~} root# blkid  /dev/sdd6
/dev/sdd6: LABEL="Root" UUID="d71404d4-468e-47d5-8f06-3b65fa7776aa" 
UUID_SUB="4ab62e9d-e1dc-4cea-92da-b2640fa841d0" TYPE="btrfs"

cartman {~} root# blkid  /dev/sdi6
/dev/sdi6: LABEL="Root" UUID="d71404d4-468e-47d5-8f06-3b65fa7776aa" 
UUID_SUB="bf76e31c-a49c-4497-83fb-5cb6567b5ad3" TYPE="btrfs"

(dev 4 is really /dev/sdi6)

This was originally a natively created btrfs via mkfs



On 09/13/2014 02:27 AM, Anand Jain wrote:
>
>
> Hi Mark,
>
>> Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>>          Total devices 2 FS bytes used 7.46GiB
>>          devid    1 size 9.31GiB used 8.06GiB path /dev/sdh6
>>          devid    3 size 9.31GiB used 8.06GiB path
>> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
>
>  I hope this taken when Root is mounted, (just for confirmation),
>  which means those are read from the btrfs kernel. Not by scanning
>  the udev.
>
>> # ls -al /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
>> lrwxrwxrwx 1 root root 10 Sep 11 10:43
>> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa -> ../../sdh6
>
>
>  when we read /dev/sdh6 it was devid 1.
>  When we read /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa 
> it was devid 3.
>
>  But udev also says
>    /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
>  is nothing but a soft link to /dev/sdh6 !!
>
>  Very strange !  Can you run blkid and show its output ?
>
>  Also by any chance did we do a disk to disk copy ?
>
>> devid 3 should really  be showing /dev/sde6
>
>  A reboot or btrfs kernel module reload might update the stale
>  and tell the facts.
>
>
> Thanks, Anand

