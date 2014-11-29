Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i2.italiaonline.it ([212.48.25.204]:39631 "EHLO
	smtp-33.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751087AbaK2Het (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 02:34:49 -0500
Message-ID: <5479774E.1050302@inwind.it>
Date: Sat, 29 Nov 2014 08:35:42 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Zygo Blaxell <zblaxell@furryterror.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com> <546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org> <5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org> <5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org> <5474FBD9.5070709@inwind.it> <20141125222126.GQ17380@hungrycats.org> <54760B89.3050604@inwind.it> <20141127041510.GV17380@hungrycats.org> <5478AB6C.7030809@inwind.it> <54792084.6060404@pobox.com>
In-Reply-To: <54792084.6060404@pobox.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/29/2014 02:25 AM, Robert White wrote:
> On 11/28/2014 09:05 AM, Goffredo Baroncelli wrote:
>> For the disk autodetection, I still convinced that it is a "sane"
>> default to skip the lvm-snapshot
> 
> No... please don't...
> 
> Maybe offer an option to select between snapshots or no-snapshots but
> in much the same way there is no _functional_ difference between a
> subvolume and a snapshot in btrfs, there is no "degenerate" status to
> an LVM snapshot.

I agree with you; but I have to find a "default" so during the boot
a system can start even if snapshots are present.

And pay attention that there would be cases where multiple
snapshot are present: how group these ? My be for generation number ?

Anyway for the moment my help simply refuse to mount if there is
a conflict of dev_uuid.

> 
> It would be way more useful if the helper dumped a message via stderr
> or syslog that said something like "UUID=xxxxxxxx ambiguous, 

This is what it is printed when the helper finds a duplicate uuid:

ghigo@emulato:~$ sudo lvdisplay | grep "LV Path"
  LV Path                /dev/test/lv01
  LV Path                /dev/test/lv02
  LV Path                /dev/test/lv02_snap
  LV Path                /dev/test/lv01_snap

ghigo@emulato:~$ sudo mount /dev/test/lv01 /mnt/btrfs1/
ERROR: disk '/dev/mapper/test-lv01' and '/dev/mapper/test-lv01_snap' have the same disk uuid
ERROR: disk '/dev/mapper/test-lv02_snap' and '/dev/mapper/test-lv02' have the same disk uuid

> must
> select between /dev/AA and /dev/BB using device= to mount
> filesystem."

But anyway I can force the disk to mount:

ghigo@emulato:~$ sudo mount /dev/test/lv01_snap -o device=/dev/test/lv02_snap /mnt/btrfs1/

> 
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
