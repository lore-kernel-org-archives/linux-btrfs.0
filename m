Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:36753 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaBYK2T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 05:28:19 -0500
Received: by mail-ve0-f174.google.com with SMTP id oy12so180736veb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 02:28:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <530C0796.4070205@oracle.com>
References: <CAMU1PDh6crrOW02oqz6jqvG+rAG6W3mb+V=gHEy37FB1q0UpOg@mail.gmail.com>
	<20140224135702.GG23877@carfax.org.uk>
	<530C0796.4070205@oracle.com>
Date: Tue, 25 Feb 2014 10:28:18 +0000
Message-ID: <CAMU1PDiQwM_ch48yuWMQAOfM0=R+6MD=QfU-HatAHN2d4BQgQQ@mail.gmail.com>
Subject: Re: How to identify if a partition containing a btrfs volume is
 mounted and where
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 February 2014 03:01, Anand Jain <Anand.Jain@oracle.com> wrote:
>
>> # mkfs.btrfs /dev/sdb2 /dev/sdb3 /dev/sdb4
>> # mount /dev/sdb2 /mnt/1
>> # btrfs device delete /dev/sdb2 /mnt/1
>>
>> So /dev/sdb2 is no longer part of the file system, but it's still
>> mounted using it.
>>
>> # grep btrfs /proc/mounts
>> /dev/sdb2 /mnt/1 btrfs rw,seclabel,relatime,ssd,space_cache 0 0
>
>
>  This bug isn't there is the current btrfs-next. I couldn't
>  reproduce.

I've tested this again.  With linux 3.12.10 on Fedora 20 it is still
reproducible, but after upgrading to linux 3.13.3 /proc/mounts
automatically changes to show another device when the initial mounting
one is removed from the btrfs.

Thanks,
Mike
