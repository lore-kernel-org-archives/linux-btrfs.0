Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57917 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbaLEPdA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 10:33:00 -0500
Date: Fri, 5 Dec 2014 10:32:46 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
To: Dimitri John Ledkov <xnox@debian.org>
CC: cwillu <cwillu@cwillu.com>, "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Message-ID: <1417793566.21214.11@mail.thefacebook.com>
In-Reply-To: <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
References: <547B5724.1060507@libero.it>
	<CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
	<CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
	<CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 5:57 PM, Dimitri John Ledkov <xnox@debian.org> 
wrote:
> On 30 November 2014 at 22:31, cwillu <cwillu@cwillu.com> wrote:
>> 
>>  In ubuntu, the initfs runs a btrfs dev scan, which should catch
>>  anything that would be missed there.
>> 
> 
> I'm sorry, udev rule(s) is not sufficient in the initramfs-less case,
> as outlined.
> 
> In case of booting with initramfs, indeed, both Debian & Ubuntu
> include snippets there to run btrfs scan.

In an initramfs-less system, the root filesystem mount is done by the 
kernel, without calling any mount.btrfs.  The mount helper has all the 
same problems that calling btrfs dev scan does, it's just being run by 
mount.

I definitely agree that assembling the filesystem from userland is 
somewhat awkward, and people that don't want initrds end up needing to 
jump through hoops to get things done.

But, the tools we have to avoid the hoops are initrds and udev, and I'd 
much rather spend time fixing filesystem bugs than recreating those 
tools.  If people are having trouble with udev, or having trouble with 
tools in the initrd, lets contribute fixes to those projects instead.

For people that really really don't want initrds, pass the devices on 
the command line.  If that isn't working, we'll fix it, but if you 
really want a scan, please try an initrd.  You can even make one 
without any kernel modules, and then you don't have to recreate it 
until you want to update the userland in your initrd.

-chris



