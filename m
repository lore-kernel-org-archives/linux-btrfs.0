Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53264 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbbIVMvd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 08:51:33 -0400
Subject: Re: RAID1 storage server won't boot with one disk missing
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Erkki Seppala <flux-btrfs@inside.org>, linux-btrfs@vger.kernel.org
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
 <55FAD9CC.5060206@oracle.com> <pan$5cdb2$42505f02$e2b552bf$4a4e51e@cox.net>
 <CA+WRLO94UekKmT1cy3+t4+pHSCMj=HRoEF4oqtJDimS=EWnbhA@mail.gmail.com>
 <m49fv27cxyc.fsf@coffee.modeemi.fi> <56013C3C.6010005@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56014ECA.1050002@gmx.com>
Date: Tue, 22 Sep 2015 20:51:22 +0800
MIME-Version: 1.0
In-Reply-To: <56013C3C.6010005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月22日 19:32, Austin S Hemmelgarn 写道:
> On 2015-09-21 16:35, Erkki Seppala wrote:
>> Gareth Pye <gareth@cerberos.id.au> writes:
>>
>>> People tend to be looking at BTRFS for a guarantee that data doesn't
>>> die when hardware does. Defaults that defeat that shouldn't be used.
>>
>> However, data is no more in danger at startup than it is at the moment
>> when btrfs notices a drive dropping, yet it permits IO to proceed. Is
>> there not a contradiction?
>>
>> Personally I don't see why system startup should be a special case, in
>> particular as it can be very stressful situation to recover from when
>> RAID is there just to avoid the immediate reaction when hardware breaks;
>> and when in practice you can do the recovery while the system is running
>> in systems where short service interruptions matter.
>>
> The difference is that we have code to detect a device not being present
> at mount, we don't have code (yet) to detect it dropping on a mounted
> filesystem.  Why having proper detection for a device disappearing does
> not appear to be a priority, I have no idea, but that is a separate
> issue from mount behavior.
>

Sorry for jumping out for such a sudden, but I submitted a patchset 
which is somewhat related to such degraded case.

[PATCH 0/5] Btrfs: Per-chunk degradable check

With that patchset, btrfs can do quite good check for degradable and 
mount/remount and even mounted time.
(Return value of btrfs_check_degradable() will indicate all devices OK, 
or not all OK but degradable, or not writable degradable)

And with that patchset, it's quite easy to add support for btrfs to 
sliently switch to degraded mount option if possible.
(Along with other improvement of course)


For the original feedback from end user, personally I understand users 
who don't want to add degraded mount option manually when a device 
fails, nor don't want to add a permanent mount option info fstab, just 
in case of failure.

So personally, I'd like to add a new mount option "nodegraded", to allow 
user to force no degraded mount.
And if neither "degraded" nor "nondegraded" is given, let btrfs to 
automatically switch to degraded if possible.

And it should also still be able to info user, either by the easily 
igored dmesg, or easier to notice mount option change.

How about this method to solve the problem?

Thanks,
Qu
