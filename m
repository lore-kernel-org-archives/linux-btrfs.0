Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49129 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXRxA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Dec 2012 12:53:00 -0500
Received: by mail-ee0-f54.google.com with SMTP id c13so3739969eek.41
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2012 09:52:59 -0800 (PST)
Message-ID: <50D89678.9070202@gmail.com>
Date: Mon, 24 Dec 2012 18:52:56 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: incomplete erase of btrfs with wipefs
References: <8C039D41-002B-440C-9888-9CAB1BC17190@colorremedies.com>
In-Reply-To: <8C039D41-002B-440C-9888-9CAB1BC17190@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chrism

On 12/23/2012 10:11 PM, Chris Murphy wrote:
> Hi,
> 
> I'm not completely sure if this is a wipefs bug, or a btrfs(-progs)
> bug. The gist is that after using wipefs on a btrfs formatted
> partition, then reformatted as ext4, mount sees it as ext4, parted
> sees it as ext4, but I btrfs fi show sees it as a member device of a
> btrfs volume. I have filed a bug against util-linux, but perhaps this
> is a btrfs-progs over confidence in what it thinks is a valid volume.
> I have included in the bug report the first 5MB of the device.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=889888

I cannot reproduce this behaviour [1]. However I have to point out that
this [2][3] patch solved a problem like you reported.

Which version of btrfs-progs do you have ? It seems that F18 (beta)
already has the latest btrfs-progs suite..

BR
G.Baroncelli


[1]

ghigo@venice:~$ /sbin/mkfs.btrfs /dev/sdi1 -L test

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label test on /dev/sdi1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 7.45GB
Btrfs Btrfs v0.19
ghigo@venice:~$ btrfs fi show /dev/sdi1
[...]
Label: 'test'  uuid: 64df10e0-7131-449d-84ec-a5babdd6199e
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 7.45GB used 799.25MB path /dev/sdi1

Btrfs v0.19-101-g3891d2d
ghigo@venice:~$ /sbin/wipefs /dev/sdi1
offset               type
----------------------------------------------------------------
0x10040              btrfs   [filesystem]
                     LABEL: test
                     UUID:  64df10e0-7131-449d-84ec-a5babdd6199e

ghigo@venice:~$ /sbin/wipefs /dev/sdi1 -o 0x10040
8 bytes were erased at offset 0x10040 (btrfs)
they were: 5f 42 48 52 66 53 5f 4d
ghigo@venice:~$ btrfs fi show /dev/sdi1
Btrfs v0.19-101-g3891d2d
ghigo@venice:~$ /sbin/blkid | grep sdi1
ghigo@venice:~$ /sbin/wipefs /dev/sdi1


[2]
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=commitdiff;h=6eba9002956ac40db87d42fb653a0524dc568810;hp=bc130ecd0260e4ee6ffe07ae43fc90db281a4daa

[3] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18649.html

> 
> 
> Chris Murphy
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
