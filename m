Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37904 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbdGUOgP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 10:36:15 -0400
Received: by mail-wm0-f48.google.com with SMTP id w191so15786853wmw.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 07:36:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170717155400.GN2866@twin.jikos.cz>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
 <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com> <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
 <20170717155400.GN2866@twin.jikos.cz>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 21 Jul 2017 08:36:13 -0600
Message-ID: <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
Subject: Re: btrfs device ready purpose
To: David Sterba <dsterba@suse.cz>, Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 17, 2017 at 9:54 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Jul 07, 2017 at 11:40:04AM -0600, Chris Murphy wrote:
>> On Fri, Jul 7, 2017 at 10:59 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> > 07.07.2017 19:42, Chris Murphy пишет:
>> >> I'm digging through piles of list emails and not really finding an
>> >> answer to this. Maybe it's Friday and I'm just confused...
>> >>
>> >>
>> >> [root@f26s ~]# btrfs device ready /dev/sda1
>> >> [root@f26s ~]# echo $?
>> >> 0
>> >> [root@f26s ~]# btrfs device ready /dev/mapper/vg-1
>> >> [root@f26s ~]# echo $?
>> >> 0
>> >>
>> >>
>> >> /dev/sda1 is a single device btrfs and it is present, 'btrfs fi show' finds it.
>> >> /dev/mapper/vg-1 is one member of a two device Btrfs volume, the
>> >> missing device is /dev/mapper/vg-2 and 'btrfs fi show' sees 1 but not
>> >> 2 and says a device is missing.
>> >>
>> >> And yet the ready command completes and the exit code is the same, and
>> >> I just don't understand the purpose of this command. The man page says
>> >> "wait" but I don't see any waiting, so at the very least we probably
>> >> need to come up with a more descriptive man page description.
>> >>
>> >
>> > Here on Ubuntu 16.04.2 man page says
>> >
>> >        ready <device>
>> >            Check device to see if it has all of it’s devices in cache
>> > for mounting.
>>
>> 4.11 man page says for 'btrfs device ready'
>> Wait until all devices of a multiple-device filesystem are scanned and
>> registered within the kernel module.
>>
>> Not sure when it was updated.
>>
>>
>> >
>> > Nothing about "wait".
>> >
>> > btrfs device ready is only useful during startup. The only check it does
>> > - whether kernel knows about all devices or not. It is really intended
>> > to be used from udev rule to delay attempt to mount filesystem until all
>> > devices have been seen. And it is only useful with systemd as it is the
>> > only program that actually pays attention to it.
>>
>> OK that make sense. I'm just not used to the convention where a user
>> space tool does literally nothing for the user, and also has a man
>> page entry as if it is for users. And I get that developers are users
>> too, it just seems like an odd convention but whatever.
>
> The command is just a simple wrapper around the DEVICES_READY ioctl, but
> now that systemd has it's own wrapper tool, there are probably no users
> of that subcommand in 'btrfs' tool itself. We can enhance the
> documentation to state the expected purpose and that normal users can
> ignore it.

What is the expected purpose? It flat out does not seem to work at
all. It doesn't wait when devices are missing, as the man description
says. And echo ? returns a 0 instead of 1. I'd expect the exit code is
0 to mean "yes all devices are ready", and exit code 1 "some devices
not ready". But right now, I get the same result no matter what.

So it seems to me it needs to be fixed in user space or it just needs
to be removed.

Where this stems from, is this 'help wanted' issue
https://github.com/storaged-project/libblockdev/issues/244

The gist is that libblockdev needs to know whether a device can be
mounted successfully without -o degraded, and that's basically what
BTRFS_IOC_DEVICES_READY does. But at least in startup, the udev usage
of this ioctl causes a hang. Literally systemd just sits there and
will not try to mount such a volume, and it waits indefinitely, which
is itself suboptimal. I think it'd be better to return a code.
0: is complete, degraded not required
1: is incomplete, degraded should mount it
2: is incomplete, degraded won't mount it

Something like that.



-- 
Chris Murphy
