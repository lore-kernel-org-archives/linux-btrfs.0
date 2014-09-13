Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45781 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaIMGXQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 02:23:16 -0400
Message-ID: <5413E3CB.4050800@oracle.com>
Date: Sat, 13 Sep 2014 14:27:23 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Mark Murawski <markm-lists@intellasoft.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs listing is wrong
References: <5411B5A6.50103@intellasoft.net>
In-Reply-To: <5411B5A6.50103@intellasoft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Mark,

> Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>          Total devices 2 FS bytes used 7.46GiB
>          devid    1 size 9.31GiB used 8.06GiB path /dev/sdh6
>          devid    3 size 9.31GiB used 8.06GiB path
> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa

  I hope this taken when Root is mounted, (just for confirmation),
  which means those are read from the btrfs kernel. Not by scanning
  the udev.

> # ls -al /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
> lrwxrwxrwx 1 root root 10 Sep 11 10:43
> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa -> ../../sdh6


  when we read /dev/sdh6 it was devid 1.
  When we read /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa it 
was devid 3.

  But udev also says
    /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
  is nothing but a soft link to /dev/sdh6 !!

  Very strange !  Can you run blkid and show its output ?

  Also by any chance did we do a disk to disk copy ?

> devid 3 should really  be showing /dev/sde6

  A reboot or btrfs kernel module reload might update the stale
  and tell the facts.


Thanks, Anand
