Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33110 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756072Ab3LIUVJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 15:21:09 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can't remove empty directory after kernel panic, no errors in dmesg
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CADdntNuhrD8Dr3qSDXN3JbdJK8SFwmj_r5o0_k30EsfjUOzkGg@mail.gmail.com>
Date: Mon, 9 Dec 2013 13:21:06 -0700
Cc: Niklas Schnelle <niklas.schnelle@gmail.com>
Message-Id: <5736588E-4E60-4D2A-9C7B-2B70840A3441@colorremedies.com>
References: <CADdntNuHYRAK_kcDJf1bnJeuTmc=CRx7TeyJPv4hsW9NPyd6mg@mail.gmail.com> <A46650B8-A3A8-467E-B1D2-CACB06833B1C@colorremedies.com> <CADdntNuhrD8Dr3qSDXN3JbdJK8SFwmj_r5o0_k30EsfjUOzkGg@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 9, 2013, at 11:54 AM, Niklas Schnelle <niklas.schnelle@gmail.com> wrote:

> On Sat, Dec 7, 2013 at 11:30 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> 
>> On Dec 7, 2013, at 3:36 AM, Niklas Schnelle <niklas.schnelle@gmail.com> wrote:
>> 
>>> Hi List,
>>> 
>>> so first the basics. I'm running Arch Linux with 3.13-rc2, btrfs-progs
>>> 0.20rc1.3-2 from the repo and I'm using a SSD.
>> 
>> I don't see a dmesg, which should contain some information if there are correct or uncorrected problems at mount time.
>> 
>> The first thing to try is the mount time recovery option. It's interesting considering how to do this for rootfs on btrfs, but I think simplest is to just add it to fstab and reboot. Then remove it. Again, check dmesg to see how the recovery went, and then check to see if you have the same problems.
>> 
>> Another way to do it is to change the kernel parameters editing the e.g. GRUB menu entry at boot time. Change the ro to rw, and add recovery to rootflags=. So if the current one is rootflags=subvol=root, then change to rootflags=recovery,subvol=root. This acts as a one time thing.
>> 
>> Ideally I'd like to see the kernel spit out something systemd could use that would cause it to generate a service to remount using recovery (and if multiple devices, possibly degraded, and if either of those fail, to then generate a remount service for ro,recovery and fallback to emergency.target). That way more of this can be done automagically.
>> 
>> So try the recovery mount option first. Before you try btrfs check (or btrfsck), you should upgrade your btrfs-progs to something more recent. v3.12 is current and is what distros should build as of kernel 3.12.

> As it says in the threads subject there were no errors in dmesg. I
> tried the recovery mount option now but also
> got no notable output in dmesg. Any idea how to procede? By the since
> I was able to delete the undeleteable directory
> after running btrfs check --repair (freshly compiled git version) my
> filesystem has shown no odd behavior, though
> obviously I'm not really trusting it as there were errors in btrfs
> check when running it again after the repair.

Since you've made some changes, I think we need an update on what errors you're still receiving. I'm a bit baffled that mounting rw,recovery shows nothing in dmesg, yet you get errors with btrfs check. Maybe someone else has some ideas how to get more info. Maybe add kernel parameters 'debug ignore_loglevel' ?


Chris Murphy