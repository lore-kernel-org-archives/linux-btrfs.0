Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:47813 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753726AbdJSO1l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 10:27:41 -0400
Received: by mail-io0-f175.google.com with SMTP id h70so10008796ioi.4
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 07:27:41 -0700 (PDT)
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: Zoltan <zoltan1980@gmail.com>, Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
 <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
 <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
 <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <23015.23766.971947.937708@tree.ty.sabi.co.uk>
 <cc34039f-9e84-c280-c793-1e381cbb2001@gmail.com>
 <23016.34313.523398.532675@tree.ty.sabi.co.uk>
 <CAA-GF5vfbm=fzhRchfTK=w9bHbApUGHeDw7Bgm3awZ1HN6s0jg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0a93b5df-dad5-ff27-b7d3-ac2519892696@gmail.com>
Date: Thu, 19 Oct 2017 10:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAA-GF5vfbm=fzhRchfTK=w9bHbApUGHeDw7Bgm3awZ1HN6s0jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-19 09:48, Zoltan wrote:
> Hi,
> 
> On Thu, Oct 19, 2017 at 1:01 PM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:
> 
>> What the OP was doing was using "unreliable" both for the case
>> where the device "lies" and the case where the device does not
>> "lie" but reports a failure. Both of these are malfunctions in a
>> wide sense:
>>
>>    * The [block] device "lies" as to its status or what it has done.
>>    * The [block] device reports truthfully that an action has failed.
> 
> Thanks for making this point, it made me realize that I had different
> assumption than what you use in your reasoning. I assumed that when
> writes to a USB device fail due to a temporary disconnection, the
> kernel can actually recognize that a write error happened. So are you
> saying that a write error due to USB problems can go completely
> unnoticed? That seems very strange to me; are USB drives really that
> unreliable or is that some software limitation?
It depends on what type of write error happens.

If it's a case where the data gets corrupted on it's way over the bus, 
or the device just drops the write, or you have a bogus storage device 
(this is actually a pretty big issue with flash drives and SD cards, 
check [1], and [2] for more info on this, and [3] for a tool you can use 
to check things), then it generally won't be detected by the kernel, but 
might be by the filesystem driver when it tries to read data.

However, it doesn't go completely undetected if the device disconnects 
(which is where the big issue with BTRFS comes in), the kernel will 
detect the disconnect, issue a bus reset (which will cause performance 
issues with other USB devices on the same controller), and generally 
recover.  However, the disappearance of the device doesn't get 
propagated up to the filesystem correctly, and that is what causes the 
biggest issue with BTRFS.  Because BTRFS just knows writes are suddenly 
failing for some reason, it doesn't try to release the device so that 
things get properly cleaned up in the kernel, and thus when the same 
device reappears (as it will when the disconnect was due to a transient 
bus error, which happens a lot), it shows up as a different device node, 
which gets scanned for filesystems by udev, and BTRFS then gets really 
confused because it now sees 3 (or more) devices for a 2 device 
filesystem.  That final resultant state is what's so dangerous about 
using USB devices with BTRFS right now, as it's pretty much guaranteed 
to result in data corruption.


[1] https://fightflashfraud.wordpress.com/
[2] https://sosfakeflash.wordpress.com/
[3] http://oss.digirati.com.br/f3/
