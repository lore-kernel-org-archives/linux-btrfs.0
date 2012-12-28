Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:59959 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2L1BNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 20:13:46 -0500
Received: from [199.115.105.252] (helo=mail.parallels.com)
	by mx2.parallels.com with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <dolenin@parallels.com>)
	id 1ToOW9-0003cR-LL
	for linux-btrfs@vger.kernel.org; Thu, 27 Dec 2012 20:13:45 -0500
Message-ID: <50DCF245.20705@parallels.com>
Date: Fri, 28 Dec 2012 10:13:41 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: problems with dracut mounting subvols
References: <5FA2C0D0-740D-4425-A099-46382311E2A3@colorremedies.com>
In-Reply-To: <5FA2C0D0-740D-4425-A099-46382311E2A3@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I've just tried putting usr in a subvol. Installation proceeds normally, no errors, but I'm dropped to a dracut prompt which indicates mount of /usr failed. dmesg follows:
>
>
> [   14.025215] systemd[1]: Starting dracut initqueue hook...
> [   14.077890] Btrfs loaded
> [   14.129987] device label fedora_f18v devid 1 transid 31 /dev/sda1
> [   14.313607] device label fedora_f18v devid 1 transid 31 /dev/sda1
> [   14.446523] systemd[1]: Started Show Plymouth Boot Screen.
> [[1;32m  OK  [[   14.533662] btrfs: disk space caching is enabled
> 0m] Started Show Plymouth Boot Screen.
> [   14.534404] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
> [   14.534886] systemd[1]: Starting Forward Password Requests to Plymouth Directory Watch.
> [   14.535001] systemd[1]: Started Forward Password Requests to Plymouth Directory Watch.
> [   14.535067] systemd[1]: Starting Basic System.
> [[1;32m  OK  [0m] Reached target Basic System.[   15.053733] systemd[1]: Reached target Basic System.
> [   15.094806] device label fedora_f18v devid 1 transid 31 /dev/sda1
> [   15.251736] btrfs: disk space caching is enabled
> [   15.430129] systemd[1]: Started dracut initqueue hook.
> [   15.574280] systemd[1]: Starting dracut pre-pivot and cleanup hook...
> [   15.735181] device label fedora_f18v devid 1 transid 31 /dev/sda1
> [   15.876950] btrfs: 'root' is not a valid subvolume
> dracut-pre-pivot[228]: Warning: Mounting /usr to /sysroot/usr failed
> dracut-pre-pivot[228]: Warning: *** Dropping you to a shell; the system will continue
> dracut-pre-pivot[228]: Warning: *** when you leave the shell.
> dracut-pre-pivot[228]: Warning:
> [[1;32m  OK  [0m] Started Show Plymouth Boot Screen.
> [[1;32m  OK  [0m] Reached target Basic System.
> dracut-pre-pivot[228]: Warning: Mounting /usr to /sysroot/usr failed
> dracut-pre-pivot[228]: Warning: *** Dropping you to a shell; the system will continue
> dracut-pre-pivot[228]: Warning: *** when you leave the shell.
> dracut-pre-pivot[228]: Warning:
> [   16.314849] systemd[1]: Starting Emergency Shell…
>
>
> After a bit of snooping I found the dracut fstab suspicious:
>
>
> dracut:/# cat /etc/fstab
> /dev/disk/by-uuid/64383cfe-c31d-4d25-97c4-4e6b7e788b26 /sysroot btrfs subvol=root,ro 0
> /dev/disk/by-uuid/64383cfe-c31d-4d25-97c4-4e6b7e788b26 /sysroot/usr btrfs subvol=usr,subvol=root,ro 1 2
>
>
> Two mount options, mounting two subvols to the same mount point? Seems problematic.  But even when I try what I think is correct from a dracut prompt:
>
>
> dracut:/# mount -o subvol=usr /dev/sda1 /sysroot/usr
> mount: /dev/sda1 is already mounted or /sysroot/usr busy
>         /dev/sda1 is already mounted on /sysroot
>
>
> The only sda device mounted at this time is the root subvol to /sysroot. So the additional question is if dracut maybe has a problem with multiple physical devices being mounted more than once, which is what happens when mounting multiple subvols? This is dracut-024-17.git20121220.fc18.
>
> Seems like maybe two bugs?



> /dev/disk/by-uuid/64383cfe-c31d-4d25-97c4-4e6b7e788b26 /sysroot/usr btrfs subvol=usr,subvol=root,ro 1 2

I'd say that the problem is definitely with this line having two 
subvolumes listed.
Maybe you should boot from a live CD, mount your subvolid=1 and check 
out what subvolumes you really have in there. And then re-write fstab 
manually.
If you have /sysroot subvolume, you can create /sysroot/usr as a child 
subvolume and you won't even need then to specify /sysroot/usr in your 
fstab because it will be mounted automatically when the parent subvolume 
gets mounted.
