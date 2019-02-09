Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA4CC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 12:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D78E20863
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 12:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dirtcellar.net header.i=@dirtcellar.net header.b="dErYjDcc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfBIMNu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 07:13:50 -0500
Received: from smtp.domeneshop.no ([194.63.252.55]:35861 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfBIMNt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 07:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dirtcellar.net; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Reply-To; bh=AJ5NCZljd+L0Nh+d8ueo6H7nDjemtH4POyFLMIjO4eQ=;
        b=dErYjDcc61fsZ8tHvVFR4efM9mhiAk1xfCjJtRwyIGiWAq8qagjVKEx62D01wq6mP5kIb8QQRHyOIatN/QoW5S8shF/JKukdCAS2IQwbYtMA9LLk8ZAjF5BVB7SVRuJSHTO0cJWkn5alNV4t+QuNO/UCJZr0xVH74H8rr2K9D/zq/ZyPM3U//vgNG3e9+deITJsyBpXQ6OjTwO1zTkQhcjBLzQt8KFftebC5FrknfkSmmeCj7aW1Ws+4bARnhy/uiT1A9ZYa11ayo9abNAcERe+iHgK9wuCqwoo32CRPoF8bUQiEEQ9E0jUeP2TM/Zb4WAIizgSSDv37pYiJ/KZy+g==;
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:3107 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1gsRVx-0003s4-Gy; Sat, 09 Feb 2019 13:13:45 +0100
Reply-To: waxhead@dirtcellar.net
Subject: Re: btrfs as / filesystem in RAID1
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Stefan K <shadow_7@gmx.net>, linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
 <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
 <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net>
 <f41063e8-b9b1-f929-7954-8a96e673bd2e@gmail.com>
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <f67c6a69-4fc8-e33a-543e-9b97adf54438@dirtcellar.net>
Date:   Sat, 9 Feb 2019 13:13:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <f41063e8-b9b1-f929-7954-8a96e673bd2e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



Austin S. Hemmelgarn wrote:
> On 2019-02-08 13:10, waxhead wrote:
>> Austin S. Hemmelgarn wrote:
>>> On 2019-02-07 13:53, waxhead wrote:
>>>>
>>>>
>>>> Austin S. Hemmelgarn wrote:
>>>
>> So why do BTRFS hurry to mount itself even if devices are missing? and 
>> if BTRFS still can mount , why whould it blindly accept a non-existing 
>> disk to take part of the pool?!
> It doesn't unless you tell it to., and that behavior is exactly what I'm 
> arguing against making the default here.
Understood, but that is not quite what I meant - let me rephrase...
If BTRFS still can't mount, why would it blindly accept a previously 
non-existing disk to take part of the pool?! E.g. if you have "disk" A+B 
and suddenly at one boot B is not there. Now you have only A and one 
would think that A should register that B has been missing. Now on the 
next boot you have AB , in which case B is likely to have diverged from 
A since A has been mounted without B present - so even if both devices 
are present why would btrfs blindly accept that both A+B are good to go 
even if it should be perfectly possible to register in A that B was 
gone. And if you have B without A it should be the same story right?

>>
>>> Realistically, we can only safely recover from divergence correctly 
>>> if we can prove that all devices are true prior states of the current 
>>> highest generation, which is not currently possible to do reliably 
>>> because of how BTRFS operates.
>>>
>> So what you are saying is that the generation number does not 
>> represent a true frozen state of the filesystem at that point?
> It does _only_ for those devices which were present at the time of the 
> commit that incremented it.
> 
So in other words devices that are not present can easily be marked / 
defined as such at a later time?

> As an example (don't do this with any BTRFS volume you care about, it 
> will break it), take a BTRFS volume with two devices configured for 
> raid1.  Mount the volume with only one of the devices present, issue a 
> single write to it, then unmounted it.  Now do the same with only the 
> other device.  Both devices should show the same generation number right 
> now (but it should be one higher than when you started), but the 
> generation number on each device refers to a different volume state.
>>
>>> Also, LVM and MD have the exact same issue, it's just not as 
>>> significant because they re-add and re-sync missing devices 
>>> automatically when they reappear, which makes such split-brain 
>>> scenarios much less likely.
>> Which means marking the entire device as invalid, then re-adding it 
>> from scratch more or less...
> Actually, it doesn't.
> 
> For LVM and MD, they track what regions of the remaining device have 
> changed, and sync only those regions when the missing device comes back.
> 
For MD , if you have the bitmap enabled yes...

> For BTRFS, the same thing happens implicitly because of the COW 
> structure, and you can manually reproduce similar behavior to LVM or MD 
> by scrubbing the volume and then using balance with the 'soft' filter to 
> ensure all the chunks are the correct type.
> 
Understood.

>> Why does systemd concern itself about what devices btrfs consist of. 
>> Please educate me, I am curious.
> For the same reason that it concerns itself with what devices make up a 
> LVM volume or an MD array.  In essence, it comes down to a couple of 
> specific things:
> 
> * It is almost always preferable to delay boot-up while waiting for a 
> missing device to reappear than it is to start using a volume that 
> depends on it while it's missing.  The overall impact on the system from 
> taking a few seconds longer to boot is generally less than the impact of 
> having to resync the device when it reappears while the system is still 
> booting up.
> 
> * Systemd allows mounts to not block the system booting while still 
> allowing certain services to depend on those mounts being active.  This 
> is extremely useful for remote management reasons, and is actually 
> supported by most service managers these days.  Systemd extends this all 
> the way down the storage stack though, which is even more useful, 
> because it lets disk failures properly cascade up the storage stack and 
> translate into the volumes they were part of showing up as degraded (or 
> getting unmounted if you choose to configure it that way).
Ok, not sure I still understand how/why systemd knows what devices are 
part of btrfs (or md or lvm for that matter). I'll try to research this 
a bit - thanks for the info!

>>
>>> IOW, there's a special case with systemd that makes even mounting 
>>> BTRFS volumes that have missing devices degraded not work.
>> Well I use systemd on Debian and have not had that issue. In what 
>> situation does this fail?
> At one point, if you tried to manually mount a volume that systemd did 
> not see all the constituent devices present for, it would get unmounted 
> almost instantly by systemd itself.  This may not be the case anymore, 
> or it may have been how the distros I've used with systemd on them 
> happened to behave, but either way it's a pain in the arse when you want 
> to fix a BTRFS volume.
I can see that, but from my "toying around" with btrfs I have not run 
into any issues while mounting degraded.

>>
>>>>
>>>>> * Given that new kernels still don't properly generate half-raid1 
>>>>> chunks when a device is missing in a two-device raid1 setup, 
>>>>> there's a very real possibility that users will have trouble 
>>>>> recovering filesystems with old recovery media (IOW, any recovery 
>>>>> environment running a kernel before 4.14 will not mount the volume 
>>>>> correctly).
>>>> Sometimes you have to break a few eggs to make an omelette right? If 
>>>> people want to recover their data they should have backups, and if 
>>>> they are really interested in recovering their data (and don't have 
>>>> backups) then they will probably find this on the web by searching 
>>>> anyway...
>>> Backups aren't the type of recovery I'm talking about.  I'm talking 
>>> about people booting to things like SystemRescueCD to fix system 
>>> configuration or do offline maintenance without having to nuke the 
>>> system and restore from backups.  Such recovery environments often 
>>> don't get updated for a _long_ time, and such usage is not atypical 
>>> as a first step in trying to fix a broken system in situations where 
>>> downtime really is a serious issue.
>> I would say that if downtime is such a serious issue you have a 
>> failover and a working tested backup.
> Generally yes, but restoring a volume completely from scratch is almost 
> always going to take longer than just fixing what's broken unless it's 
> _really_ broken.  Would you really want to nuke a system and rebuild it 
> from scratch just because you accidentally pulled out the wrong disk 
> when hot-swapping drives to rebuild an array?
Absolutely not , but in this case I would not even want to use a rescue 
disk in the first place.

>>>>
>>>>> * You shouldn't be mounting writable and degraded for any reason 
>>>>> other than fixing the volume (or converting it to a single profile 
>>>>> until you can fix it), even aside from the other issues.
>>>>
>>>> Well in my opinion the degraded mount option is counter intuitive. 
>>>> Unless otherwise asked for the system should mount and work as long 
>>>> as it can guarantee the data can be read and written somehow 
>>>> (regardless if any redundancy guarantee is not met). If the user is 
>>>> willing to accept more or less risk they should configure it!
>>> Again, BTRFS mounting degraded is significantly riskier than LVM or 
>>> MD doing the same thing.  Most users don't properly research things 
>>> (When's the last time you did a complete cost/benefit analysis before 
>>> deciding to use a particular piece of software on a system?), and 
>>> would not know they were taking on significantly higher risk by using 
>>> BTRFS without configuring it to behave safely until it actually 
>>> caused them problems, at which point most people would then complain 
>>> about the resulting data loss instead of trying to figure out why it 
>>> happened and prevent it in the first place.  I don't know about you, 
>>> but I for one would rather BTRFS have a reputation for being 
>>> over-aggressively safe by default than risking users data by default.
>> Well I don't do cost/benefit analysis since I run free software. I do 
>> however try my best to ensure that whatever software I install don't 
>> cause more drawbacks than benefits.
> Which is essentially a CBA.  The cost doesn't have to equate to money, 
> it could be time, or even limitations in what you can do with the system.
> 
>> I would also like for BTRFS to be over-aggressively safe, but I also 
>> want it to be over-aggressively always running or even limping if that 
>> is what it needs to do.
> And you can have it do that, we just prefer not to by default.
Got it!
