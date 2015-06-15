Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33.italiaonline.it ([212.48.25.161]:51554 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932116AbbFORXz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 13:23:55 -0400
Message-ID: <557F0A26.8070308@inwind.it>
Date: Mon, 15 Jun 2015 19:23:50 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>
CC: Anand Jain <anand.jain@oracle.com>, Andrei Borzenkov <arvidjaar@gmail.com>,
        systemd-devel@lists.freedesktop.org, dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [survey] BTRFS_IOC_DEVICES_READY return status
References: <557ADBAE.9040407@oracle.com> <20150612210453.3dee4563@opensuse.site> <557B3C32.9030707@inwind.it> <557BF979.9040106@oracle.com> <557C479F.2070403@libero.it> <20150615104618.GB25616@gardel-login>
In-Reply-To: <20150615104618.GB25616@gardel-login>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-15 12:46, Lennart Poettering wrote:
> On Sat, 13.06.15 17:09, Goffredo Baroncelli (kreijack@libero.it) wrote:
> 
>>> Further, the problem will be more intense in this eg. if you use dd
>>> and copy device A to device B. After you mount device A, by just
>>> providing device B in the above two commands you could let kernel
>>> update the device path, again all the IO (since device is mounted)
>>> are still going to the device A (not B), but /proc/self/mounts and
>>> 'btrfs fi show' shows it as device B (not A).
>>>
>>> Its a bug. very tricky to fix.
>>
>> In the past [*] I proposed a mount.btrfs helper . I tried to move the logic outside the kernel.
>> I think that the problem is that we try to manage all these cases
>> from a device point of view: when a device appears, we register the
>> device and we try to mount the filesystem... This works very well
>> when there is 1-volume filesystem. For the other cases there is a
>> mess between the different layers:
> 
>> - kernel
>> - udev/systemd
>> - initrd logic
>>
>> My attempt followed a different idea: the mount helper waits the
>> devices if needed, or if it is the case it mounts the filesystem in
>> degraded mode. All devices are passed as mount arguments
>> (--device=/dev/sdX), there is no a device registration: this avoids
>> all these problems.
> 
> Hmm, no. /bin/mount should not block for devices. That's generally
> incompatible with how the tool is used, and in particular from
> systemd. We would not make use for such a scheme in
> systemd. /bin/mount should always be short-running.

Apart systemd, which are these incompatibilities ? 

> 
> I am pretty sure that if such automatic degraded mounting should be
> supported, then this should be done with some background storage
> daemon that alters the effect of the READY ioctl somehow after the
> timeout, and then retriggers the devcies so that systemd takes
> note. (or, alternatively: such a scheme could even be implemented all
> in kernel, based on some configurable kernel setting...)

I recognize that this solution provides the maximum compatibility with the current implementation. However it seems too complex to me. Re-trigging a devices seems to me more a workaround than a solution.

Could a generator do this job ? I.e. this generator (or storage daemon) waits that all (or enough) devices are appeared, then it creates a .mount unit: do you think that it is doable ?


> 
> Lennart
> 
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
