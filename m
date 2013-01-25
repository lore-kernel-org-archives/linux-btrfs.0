Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw9b.glodns.net ([196.220.48.76]:42328 "EHLO fw9a.glodns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932196Ab3AYNaI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 08:30:08 -0500
Received: from localhost (unknown [127.0.0.1])
	by fw9a.glodns.net (Postfix) with ESMTP id 53E5826192
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 13:30:06 +0000 (UTC)
Received: from fw9a.glodns.net ([196.220.48.76])
	by localhost (fw9a.glodns.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TtDrMMu9Q22K for <linux-btrfs@vger.kernel.org>;
	Fri, 25 Jan 2013 15:30:01 +0200 (SAST)
Received: from control.glodns.net (unknown [196.220.42.40])
	by fw9a.glodns.net (Postfix) with ESMTP id 4597A26180
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 15:30:01 +0200 (SAST)
Message-ID: <51028897.2000408@swiftspirit.co.za>
Date: Fri, 25 Jan 2013 15:28:55 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: inconsistent output on sub list
References: <50FEEB9E.2060305@swiftspirit.co.za> <5101062E.5060604@oracle.com>
In-Reply-To: <5101062E.5060604@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------030003000202050808050403"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030003000202050808050403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Confirmed the fix is working.

^ TLDR can stop here :)

Recompiled the original Archlinux package from newly-synced ABS but also 
with your patch. I then tested the newly-compiled btrfs with the patch. 
I realised after I should have also tested immediately before installing 
the patched version, so I reinstalled the original unpatched version for 
the final test to confirm the problem was rectified entirely by the 
one-line change. The attached log shows the detail.

On 24/01/13 12:00, Anand Jain wrote:
>
>
> Brendan,
>
>  -------
>  >> [root@watricky mnt]# btrfs subvolume list / -a
>  >> ID 258 gen 4226 top level 384 path media/smbshare
>  ::
>  >> [root@watricky mnt]# btrfs subvolume list /home -a
>  >> ID 258 gen 4226 top level 5 path 
> <FS_TREE>/__active/media/smbshare4.snap
>  -------
>  This is definitely a bug. Thanks for reporting.
>
>  I have made some fair-assumptions, and have sent out the
>  patch[1] to fix this bug (ref this email thread). Could you
>  kindly test it and report the result ?
>
> [1]
> [PATCH] Btrfs-progs: we need to have the string null terminated
>
> Thanks,  Anand
>
>
> On 01/23/2013 03:42 AM, Brendan Hide wrote:
>> Linux watricky 3.6.11-1-ARCH #1 SMP PREEMPT Tue Dec 18 08:57:15 CET 2012
>> x86_64 GNU/Linux
>>
>> In working on a snapshot maintenance script I've noticed some odd
>> behaviour. Note the smbshare path. I've put this into its own subvolume
>> as I don't plan on snapshotting it.
>>
>> In the first command's output, this path is printed correctly, however
>> in the second output it has "4.snap" appended, similar to the names of
>> the snapshots I made 22 hours ago.
>>
>> If this is a documented issue with a fix then no worries. But if not and
>> anyone wants me to check into any further specifics, please let me know.
>>
>>  > [root@watricky mnt]# btrfs subvolume list / -a
>>  > ID 258 gen 4226 top level 384 path media/smbshare
>>  > ID 259 gen 4337 top level 384 path home
>>  > ID 384 gen 4321 top level 5 path <FS_TREE>/__active
>>  > ID 392 gen 4337 top level 384 path var
>>  > ID 393 gen 4267 top level 384 path usr
>>  > ID 428 gen 4267 top level 5 path
>> <FS_TREE>/__snapshot/__active.20130121-23h44.snap
>>  > ID 429 gen 3980 top level 5 path
>> <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
>>  > ID 430 gen 4043 top level 5 path
>> <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
>>  > ID 431 gen 4267 top level 5 path
>> <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
>>  > [root@watricky mnt]# btrfs subvolume list /home -a
>>  > ID 258 gen 4226 top level 5 path 
>> <FS_TREE>/__active/media/smbshare4.snap
>>  > ID 259 gen 4337 top level 5 path <FS_TREE>/__active/home
>>  > ID 384 gen 4321 top level 5 path <FS_TREE>/__active
>>  > ID 392 gen 4337 top level 5 path <FS_TREE>/__active/var
>>  > ID 393 gen 4267 top level 5 path <FS_TREE>/__active/usr
>>  > ID 428 gen 4267 top level 5 path
>> <FS_TREE>/__snapshot/__active.20130121-23h44.snap
>>  > ID 429 gen 3980 top level 5 path
>> <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
>>  > ID 430 gen 4043 top level 5 path
>> <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
>>  > ID 431 gen 4267 top level 5 path
>> <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
>>  > [root@watricky mnt]#
>>
>> Note that the only directly mounted share is __active, mounted at /.
>>


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97


--------------030003000202050808050403
Content-Type: text/x-log;
 name="null-string.patched.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="null-string.patched.log"

[ brendan@watricky.invalid.co.za : 15:03:10 : ~/build/btrfs-progs ]
:) sudo pacman -U btrfs-progs-0.19.20121005-4-x86_64.pkg.tar.xz 
[sudo] password for brendan: 
loading packages...
warning: btrfs-progs-0.19.20121005-4 is up to date -- reinstalling
resolving dependencies...
looking for inter-conflicts...

