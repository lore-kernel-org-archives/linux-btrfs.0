Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:60919 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbeA2IyH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 03:54:07 -0500
Date: Mon, 29 Jan 2018 09:54:04 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180129085404.GA2500@polanet.pl>
References: <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 28, 2018 at 17:00:46 -0700, Chris Murphy wrote:

> systemd can't possibly need to know more information than a person
> does in the exact same situation in order to do the right thing. No
> human would wait 10 minutes, let alone literally the heat death of the
> planet for "all devices have appeared" but systemd will. And it does

We're already repeating - systemd waits for THE btrfs-compound-device,
not ALL the block-devices. Just like it 'waits' for someone to plug USB
pendrive in.

It is a btrfs choice to not expose compound device as separate one (like
every other device manager does), it is a btrfs drawback that doesn't
provice anything else except for this IOCTL with it's logic, it is a
btrfs drawback that there is nothing to push assembling into "OK, going
degraded" state, it is btrfs drawback that there are no states...

I've told already - pretend the /dev/sda1 device doesn't
exist until assembled. If this overlapping usage was designed with
'easier mounting' on mind, this is simply bad design.

> that by its own choice, its own policy. That's the complaint. It's
> choosing to do something a person wouldn't do, given identical
> available information.

You are expecting systemd to mix in functions of kernel and udev.
There is NO concept of 'assembled stuff' in systemd AT ALL.
There is NO concept of 'waiting' in udev AT ALL.
If you want to do some crazy interlayer shortcuts just implement btrfsd.

> There's nothing the kernel is doing that's
> telling systemd to wait for goddamn ever.

There's nothing the kernel is doing that's
telling udev there IS a degraded device assembled to be used.

There's nothing a userspace-thing is doing that's
telling udev to mark degraded device as mountable.

There is NO DEVICE to be mounted, so systemd doesn't mount it.

The difference is:

YOU think that sda1 device is ephemeral, as it's covered by sda1 btrfs device that COULD BE mounted.

I think that there is real sda1 device, following Linux rules of system
registration, which CAN be overtaken by ephemeral btrfs-compound device.
Can I mount that thing above sda1 block device? ONLY when it's properly
registered in the system.

Does btrfs-compound-device register in the system? - Yes, but only fully populated.

Just don't expect people will break their code with broken designs just
to overcome your own limitations. If you want systemd to mount degraded
btrfs volume, just MAKE IT REGISTER in the system.

How can btrfs register in the system being degraded? Either by some
userspace daemon handling btrfs volumes states (which are missing from
the kernel), or by some IOCTLs altering in-kernel states.


So for the last time: nobody will break his own code to patch missing
code from other (actively maintained) subsystem.

If you expect degraded mounts, there are 2 choices:

1. implement degraded STATE _some_where_ - udev would handle falling
   back to degraded mount after specified timeout,

2. change this IOCTL to _always_ return 1 - udev would register any
   btrfs device, but you will get random behaviour of mounting
   degraded/populated. But you should expect that since there is no
   concept of any state below.


Actually, this is ridiculous - you expect the degradation to be handled
in some 3rd party software?! In init system? With the only thing you got
is 'degraded' mount option?!
What next - moving MD and LVM logic into systemd?

This is not systemd's job - there are
btrfs-specific kernel cmdline options to be parsed (allowing degraded
volumes), there is tracking of volume health required.
Yes, device-manager needs to track it's components, RAID controller
needs to track minimum required redundancy. It's not only about
mounting. But doing the degraded mounting is easy, only this one
particular ioctl needs to be fixed:

1. counted devices<all	=> not_ready

2. counted devices<all BUT
- 'go degraded' received from userspace or kernel cmdline OR
- volume IS mounted and doesn't report errors (i.e. mount -o degraded
  DID succeeded)	=> ok_degraded

3. counted devices==all => ok


If btrfs DISTINGUISHES these two states, systemd would be able to use them.


You might ask why this is important for the state to be kept inside some
btrfs-related stuff, like kernel or btrfsd, while the systemd timer
could do the same and 'just mount degraded'. The answear is simple:
systemd.timer is just a sane default CONFIGURATION, that can be EASILY
changed by system administrator. But somewhere, sometime, someone would
have a NEED for totally different set of rules for handling degraded
volumes, just like MD or LVM does. This would be totally irresponsible
to hardcode any mount-degraded rule inside systemd itself.

That is exactly why this must go through the udev - udev is responsible
for handling devices in Linux world. How can I register btrfs device
in udev, since it's overlapping the block device? I can't - the ioctl
is one-way, doesn't accept any userspace feedback.

-- 
Tomasz Pala <gotar@pld-linux.org>
