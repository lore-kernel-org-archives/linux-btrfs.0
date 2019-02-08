Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1751FC169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 19:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C79CD2084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 19:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TR0qMarg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfBHTRb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:17:31 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:51854 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfBHTR3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 14:17:29 -0500
Received: by mail-it1-f194.google.com with SMTP id y184so5202257itc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 11:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=M0mEnozNTyBcu70oXtnT7f9d5WW96KTItJG5sp71g2A=;
        b=TR0qMargOx2ICSH+5xxMObXE64sfXqEKOQucec4p+lrOVBjXcHk6yeg9cNnSXhnZ7p
         nAOKPzIgK88lPUasSY7ba+2HPmZYqjvFF2hnNcC28wpInMliaVxOwm/nLfy38QA+Bn3w
         xBLFSrgZYVov5zLt4Te6m1k/BuVK+i2X7ztHswVhSsAS37woOG59NuQEaSTDC+8eBPUb
         S369xpXEQ0KR+WvxJ71ZL0VTuF4P5SsztU4/nlKJlcz8aMsAlnmTF8MbUa7X6ZC41To/
         XjaUR5RqBDHAKQV4zHAqa2a1f65tLzjx7XcZZdSlqPZENS5sBImSkNZELsoStTpSS5o1
         TLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0mEnozNTyBcu70oXtnT7f9d5WW96KTItJG5sp71g2A=;
        b=g4JwXGEOTehhP9tDmnsSZ0KCGP7Nixi2BHCP/rwFjIipt6GPDkQxai2X3K2ftR0DZZ
         d1YmsFVaEM7EIM2dN55z6yXdxV5niIcuFzQco4vKFowT6dgayt26s0Gp7HhZfCu9j4sm
         vw/OCD9hkj1EDwgPdfFT3A3fqmhfQVPZ5I+MupustuxsgULyBuJf04yE9C8RNo6IckD3
         K6fG0wyhwqUkVy8eeW65KD2f/Ug+zAU7kkNPgn0yp2nG88Q6vbemC930Zt5vbVJTWe+0
         4vImW29YJJgwpbVy25jP6dacft0XSIB7QHXlKrMEUU9B5uGj9aqT1cuinTP/BgfzwyJA
         5lBQ==
X-Gm-Message-State: AHQUAubEUEo3Mb2/UMnClqV5stkwCigEPFJl4d2qxX8v8LFueKwcgqqr
        kHDw9O14/Njg4NdyJT8ca2B+w1VrnOM=
X-Google-Smtp-Source: AHgI3IbuIjKSKzLQXlz65yOiRbG8dSbCj4rQ7qENvzoXcq1Sq+1SokMe+fzC5+pj41rpLGJ2q0N9uA==
X-Received: by 2002:a24:94c8:: with SMTP id j191mr22588ite.133.1549653447322;
        Fri, 08 Feb 2019 11:17:27 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f21sm1620325itc.14.2019.02.08.11.17.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:17:26 -0800 (PST)
Subject: Re: btrfs as / filesystem in RAID1
To:     waxhead@dirtcellar.net, Stefan K <shadow_7@gmx.net>,
        linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
 <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
 <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f41063e8-b9b1-f929-7954-8a96e673bd2e@gmail.com>
