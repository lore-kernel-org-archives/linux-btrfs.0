Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44267 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3AFQBu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 11:01:50 -0500
Received: by mail-bk0-f42.google.com with SMTP id ji2so7955033bkc.29
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 08:01:49 -0800 (PST)
Message-ID: <50E99FFB.5020107@gmail.com>
Date: Sun, 06 Jan 2013 17:02:03 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: helmut@hullen.de
CC: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
Subject: Re: Option LABEL
References: <CO8jf1hPCXB@helmut.hullen.de>
In-Reply-To: <CO8jf1hPCXB@helmut.hullen.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Helmut
On 01/03/2013 10:52 PM, Helmut Hullen wrote:

> I know a similar behaviour p.e. when I run
> 
>         btrfs-show
> 
> Then btrfs seems to test all block devices in "/dev" (no "udev" system)  
> and then tells most times

"btrfs-show" and "btrfs filesystem show" behave differently.
The former (which is deprecated) scans every block device found under
/dev. The latter scans every block device found in /proc/partition.

For "btrfs filesystem show" it is possible to have the old behaviour
passing the "--all-devices" option.

The same switch exists also for "btrfs device scan".

In order to avoid misunderstanding I suggest you to use "btrfs
filesystem show"



> 
>    failed to read /dev/<nonexistent device>: No such device or address
> 
> But those (unnecessary) messages come quick, with only some seconds  
> delay.
> 
> -----------------
> 
> The above log file comes from a machine without floppy disk (a laptop).  
> Running "blkid" on an elder tower (with installed and usable floppy  
> disk) also checks for "/dev/fd0" and then tells "ok".
> 
> Tomorrow I'll test this behaviour on another laptop. Could be a "blkid"  
> error.
> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
