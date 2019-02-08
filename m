Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC85C282CB
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 18:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D0DF21B24
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 18:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dirtcellar.net header.i=@dirtcellar.net header.b="Mm72qxJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfBHSKe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 13:10:34 -0500
Received: from smtp.domeneshop.no ([194.63.252.55]:60199 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfBHSKe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 13:10:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dirtcellar.net; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Reply-To; bh=5c/07uTE1WtEF8iFUEI357ZWGxtL5+Brl6iBQ9IP8r8=;
        b=Mm72qxJ6FaSL/9sbUvQZVl/G+hzD8WQiTA9KYLafd18CEN6HX7uZjl3ZZjwBO7gg40xNwOKIDZRFj23e+1juSoO/3d0KUHD1pnCB7Q4juStSIUsjAaKWEnEZUBsb/xWOEdpOcaTKEXh84OyWvZ7Z8BMKMMarcFu1S3mWfOtKXeuRFDs+iPuSo/dnT98l8Sfz5s0sKsWCkXe03sLuZxLlcCK0sdOlfpA2jA6Hyjnn5aRT+tOBBOc+J7Vzm9yJbD1TAGo4Bmv6c9sqG5vv1JeFvNQpQ/UaVr0JqAFMuUEjWWc3gYNRKl9d8ZwBCrOJC4hrgeGlSXaVCHFGKbIYpbbx1A==;
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:36312 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1gsAbf-00041s-2j; Fri, 08 Feb 2019 19:10:31 +0100
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
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net>
Date:   Fri, 8 Feb 2019 19:10:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Austin S. Hemmelgarn wrote:
> On 2019-02-07 13:53, waxhead wrote:
>>
>>
>> Austin S. Hemmelgarn wrote:
>>> On 2019-02-07 06:04, Stefan K wrote:
>>>> Thanks, with degraded  as kernel parameter and also ind the fstab it 
>>>> works like expected
>>>>
>>>> That should be the normal behaviour, cause a server must be up and 
>>>> running, and I don't care about a device loss, thats why I use a 
>>>> RAID1. The device-loss problem can I fix later, but its important 
>>>> that a server is up and running, i got informed at boot time and 
>>>> also in the logs files that a device is missing, also I see that if 
>>>> you use a monitoring program.
>>> No, it shouldn't be the default, because:
>>>
>>> * Normal desktop users _never_ look at the log files or boot info, 
>>> and rarely run monitoring programs, so they as a general rule won't 
>>> notice until it's already too late.  BTRFS isn't just a server 
>>> filesystem, so it needs to be safe for regular users too.
>>
>> I am willing to argue that whatever you refer to as normal users don't 
>> have a clue how to make a raid1 filesystem, nor do they care about 
>> what underlying filesystem their computer runs. I can't quite see how 
>> a limping system would be worse than a failing system in this case. 
>> Besides "normal" desktop users use Windows anyway, people that run on 
>> penguin powered stuff generally have at least some technical knowledge.
> Once you get into stuff like Arch or Gentoo, yeah, people tend to have 
> enough technical knowledge to handle this type of thing, but if you're 
> talking about the big distros like Ubuntu or Fedora, not so much.  Yes, 
> I might be a bit pessimistic here, but that pessimism is based on 
> personal experience over many years of providing technical support for 
> people.
> 
> Put differently, human nature is to ignore things that aren't 
> immediately relevant.  Kernel logs don't matter until you see something 
> wrong.  Boot messages don't matter unless you happen to see them while 
> the system is booting (and most people don't).  Monitoring is the only 
> way here, but most people won't invest the time in proper monitoring 
> until they have problems.  Even as a seasoned sysadmin, I never look at 
> kernel logs until I see any problem, I rarely see boot messages on most 
> of the systems I manage (because I'm rarely sitting at the console when 
> they boot up, and when I am I'm usually handling startup of a dozen or 
> so systems simultaneously after a network-wide outage), and I only 
> monitor things that I know for certain need to be monitored.

So what you are saying here is that distro's that use btrfs by default 
should be responsible enough to make some monitoring solution if they 
allow non-technical users to create a "raid"1 like btrfs filesystem in 
the first place. I don't think that many distros install some S.M.A.R.T. 
monitoring solution either... in which case you are worse off with a 
non-checksumming filesystem.
Since the users you refer to basically ignores the filesystem anyway I 
can't see why this would be an argument at all...

>>
>>> * It's easily possible to end up mounting degraded by accident if one 
>>> of the constituent devices is slow to enumerate, and this can easily 
>>> result in a split-brain scenario where all devices have diverged and 
>>> the volume can only be repaired by recreating it from scratch.
>>
>> Am I wrong or would not the remaining disk have the generation number 
>> bumped on every commit? would it not make sense to ignore (previously) 
>> stale disks and require a manual "re-add" of the failed disks. From a 
>> users perspective with some C coding knowledge this sounds to me (in 
>> principle) like something as quite simple.
>> E.g. if the superblock UUID match for all devices and one (or more) 
>> devices has a lower generation number than the other(s) then the 
>> disk(s) with the newest generation number should be considered good 
>> and the other disks with a lower generation number should be marked as 
>> failed.
> The problem is that if you're defaulting to this behavior, you can have 
> multiple disks diverge from the base.  Imagine, for example, a system 
> with two devices in a raid1 setup with degraded mounts enabled by 
> default, and either device randomly taking longer than normal to 
> enumerate.  It's very possible for one boot to have one device delay 
> during enumeration on one boot, then the other on the next boot, and if 
> not handled _exactly_ right by the user, this will result in both 
> devices having a higher generation number than they started with, but 
> neither one being 'wrong'.  It's like trying to merge branches in git 
> that both have different changes to a binary file, there's no sane way 
> to handle it without user input.
> 
So why do BTRFS hurry to mount itself even if devices are missing? and 
if BTRFS still can mount , why whould it blindly accept a non-existing 
disk to take part of the pool?!

> Realistically, we can only safely recover from divergence correctly if 
> we can prove that all devices are true prior states of the current 
> highest generation, which is not currently possible to do reliably 
> because of how BTRFS operates.
> 
So what you are saying is that the generation number does not represent 
a true frozen state of the filesystem at that point?

> Also, LVM and MD have the exact same issue, it's just not as significant 
> because they re-add and re-sync missing devices automatically when they 
> reappear, which makes such split-brain scenarios much less likely.
Which means marking the entire device as invalid, then re-adding it from 
scratch more or less...

>>
>>> * We have _ZERO_ automatic recovery from this situation.  This makes 
>>> both of the above mentioned issues far more dangerous.
>>
>> See above, would this not be as simple as auto-deleting disks from the 
>> pool that has a matching UUID and a mismatch for the superblock 
>> generation number? Not exactly a recovery, but the system should be 
>> able to limp along.
>>
>>> * It just plain does not work with most systemd setups, because 
>>> systemd will hang waiting on all the devices to appear due to the 
>>> fact that they refuse to acknowledge that the only way to correctly 
>>> know if a BTRFS volume will mount is to just try and mount it.
>>
>> As far as I have understood this BTRFS refuses to mount even in 
>> redundant setups without the degraded flag. Why?! This is just plain 
>> useless. If anything the degraded mount option should be replaced with 
>> something like failif=X where X would be anything from 'never' which 
>> should get a 2 disk system up with exclusively raid1 profiles even if 
>> only one device is working. 'always' in case any device is failed or 
>> even 'atrisk' when loss of one more device would keep any raid chunk 
>> profile guarantee. (this get admittedly complex in a multi disk raid1 
>> setup or when subvolumes perhaps can be mounted with different "raid" 
>> profiles....)
> The issue with systemd is that if you pass 'degraded' on most systemd 
> systems,  and devices are missing when the system tries to mount the 
> volume, systemd won't mount it because it doesn't see all the devices. 
> It doesn't even _try_ to mount it because it doesn't see all the 
> devices.  Changing to degraded by default won't fix this, because it's a 
> systemd problem.
> 
> The same issue also makes it a serious pain in the arse to recover 
> degraded BTRFS volumes on systemd systems, because if the volume is 
> supposed to mount normally on that system, systemd will unmount it if it 
> doesn't see all the devices, regardless of how it got mounted in the 
> first place.
> 
Why does systemd concern itself about what devices btrfs consist of. 
Please educate me, I am curious.

> IOW, there's a special case with systemd that makes even mounting BTRFS 
> volumes that have missing devices degraded not work.
Well I use systemd on Debian and have not had that issue. In what 
situation does this fail?

>>
>>> * Given that new kernels still don't properly generate half-raid1 
>>> chunks when a device is missing in a two-device raid1 setup, there's 
>>> a very real possibility that users will have trouble recovering 
>>> filesystems with old recovery media (IOW, any recovery environment 
>>> running a kernel before 4.14 will not mount the volume correctly).
>> Sometimes you have to break a few eggs to make an omelette right? If 
>> people want to recover their data they should have backups, and if 
>> they are really interested in recovering their data (and don't have 
>> backups) then they will probably find this on the web by searching 
>> anyway...
> Backups aren't the type of recovery I'm talking about.  I'm talking 
> about people booting to things like SystemRescueCD to fix system 
> configuration or do offline maintenance without having to nuke the 
> system and restore from backups.  Such recovery environments often don't 
> get updated for a _long_ time, and such usage is not atypical as a first 
> step in trying to fix a broken system in situations where downtime 
> really is a serious issue.
I would say that if downtime is such a serious issue you have a failover 
and a working tested backup.

>>
>>> * You shouldn't be mounting writable and degraded for any reason 
>>> other than fixing the volume (or converting it to a single profile 
>>> until you can fix it), even aside from the other issues.
>>
>> Well in my opinion the degraded mount option is counter intuitive. 
>> Unless otherwise asked for the system should mount and work as long as 
>> it can guarantee the data can be read and written somehow (regardless 
>> if any redundancy guarantee is not met). If the user is willing to 
>> accept more or less risk they should configure it!
> Again, BTRFS mounting degraded is significantly riskier than LVM or MD 
> doing the same thing.  Most users don't properly research things (When's 
> the last time you did a complete cost/benefit analysis before deciding 
> to use a particular piece of software on a system?), and would not know 
> they were taking on significantly higher risk by using BTRFS without 
> configuring it to behave safely until it actually caused them problems, 
> at which point most people would then complain about the resulting data 
> loss instead of trying to figure out why it happened and prevent it in 
> the first place.  I don't know about you, but I for one would rather 
> BTRFS have a reputation for being over-aggressively safe by default than 
> risking users data by default.
Well I don't do cost/benefit analysis since I run free software. I do 
however try my best to ensure that whatever software I install don't 
cause more drawbacks than benefits.
I would also like for BTRFS to be over-aggressively safe, but I also 
want it to be over-aggressively always running or even limping if that 
is what it needs to do.