Date:   Fri, 8 Feb 2019 14:17:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-08 13:10, waxhead wrote:
> Austin S. Hemmelgarn wrote:
>> On 2019-02-07 13:53, waxhead wrote:
>>>
>>>
>>> Austin S. Hemmelgarn wrote:
>>>> On 2019-02-07 06:04, Stefan K wrote:
>>>>> Thanks, with degraded  as kernel parameter and also ind the fstab 
>>>>> it works like expected
>>>>>
>>>>> That should be the normal behaviour, cause a server must be up and 
>>>>> running, and I don't care about a device loss, thats why I use a 
>>>>> RAID1. The device-loss problem can I fix later, but its important 
>>>>> that a server is up and running, i got informed at boot time and 
>>>>> also in the logs files that a device is missing, also I see that if 
>>>>> you use a monitoring program.
>>>> No, it shouldn't be the default, because:
>>>>
>>>> * Normal desktop users _never_ look at the log files or boot info, 
>>>> and rarely run monitoring programs, so they as a general rule won't 
>>>> notice until it's already too late.  BTRFS isn't just a server 
>>>> filesystem, so it needs to be safe for regular users too.
>>>
>>> I am willing to argue that whatever you refer to as normal users 
>>> don't have a clue how to make a raid1 filesystem, nor do they care 
>>> about what underlying filesystem their computer runs. I can't quite 
>>> see how a limping system would be worse than a failing system in this 
>>> case. Besides "normal" desktop users use Windows anyway, people that 
>>> run on penguin powered stuff generally have at least some technical 
>>> knowledge.
>> Once you get into stuff like Arch or Gentoo, yeah, people tend to have 
>> enough technical knowledge to handle this type of thing, but if you're 
>> talking about the big distros like Ubuntu or Fedora, not so much.  
>> Yes, I might be a bit pessimistic here, but that pessimism is based on 
>> personal experience over many years of providing technical support for 
>> people.
>>
>> Put differently, human nature is to ignore things that aren't 
>> immediately relevant.  Kernel logs don't matter until you see 
>> something wrong.  Boot messages don't matter unless you happen to see 
>> them while the system is booting (and most people don't).  Monitoring 
>> is the only way here, but most people won't invest the time in proper 
>> monitoring until they have problems.  Even as a seasoned sysadmin, I 
>> never look at kernel logs until I see any problem, I rarely see boot 
>> messages on most of the systems I manage (because I'm rarely sitting 
>> at the console when they boot up, and when I am I'm usually handling 
>> startup of a dozen or so systems simultaneously after a network-wide 
>> outage), and I only monitor things that I know for certain need to be 
>> monitored.
> 
> So what you are saying here is that distro's that use btrfs by default 
> should be responsible enough to make some monitoring solution if they 
> allow non-technical users to create a "raid"1 like btrfs filesystem in 
> the first place. I don't think that many distros install some S.M.A.R.T. 
> monitoring solution either... in which case you are worse off with a 
> non-checksumming filesystem.
Actually, more than you probably realize do (Windows does by default 
these days, so the big distros that want to compete for desktop users 
need to as well), and many have trivial to set up monitoring for MD and 
LVM arrays as well.
> Since the users you refer to basically ignores the filesystem anyway I 
> can't see why this would be an argument at all...
My argument here is that we shouldn't assume users will know what 
they're doing.  It's the same logic behind the saner distros not 
defaulting to using BTRFS for installation, if they do and BTRFS causes 
the user to lose data, the distro will usually get blamed, even if it 
was not at all their fault.  Similarly, if a user chooses to use BTRFS 
without doing their research, it's very likely that any data loss, even 
if it's caused by the user themself not doing things sensibly, will be 
blamed on BTRFS.
> 
>>>
>>>> * It's easily possible to end up mounting degraded by accident if 
>>>> one of the constituent devices is slow to enumerate, and this can 
>>>> easily result in a split-brain scenario where all devices have 
>>>> diverged and the volume can only be repaired by recreating it from 
>>>> scratch.
>>>
>>> Am I wrong or would not the remaining disk have the generation number 
>>> bumped on every commit? would it not make sense to ignore 
>>> (previously) stale disks and require a manual "re-add" of the failed 
>>> disks. From a users perspective with some C coding knowledge this 
>>> sounds to me (in principle) like something as quite simple.
>>> E.g. if the superblock UUID match for all devices and one (or more) 
>>> devices has a lower generation number than the other(s) then the 
>>> disk(s) with the newest generation number should be considered good 
>>> and the other disks with a lower generation number should be marked 
>>> as failed.
>> The problem is that if you're defaulting to this behavior, you can 
>> have multiple disks diverge from the base.  Imagine, for example, a 
>> system with two devices in a raid1 setup with degraded mounts enabled 
>> by default, and either device randomly taking longer than normal to 
>> enumerate.  It's very possible for one boot to have one device delay 
>> during enumeration on one boot, then the other on the next boot, and 
>> if not handled _exactly_ right by the user, this will result in both 
>> devices having a higher generation number than they started with, but 
>> neither one being 'wrong'.  It's like trying to merge branches in git 
>> that both have different changes to a binary file, there's no sane way 
>> to handle it without user input.
>>
> So why do BTRFS hurry to mount itself even if devices are missing? and 
> if BTRFS still can mount , why whould it blindly accept a non-existing 
> disk to take part of the pool?!
It doesn't unless you tell it to., and that behavior is exactly what I'm 
arguing against making the default here.
> 
>> Realistically, we can only safely recover from divergence correctly if 
>> we can prove that all devices are true prior states of the current 
>> highest generation, which is not currently possible to do reliably 
>> because of how BTRFS operates.
>>
> So what you are saying is that the generation number does not represent 
> a true frozen state of the filesystem at that point?
It does _only_ for those devices which were present at the time of the 
commit that incremented it.

As an example (don't do this with any BTRFS volume you care about, it 
will break it), take a BTRFS volume with two devices configured for 
raid1.  Mount the volume with only one of the devices present, issue a 
single write to it, then unmounted it.  Now do the same with only the 
other device.  Both devices should show the same generation number right 
now (but it should be one higher than when you started), but the 
generation number on each device refers to a different volume state.
> 
>> Also, LVM and MD have the exact same issue, it's just not as 
>> significant because they re-add and re-sync missing devices 
>> automatically when they reappear, which makes such split-brain 
>> scenarios much less likely.
> Which means marking the entire device as invalid, then re-adding it from 
> scratch more or less...
Actually, it doesn't.

For LVM and MD, they track what regions of the remaining device have 
changed, and sync only those regions when the missing device comes back.

For BTRFS, the same thing happens implicitly because of the COW 
structure, and you can manually reproduce similar behavior to LVM or MD 
by scrubbing the volume and then using balance with the 'soft' filter to 
ensure all the chunks are the correct type.

In both cases though, you still get into trouble if each of the devices 
gets used separately from each other before being re-synced (though 
BTRFS at least has the decency in that situation to not lose any data, 
LVM or MD will just blindly sync whichever mirror they happen to pick 
over the others).
> 
>>>
>>>> * We have _ZERO_ automatic recovery from this situation.  This makes 
>>>> both of the above mentioned issues far more dangerous.
>>>
>>> See above, would this not be as simple as auto-deleting disks from 
>>> the pool that has a matching UUID and a mismatch for the superblock 
>>> generation number? Not exactly a recovery, but the system should be 
>>> able to limp along.
>>>
>>>> * It just plain does not work with most systemd setups, because 
>>>> systemd will hang waiting on all the devices to appear due to the 
>>>> fact that they refuse to acknowledge that the only way to correctly 
>>>> know if a BTRFS volume will mount is to just try and mount it.
>>>
>>> As far as I have understood this BTRFS refuses to mount even in 
>>> redundant setups without the degraded flag. Why?! This is just plain 
>>> useless. If anything the degraded mount option should be replaced 
>>> with something like failif=X where X would be anything from 'never' 
>>> which should get a 2 disk system up with exclusively raid1 profiles 
>>> even if only one device is working. 'always' in case any device is 
>>> failed or even 'atrisk' when loss of one more device would keep any 
>>> raid chunk profile guarantee. (this get admittedly complex in a multi 
>>> disk raid1 setup or when subvolumes perhaps can be mounted with 
>>> different "raid" profiles....)
>> The issue with systemd is that if you pass 'degraded' on most systemd 
>> systems,  and devices are missing when the system tries to mount the 
>> volume, systemd won't mount it because it doesn't see all the devices. 
>> It doesn't even _try_ to mount it because it doesn't see all the 
>> devices.  Changing to degraded by default won't fix this, because it's 
>> a systemd problem.
>>
>> The same issue also makes it a serious pain in the arse to recover 
>> degraded BTRFS volumes on systemd systems, because if the volume is 
>> supposed to mount normally on that system, systemd will unmount it if 
>> it doesn't see all the devices, regardless of how it got mounted in 
>> the first place.
>>
> Why does systemd concern itself about what devices btrfs consist of. 
> Please educate me, I am curious.
For the same reason that it concerns itself with what devices make up a 
LVM volume or an MD array.  In essence, it comes down to a couple of 
specific things:

* It is almost always preferable to delay boot-up while waiting for a 
missing device to reappear than it is to start using a volume that 
depends on it while it's missing.  The overall impact on the system from 
taking a few seconds longer to boot is generally less than the impact of 
having to resync the device when it reappears while the system is still 
booting up.

* Systemd allows mounts to not block the system booting while still 
allowing certain services to depend on those mounts being active.  This 
is extremely useful for remote management reasons, and is actually 
supported by most service managers these days.  Systemd extends this all 
the way down the storage stack though, which is even more useful, 
because it lets disk failures properly cascade up the storage stack and 
translate into the volumes they were part of showing up as degraded (or 
getting unmounted if you choose to configure it that way).
> 
>> IOW, there's a special case with systemd that makes even mounting 
>> BTRFS volumes that have missing devices degraded not work.
> Well I use systemd on Debian and have not had that issue. In what 
> situation does this fail?
At one point, if you tried to manually mount a volume that systemd did 
not see all the constituent devices present for, it would get unmounted 
almost instantly by systemd itself.  This may not be the case anymore, 
or it may have been how the distros I've used with systemd on them 
happened to behave, but either way it's a pain in the arse when you want 
to fix a BTRFS volume.
> 
>>>
>>>> * Given that new kernels still don't properly generate half-raid1 
>>>> chunks when a device is missing in a two-device raid1 setup, there's 
>>>> a very real possibility that users will have trouble recovering 
>>>> filesystems with old recovery media (IOW, any recovery environment 
>>>> running a kernel before 4.14 will not mount the volume correctly).
>>> Sometimes you have to break a few eggs to make an omelette right? If 
>>> people want to recover their data they should have backups, and if 
>>> they are really interested in recovering their data (and don't have 
>>> backups) then they will probably find this on the web by searching 
>>> anyway...
>> Backups aren't the type of recovery I'm talking about.  I'm talking 
>> about people booting to things like SystemRescueCD to fix system 
>> configuration or do offline maintenance without having to nuke the 
>> system and restore from backups.  Such recovery environments often 
>> don't get updated for a _long_ time, and such usage is not atypical as 
>> a first step in trying to fix a broken system in situations where 
>> downtime really is a serious issue.
> I would say that if downtime is such a serious issue you have a failover 
> and a working tested backup.
Generally yes, but restoring a volume completely from scratch is almost 
always going to take longer than just fixing what's broken unless it's 
_really_ broken.  Would you really want to nuke a system and rebuild it 
from scratch just because you accidentally pulled out the wrong disk 
when hot-swapping drives to rebuild an array?
> 
>>>
>>>> * You shouldn't be mounting writable and degraded for any reason 
>>>> other than fixing the volume (or converting it to a single profile 
>>>> until you can fix it), even aside from the other issues.
>>>
>>> Well in my opinion the degraded mount option is counter intuitive. 
>>> Unless otherwise asked for the system should mount and work as long 
>>> as it can guarantee the data can be read and written somehow 
>>> (regardless if any redundancy guarantee is not met). If the user is 
>>> willing to accept more or less risk they should configure it!
>> Again, BTRFS mounting degraded is significantly riskier than LVM or MD 
>> doing the same thing.  Most users don't properly research things 
>> (When's the last time you did a complete cost/benefit analysis before 
>> deciding to use a particular piece of software on a system?), and 
>> would not know they were taking on significantly higher risk by using 
>> BTRFS without configuring it to behave safely until it actually caused 
>> them problems, at which point most people would then complain about 
>> the resulting data loss instead of trying to figure out why it 
>> happened and prevent it in the first place.  I don't know about you, 
>> but I for one would rather BTRFS have a reputation for being 
>> over-aggressively safe by default than risking users data by default.
> Well I don't do cost/benefit analysis since I run free software. I do 
> however try my best to ensure that whatever software I install don't 
> cause more drawbacks than benefits.
Which is essentially a CBA.  The cost doesn't have to equate to money, 
it could be time, or even limitations in what you can do with the system.

> I would also like for BTRFS to be over-aggressively safe, but I also 
> want it to be over-aggressively always running or even limping if that 
> is what it needs to do.
And you can have it do that, we just prefer not to by default.