Targets (1): btrfs-progs-0.19.20121005-4

Total Installed Size:   2.43 MiB
Net Upgrade Size:       -0.04 MiB

Proceed with installation? [Y/n] 
(1/1) checking package integrity                                                                                 [###################################################################] 100%
(1/1) loading package files                                                                                      [###################################################################] 100%
(1/1) checking for file conflicts                                                                                [###################################################################] 100%
(1/1) checking available disk space                                                                              [###################################################################] 100%
(1/1) upgrading btrfs-progs                                                                                      [###################################################################] 100%
[ brendan@watricky.invalid.co.za : 15:03:33 : ~/build/btrfs-progs ]
:) sudo su -
[root@watricky ~]# btrfs subvolume list / -a
ID 258 gen 5034 top level 384 path media/smbshare
ID 259 gen 5161 top level 384 path home
ID 384 gen 5161 top level 5 path <FS_TREE>/__active
ID 392 gen 5161 top level 384 path var
ID 393 gen 5161 top level 384 path usr
ID 428 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130121-23h44.snap
ID 429 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
ID 430 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
ID 431 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
ID 550 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130125-13h38.snap
ID 552 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130125-13h38.snap
ID 553 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130125-13h38.snap
ID 555 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130125-13h39.snap
[root@watricky ~]# btrfs subvolume list /home -a
ID 258 gen 5034 top level 5 path <FS_TREE>/__active/media/smbshare
ID 259 gen 5161 top level 5 path <FS_TREE>/__active/home
ID 384 gen 5161 top level 5 path <FS_TREE>/__active
ID 392 gen 5161 top level 5 path <FS_TREE>/__active/var
ID 393 gen 5161 top level 5 path <FS_TREE>/__active/usr
ID 428 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130121-23h44.snap
ID 429 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
ID 430 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
ID 431 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
ID 550 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130125-13h38.snap
ID 552 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130125-13h38.snap
ID 553 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130125-13h38.snap
ID 555 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130125-13h39.snap
[root@watricky ~]# pacman -S btrfs-progs
warning: btrfs-progs-0.19.20121005-4 is up to date -- reinstalling
resolving dependencies...
looking for inter-conflicts...

Targets (1): btrfs-progs-0.19.20121005-4

Total Installed Size:   2.47 MiB
Net Upgrade Size:       0.04 MiB

Proceed with installation? [Y/n] 
(1/1) checking package integrity                                                                                 [###################################################################] 100%
(1/1) loading package files                                                                                      [###################################################################] 100%
(1/1) checking for file conflicts                                                                                [###################################################################] 100%
(1/1) checking available disk space                                                                              [###################################################################] 100%
(1/1) upgrading btrfs-progs                                                                                      [###################################################################] 100%
[root@watricky ~]# btrfs subvolume list / -a
ID 258 gen 5034 top level 384 path media/smbshare
ID 259 gen 5162 top level 384 path home
ID 384 gen 5161 top level 5 path <FS_TREE>/__active
ID 392 gen 5162 top level 384 path var
ID 393 gen 5161 top level 384 path usr
ID 428 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130121-23h44.snap
ID 429 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
ID 430 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
ID 431 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
ID 550 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130125-13h38.snap
ID 552 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130125-13h38.snap
ID 553 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130125-13h38.snap
ID 555 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130125-13h39.snap
[root@watricky ~]#
[root@watricky ~]# btrfs subvolume list /home -a
ID 258 gen 5034 top level 5 path <FS_TREE>/__active/media/smbshare4.snap
ID 259 gen 5162 top level 5 path <FS_TREE>/__active/home
ID 384 gen 5161 top level 5 path <FS_TREE>/__active
ID 392 gen 5162 top level 5 path <FS_TREE>/__active/var
ID 393 gen 5161 top level 5 path <FS_TREE>/__active/usr
ID 428 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130121-23h44.snap
ID 429 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
ID 430 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
ID 431 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
ID 550 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active_home.20130125-13h38.snap
ID 552 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_var.20130125-13h38.snap
ID 553 gen 5034 top level 5 path <FS_TREE>/__snapshot/__active_usr.20130125-13h38.snap
ID 555 gen 5043 top level 5 path <FS_TREE>/__snapshot/__active.20130125-13h39.snap

--------------030003000202050808050403--
