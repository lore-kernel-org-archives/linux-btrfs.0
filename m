Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:48804 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933309AbdJQTTP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 15:19:15 -0400
Received: by mail-it0-f65.google.com with SMTP id c3so3852556itc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 12:19:14 -0700 (PDT)
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: Adam Borowski <kilobyte@angband.pl>
Cc: Zoltan <zoltan1980@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
 <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
 <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
 <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
 <20171017170626.amfrohfyqlujdueu@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1d5e9875-1c1e-f67e-1f5b-0741555d9517@gmail.com>
Date: Tue, 17 Oct 2017 15:19:09 -0400
MIME-Version: 1.0
In-Reply-To: <20171017170626.amfrohfyqlujdueu@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-17 13:06, Adam Borowski wrote:
> On Tue, Oct 17, 2017 at 08:40:20AM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-10-17 07:42, Zoltan wrote:
>>> On Tue, Oct 17, 2017 at 1:26 PM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>
>>>> I forget sometimes that people insist on storing large volumes of data on
>>>> unreliable storage...
>>>
>>> In my opinion the unreliability of the storage is the exact reason for
>>> wanting to use raid1. And I think any problem one encounters with an
>>> unreliable disk can likely happen with more reliable ones as well,
>>> only less frequently, so if I don't feel comfortable using raid1 on an
>>> unreliable medium then I wouldn't trust it on a more reliable one
>>> either.
> 
>> The thing is that you need some minimum degree of reliability in the other
>> components in the storage stack for it to be viable to use any given storage
>> technology.  If you don't meet that minimum degree of reliability, then you
>> can't count on the reliability guarantees of the storage technology.
> 
> The thing is, reliability guarantees required vary WILDLY depending on your
> particular use cases.  On one hand, there's "even an one-minute downtime
> would cost us mucho $$$s, can't have that!" -- on the other, "it died?
> Okay, we got backups, lemme restore it after the weekend".
Yes, but if you are in the second case, you arguably don't need 
replication, and would be better served by improving the reliability of 
your underlying storage stack than trying to work around it's problems. 
Even in that case, your overall reliability is still constrained by the 
least reliable component (in more idiomatic terms 'a chain is only as 
strong as it's weakest link').

Using replication with a reliable device and a questionable device is 
essentially the same as trying to add redundancy to a machine by adding 
an extra linkage that doesn't always work and can get in the way of the 
main linkage it's supposed to be protecting from failure.  Yes, it will 
work most of the time, but the system is going to be less reliable than 
it is without the 'redundancy'.
> 
> Lemme tell you a btrfs blockdev disconnects story.
> I have an Odroid-U2, a cheap ARM SoC that, despite being 5 years old and
> costing mere $79 (+$89 eMMC...) still beats the performance of much newer
> SoCs that have far better theoretical specs, including subsequent Odroids.
> After ~1.5 year of CPU-bound stress tests for one program, I switched this
> machine to doing Debian package rebuilds, 24/7/365¼, for QA purposes.
> Being a moron, I did not realize until pretty late that high parallelism to
> keep all cores utilized is still a net performance loss when a memory-hungry
> package goes into a swappeathon, even despite the latter being fairly rare.
> Thus, I can say disk utilization was pretty much 100%, with almost as much
> writing as reading.  The eMMC card endured all of this until very recently
> (nowadays it sadly throws errors from time to time).
> 
> Thus, I switched the machine to NBD (albeit it sucks on 100Mbit eth).  Alas,
> the network driver allocates memory with GFP_NOIO which causes NBD
> disconnects (somehow, this doesn't ever happen on swap where GFP_NOIO would
> be obvious but on regular filesystem where throwing out userspace memory is
> safe).  The disconnects happen around once per week.
Somewhat off-topic, but you might try looking at ATAoE as an 
alternative, it's more reliable in my experience (if you've got a 
reliable network), gives better performance (there's less protocol 
overhead than NBD, and it runs on top of layer 2 instead of layer 4), 
and you can even boot with an ATAoE device as root without needing an 
initramfs if you have network auto-configuration in the kernel.  The 
generic server-side component is called 'vblade', and you actually don't 
need anything on the client side other than the `aoe` kernel module 
(loading the module scans for devices automatically, and you can easily 
manage things through the various nodes it creates in /dev).
> 
> It's a single-device filesystem, thus disconnects are obviously fatal.  But,
> they never caused even a single bit of damage (as scrub goes), thus proving
> btrfs handles this kind of disconnects well.  Unlike times past, the kernel
> doesn't get confused thus no reboot is needed, merely an unmount, "service
> nbd-client restart", mount, restart the rebuild jobs.
That's expected behavior though.  _Single_ device BTRFS has nothing to 
get out of sync most of the time, the only time there's any possibility 
of an issue is when you die after writing the first copy of a block 
that's in a dup profile chunk, but even that is not very likely to cause 
problems (you'll just lose at most the last <commit-time> worth of 
data).  The moment you add another device though, that simplicity goes 
out the window.
> 
> I also can recreate this filesystem and the build environment on it with
> just a few commands, thus, unlike /, there's no need for backups.  But I
> had no need to recreate it yet.
> 
> This is single-device not RAID5, but it's a good example for an use case
> where an unreliable storage medium is acceptable (even if the GFP_NOIO issue
> is still worth fixing).
Again, single device mode with BTRFS handles it just fine (at least, it 
handles it just as well as any other filesystem does).  Multi-device 
BTRFS is the issue here.
