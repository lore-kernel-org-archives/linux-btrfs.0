Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:49015 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbbAEQec (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 11:34:32 -0500
Message-ID: <54AABD92.9050904@inwind.it>
Date: Mon, 05 Jan 2015 17:36:34 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>,
        Harald Hoyer <harald@redhat.com>
CC: linux-btrfs@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>
Subject: Re: Extend BTRFS_IOC_DEVICES_READY for degraded RAID
References: <54AA5D86.1000503@redhat.com> <20150105113147.GA18350@gardel-login>
In-Reply-To: <20150105113147.GA18350@gardel-login>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-01-05 12:31, Lennart Poettering wrote:
> On Mon, 05.01.15 10:46, Harald Hoyer (harald@redhat.com) wrote:
> 
>> We have BTRFS_IOC_DEVICES_READY to report, if all devices are present, so that
>> a udev rule can report ID_BTRFS_READY and SYSTEMD_READY.
>>
>> I think we need a third state here for a degraded RAID, which can be mounted,
>> but should only after a certain timeout/kernel command line params.
>>
>> We also have to rethink how to handle the udev DB update for the change of the
>> state. incomplete -> degraded -> complete
> 
> I am not convinced that automatically booting degraded arrays would be
> a good idea. Instead, requiring one manual step before booting a
> degraded array sounds OK to me.

I think that a good use case is when the root filesystem is a raid one.

However I don't think that the current architecture is enough flexible to
perform this job:
- mounting a raid filesystem in degraded mode is good for some setup
but it is not the right solution for all: a configure
parameter to allow one behavior or the other is needed:
- the degraded mode should be allowed only if not all the devices are
discovered AND a timeout is expired. This timeout is another variable which 
(IMHO) should be configurable;
- there are different degrees of degraded mode: if the raid is a RAID6,
losing a device would be acceptable; loosing two devices may be 
unacceptable. Again there is no a simple answer; it is needed a 
configurable policy;
- pay attention that the current architecture has some flaws: if a device
disappear during the device discovery, ID_BTRFS_READY returns OK
even if a device is missing.

I proposed a mount.btrfs helper[1], which (IMHO) is a good place for
this kind of job. However I have to point out that both Chris, and David 
aren't fully convinced of this solution. I hope that they could change
opinion.

In conclusion, I see some use case to allow to mount a degraded btrfs
filesystem; however I don't see as viable the idea to enhance the
BTRFS_IOC_DEVICES_READY ioctl. More logic is required.


> 
> Lennart
> 

BR
G.Baroncelli

[1] http://www.spinics.net/lists/linux-btrfs/msg39706.html


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
