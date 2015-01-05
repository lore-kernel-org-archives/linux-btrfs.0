Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:47984 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884AbbAERzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 12:55:18 -0500
Message-ID: <54AAD081.9010206@inwind.it>
Date: Mon, 05 Jan 2015 18:57:21 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Harald Hoyer <harald@redhat.com>
CC: linux-btrfs@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>
Subject: Re: Extend BTRFS_IOC_DEVICES_READY for degraded RAID
References: <54AA5D86.1000503@redhat.com> <20150105113147.GA18350@gardel-login> <54AABD92.9050904@inwind.it> <54AAC3AD.3010802@gmail.com>
In-Reply-To: <54AAC3AD.3010802@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-01-05 18:02, Austin S Hemmelgarn wrote:
> On 2015-01-05 11:36, Goffredo Baroncelli wrote:
>> On 2015-01-05 12:31, Lennart Poettering wrote:
>>> On Mon, 05.01.15 10:46, Harald Hoyer (harald@redhat.com) wrote:
>>> 
>>>> We have BTRFS_IOC_DEVICES_READY to report, if all devices are
>>>> present, so that a udev rule can report ID_BTRFS_READY and
>>>> SYSTEMD_READY.
>>>> 
>>>> I think we need a third state here for a degraded RAID, which
>>>> can be mounted, but should only after a certain timeout/kernel
>>>> command line params.
>>>> 
>>>> We also have to rethink how to handle the udev DB update for
>>>> the change of the state. incomplete -> degraded -> complete
>>> 
>>> I am not convinced that automatically booting degraded arrays
>>> would be a good idea. Instead, requiring one manual step before
>>> booting a degraded array sounds OK to me.
>> 
>> I think that a good use case is when the root filesystem is a raid
>> one.
>> 
>> However I don't think that the current architecture is enough
>> flexible to perform this job: 
> - mounting a raid filesystem in
>> degraded mode is good for some setup but it is not the right
>> solution for all: a configure parameter to allow one behavior or
>> the other is needed: 
> - the degraded mode should be allowed only if
>> not all the devices are discovered AND a timeout is expired. This
>> timeout is another variable which (IMHO) should be configurable;
> These first 2 points can be easily handled with some simple logic in
> userspace without needing a mount helper.

If you implement it in a mount.btrfs, you have this logic available 
for all cases, not only for mounting the root fs

>> - there are different degrees of degraded mode: if the raid is a
>> RAID6, losing a device would be acceptable; loosing two devices may
>> be unacceptable. Again there is no a simple answer; it is needed a 
>> configurable policy;

> This can be solved by providing 2 new return values for the
> BBTRFS_IOC_DEVICES_READY ioctl (instead of just one), one for for
> arrays that are in such a state that losing another disk will almost
> certainly cause data loss (ie, a RAID6 with two missing devices, or a
> BTRFS raid1/10 with one missing device), and one for an array
> (theoretically) won't lose any data if one more device drops out (ie,
> a RAID6 (or something with higher parity) with one missing disk)

This is a detail; the point is that it is needed to implement this policy.
I am suggesting to not "spread" this logic in too many subsystem (kernel,
systemd, udev, scripts......).

BTRFS couples a filesystem with a devices manager. This exposes a lot of 
new problems and options. I am suggesting to create a "tool" to manage all
these new problems/options. This tool is (of course) btrfs specific, and I
am convinced that a good place to start is a mount.btrfs helper.


>, and
> then provide a module parameter to allow forcing the kernel to report
> one or the other.

this policy should be different by mount point: if the machine is a
remote one, I can allow to mount the root of filesystem even in degraded 
mode to start some "recovery"; but a more conservative policy may be 
applied to the other ones fss.

This is one of the reason to let the policy out from the kernel.

>> - pay attention that the current architecture has some flaws: if a
>> device disappear during the device discovery, ID_BTRFS_READY
>> returns OK even if a device is missing.

> Point 4 would require for some kind of continuous
> scanning/notification (and therefore add more bulk, the lack of which
> is in my opinion one of the biggest advantages of BTRFS over ZFS),
> and even then there will always be the possibility that a device
> drops out between you calling the ioctl and trying to mount the
> filesystem.

If you shorter the windows, then less likely it may happen.



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
