Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DBAC282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 19:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B46052175B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 19:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CBk7iExt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfBGTjl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 14:39:41 -0500
Received: from mail-it1-f171.google.com ([209.85.166.171]:36076 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfBGTjk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 14:39:40 -0500
Received: by mail-it1-f171.google.com with SMTP id c9so2822561itj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 11:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Qjnsnd6G0P23IaMqQSPWzXhw85E92oTs7Whm5RDIA9o=;
        b=CBk7iExt9TE1dQcgxNacjW6GJm5bHuj4tWG0rp838HxlYSjVX+Xqld9e4PuWaQhLrH
         gOjtGT7Brxmb6S7KczNX/LENS2LXAYHCZ7bdzeeYjo4Y93LftUJMvsE+hW7jdPZMxmkf
         QY/5dk8mxzecDvM9peerPbc8RzzBLfJCDPUa3NfT+vwEwhJGSeqpw2p84YH4gaiPSGXO
         9lEj/6cDijjLHWRB4GKJb36Gh3aOTRD6GWp3Emm4ogNCR3jNaGNhQYFbJDmFxYLeXo7P
         c7BFnM8ESdpK1aixvw2VNaEKNCoz9OziF8NQCH6b2V9a8KDE+Z21fK+Z6h4yXRdz4xuA
         iwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qjnsnd6G0P23IaMqQSPWzXhw85E92oTs7Whm5RDIA9o=;
        b=ZxfxmN9cWGXyP4XWAKLg11oArAa0Nx7PEizD58wA1wOhp1tx+TVH59/kDaaFrKrG/O
         SqGZggZNxaI5CAtM39SLzYZ0xh8jRpT36irOnfx0yTGHu6L7PwiTI3MC9JYKX68pOmVU
         JJniDNF7SG5FpIbaIDyks8L+7UhY74HYX5MFQp/h1KhQNBqne6X/SW++Ygui0ju3KCQr
         cGvoI5NFP5x3UcrSuKmILXUpsH7xqWGAhXFc3Dh4hNqnt1qYEFUlxFAONWBajKsA5VVu
         VquADSZRIcfLDKnxTiFRbm3wGaLkQ2xaJA7LQWHdbEvOdsNDeANE+DWrqK+7R0qdvZ8u
         46ag==
X-Gm-Message-State: AHQUAuZi0Okw3ZASJKZGWxZ7F87SH9qYwKuDgKhtQSgDrp8b0iAbeUkA
        aErcuLrdkUDNXcKLq9VJJr2AnJkCKkw=
X-Google-Smtp-Source: AHgI3Ia1P30cobXG5mTgIWSYLk8kaE0JbVyC8xK6XydEWsH8XSqkPBfR0s477Pa83JyxW/jb+IutNw==
X-Received: by 2002:a5e:dc0d:: with SMTP id b13mr4412016iok.269.1549568378298;
        Thu, 07 Feb 2019 11:39:38 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id k1sm4818295iom.40.2019.02.07.11.39.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 11:39:37 -0800 (PST)
Subject: Re: btrfs as / filesystem in RAID1
To:     waxhead@dirtcellar.net, Stefan K <shadow_7@gmx.net>,
        linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
Date:   Thu, 7 Feb 2019 14:39:34 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-07 13:53, waxhead wrote:
> 
> 
> Austin S. Hemmelgarn wrote:
>> On 2019-02-07 06:04, Stefan K wrote:
>>> Thanks, with degraded  as kernel parameter and also ind the fstab it 
>>> works like expected
>>>
>>> That should be the normal behaviour, cause a server must be up and 
>>> running, and I don't care about a device loss, thats why I use a 
>>> RAID1. The device-loss problem can I fix later, but its important 
>>> that a server is up and running, i got informed at boot time and also 
>>> in the logs files that a device is missing, also I see that if you 
>>> use a monitoring program.
>> No, it shouldn't be the default, because:
>>
>> * Normal desktop users _never_ look at the log files or boot info, and 
>> rarely run monitoring programs, so they as a general rule won't notice 
>> until it's already too late.  BTRFS isn't just a server filesystem, so 
>> it needs to be safe for regular users too.
> 
> I am willing to argue that whatever you refer to as normal users don't 
> have a clue how to make a raid1 filesystem, nor do they care about what 
> underlying filesystem their computer runs. I can't quite see how a 
> limping system would be worse than a failing system in this case. 
> Besides "normal" desktop users use Windows anyway, people that run on 
> penguin powered stuff generally have at least some technical knowledge.
Once you get into stuff like Arch or Gentoo, yeah, people tend to have 
enough technical knowledge to handle this type of thing, but if you're 
talking about the big distros like Ubuntu or Fedora, not so much.  Yes, 
I might be a bit pessimistic here, but that pessimism is based on 
personal experience over many years of providing technical support for 
people.

Put differently, human nature is to ignore things that aren't 
immediately relevant.  Kernel logs don't matter until you see something 
wrong.  Boot messages don't matter unless you happen to see them while 
the system is booting (and most people don't).  Monitoring is the only 
way here, but most people won't invest the time in proper monitoring 
until they have problems.  Even as a seasoned sysadmin, I never look at 
kernel logs until I see any problem, I rarely see boot messages on most 
of the systems I manage (because I'm rarely sitting at the console when 
they boot up, and when I am I'm usually handling startup of a dozen or 
so systems simultaneously after a network-wide outage), and I only 
monitor things that I know for certain need to be monitored.
> 
>> * It's easily possible to end up mounting degraded by accident if one 
>> of the constituent devices is slow to enumerate, and this can easily 
>> result in a split-brain scenario where all devices have diverged and 
>> the volume can only be repaired by recreating it from scratch.
> 
> Am I wrong or would not the remaining disk have the generation number 
> bumped on every commit? would it not make sense to ignore (previously) 
> stale disks and require a manual "re-add" of the failed disks. From a 
> users perspective with some C coding knowledge this sounds to me (in 
> principle) like something as quite simple.
> E.g. if the superblock UUID match for all devices and one (or more) 
> devices has a lower generation number than the other(s) then the disk(s) 
> with the newest generation number should be considered good and the 
> other disks with a lower generation number should be marked as failed.
The problem is that if you're defaulting to this behavior, you can have 
multiple disks diverge from the base.  Imagine, for example, a system 
with two devices in a raid1 setup with degraded mounts enabled by 
default, and either device randomly taking longer than normal to 
enumerate.  It's very possible for one boot to have one device delay 
during enumeration on one boot, then the other on the next boot, and if 
not handled _exactly_ right by the user, this will result in both 
devices having a higher generation number than they started with, but 
neither one being 'wrong'.  It's like trying to merge branches in git 
that both have different changes to a binary file, there's no sane way 
to handle it without user input.

Realistically, we can only safely recover from divergence correctly if 
we can prove that all devices are true prior states of the current 
highest generation, which is not currently possible to do reliably 
because of how BTRFS operates.

Also, LVM and MD have the exact same issue, it's just not as significant 
because they re-add and re-sync missing devices automatically when they 
reappear, which makes such split-brain scenarios much less likely.
> 
>> * We have _ZERO_ automatic recovery from this situation.  This makes 
>> both of the above mentioned issues far more dangerous.
> 
> See above, would this not be as simple as auto-deleting disks from the 
> pool that has a matching UUID and a mismatch for the superblock 
> generation number? Not exactly a recovery, but the system should be able 
> to limp along.
> 
>> * It just plain does not work with most systemd setups, because 
>> systemd will hang waiting on all the devices to appear due to the fact 
>> that they refuse to acknowledge that the only way to correctly know if 
>> a BTRFS volume will mount is to just try and mount it.
> 
> As far as I have understood this BTRFS refuses to mount even in 
> redundant setups without the degraded flag. Why?! This is just plain 
> useless. If anything the degraded mount option should be replaced with 
> something like failif=X where X would be anything from 'never' which 
> should get a 2 disk system up with exclusively raid1 profiles even if 
> only one device is working. 'always' in case any device is failed or 
> even 'atrisk' when loss of one more device would keep any raid chunk 
> profile guarantee. (this get admittedly complex in a multi disk raid1 
> setup or when subvolumes perhaps can be mounted with different "raid" 
> profiles....)
The issue with systemd is that if you pass 'degraded' on most systemd 
systems,  and devices are missing when the system tries to mount the 
volume, systemd won't mount it because it doesn't see all the devices. 
It doesn't even _try_ to mount it because it doesn't see all the 
devices.  Changing to degraded by default won't fix this, because it's a 
systemd problem.

The same issue also makes it a serious pain in the arse to recover 
degraded BTRFS volumes on systemd systems, because if the volume is 
supposed to mount normally on that system, systemd will unmount it if it 
doesn't see all the devices, regardless of how it got mounted in the 
first place.

IOW, there's a special case with systemd that makes even mounting BTRFS 
volumes that have missing devices degraded not work.
> 
>> * Given that new kernels still don't properly generate half-raid1 
>> chunks when a device is missing in a two-device raid1 setup, there's a 
>> very real possibility that users will have trouble recovering 
>> filesystems with old recovery media (IOW, any recovery environment 
>> running a kernel before 4.14 will not mount the volume correctly).
> Sometimes you have to break a few eggs to make an omelette right? If 
> people want to recover their data they should have backups, and if they 
> are really interested in recovering their data (and don't have backups) 
> then they will probably find this on the web by searching anyway...
Backups aren't the type of recovery I'm talking about.  I'm talking 
about people booting to things like SystemRescueCD to fix system 
configuration or do offline maintenance without having to nuke the 
system and restore from backups.  Such recovery environments often don't 
get updated for a _long_ time, and such usage is not atypical as a first 
step in trying to fix a broken system in situations where downtime 
really is a serious issue.
> 
>> * You shouldn't be mounting writable and degraded for any reason other 
>> than fixing the volume (or converting it to a single profile until you 
>> can fix it), even aside from the other issues.
> 
> Well in my opinion the degraded mount option is counter intuitive. 
> Unless otherwise asked for the system should mount and work as long as 
> it can guarantee the data can be read and written somehow (regardless if 
> any redundancy guarantee is not met). If the user is willing to accept 
> more or less risk they should configure it!
Again, BTRFS mounting degraded is significantly riskier than LVM or MD 
doing the same thing.  Most users don't properly research things (When's 
the last time you did a complete cost/benefit analysis before deciding 
to use a particular piece of software on a system?), and would not know 
they were taking on significantly higher risk by using BTRFS without 
configuring it to behave safely until it actually caused them problems, 
at which point most people would then complain about the resulting data 
loss instead of trying to figure out why it happened and prevent it in 
the first place.  I don't know about you, but I for one would rather 
BTRFS have a reputation for being over-aggressively safe by default than 
risking users data by default.
