Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35816 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965604AbcBCWT3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 17:19:29 -0500
Received: by mail-io0-f173.google.com with SMTP id d63so72756264ioj.2
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Feb 2016 14:19:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQgXRULpEG4HkOfhsB658kQS_jo2iw-xsY9zNpB1yDFoQ@mail.gmail.com>
References: <56AFCEC3.9050803@friedels.name>
	<CAJCQCtRox+q5u902iwA3YL2yvEP+9_=02HJzpZU6TWZ1R9V+Qg@mail.gmail.com>
	<56B126DD.90009@friedels.name>
	<CAJCQCtT0S6CiErJYUju5D5-q0s-KBXuYkXxMURjppZcgURP4wA@mail.gmail.com>
	<56B24393.9030108@friedels.name>
	<CAJCQCtQgXRULpEG4HkOfhsB658kQS_jo2iw-xsY9zNpB1yDFoQ@mail.gmail.com>
Date: Wed, 3 Feb 2016 15:19:28 -0700
Message-ID: <CAJCQCtTth7gKnCKsuJhaJ2jvYxzgZ76+gqQZOE2q7HJANXPQag@mail.gmail.com>
Subject: Re: booting from BTRFS works only with one device in the pool
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hendrik Friedel <hendrik@friedels.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 3, 2016 at 1:30 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Feb 3, 2016 at 11:14 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
>> Sorry, I missed this:
>>> What do you get for rpm -q grub2
>> grub2-2.02-0.34.el7.centos.x86_64
>>
>
> Weird. I was not able to reproduce the problem with CentOS 7.0 doing
> the following in virt-manager with two qcow2s backing /dev/vda and
> /dev/vdb.
>
> 1. Install only to /dev/vda using custom partitioning, partition
> scheme is btrfs.
> 2. Reboot.
> 3. Install btrfs-progs-4.4-1.fc23.x86_64.rpm
> 4. Install kernel-ml-4.4.1-1.el7.elrepo.x86_64.rpm
> ## I did those installs separately to make sure the newer progs goes
> in the initramfs that's created when the newer kernel is installed;
> it's just a time savings is all.
> 5. Reboot
> 6. btrfs dev add /dev/vdb /
> 7. Reboot
> 8. yum upgrade
> ## at this point both devices have chunks
> 9. Reboot
> 10. btrfs balance start /
> ## now only vdb has chunks (due to how single balance allocator works,
> and vdb is bigger than vda2)
> 11. Reboot.
> ## still works
>
> Of course with a VM it's better to just grow the backing device, and
> then something like 'btrfs fi resize max /' rather than have two
> devices. But on a real system, you'd have two devices (with the caveat
> that this is more fragile a setup than a single device because of
> course if either device dies, the whole Btrfs volume implodes).
>
> I can try it without any updates and see if it works....

1. Install CentOS 7.0 to vda
2. reboot
3. btrfs dev add /dev/vdb /
4. reboot
## works
5. btrfs balance start /
6. reboot
## works

Same thing when starting with CentOS 7.2 media.

This is a NAS product using CentOS 7.2? My only guess is they've
changed something broke this.

-- 
Chris Murphy
