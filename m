Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59583 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaK2Hhj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 02:37:39 -0500
Received: by mail-vc0-f172.google.com with SMTP id hq11so3446289vcb.31
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Nov 2014 23:37:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54792084.6060404@pobox.com>
References: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
	<20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it>
	<20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it>
	<20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<20141125222126.GQ17380@hungrycats.org>
	<54760B89.3050604@inwind.it>
	<20141127041510.GV17380@hungrycats.org>
	<5478AB6C.7030809@inwind.it>
	<54792084.6060404@pobox.com>
Date: Sat, 29 Nov 2014 08:37:38 +0100
Message-ID: <CAE8gLh=nWayiou9ytRJ32Jy5q_Vxv856kpgC8wAPU+biU1Jy2A@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-11-29 2:25 GMT+01:00 Robert White <rwhite@pobox.com>:
>
> On 11/28/2014 09:05 AM, Goffredo Baroncelli wrote:
>>
>> For the disk autodetection, I still convinced that it is a "sane" default
>> to skip the lvm-snapshot
>
>
> No... please don't...
>
> Maybe offer an option to select between snapshots or no-snapshots but in much the same way there is no _functional_ difference between a subvolume and a snapshot in btrfs, there is no "degenerate" status to an LVM snapshot.
>
> It would be way more useful if the helper dumped a message via stderr or syslog that said something like "UUID=xxxxxxxx ambiguous, must select between /dev/AA and /dev/BB using device= to mount filesystem."
>


I agree with this. Sometimes people will exactly want to do that:
mount the snapshot devices and not the origins. Listing devices in the
device= mount option sounds perfectly sane.
