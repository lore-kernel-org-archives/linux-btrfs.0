Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34255 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbcBJOAC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 09:00:02 -0500
Received: by mail-io0-f179.google.com with SMTP id 9so21734489iom.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 06:00:02 -0800 (PST)
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
To: Chris Murphy <lists@colorremedies.com>,
        Mackenzie Meyer <snackmasterx@gmail.com>
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
 <CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56BB41E3.8050906@gmail.com>
Date: Wed, 10 Feb 2016 08:57:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-09 15:39, Chris Murphy wrote:
> On Fri, Feb 5, 2016 at 12:36 PM, Mackenzie Meyer <snackmasterx@gmail.com> wrote:
>
>>
>> RAID 6 write holes?
>
> I don't even understand the nature of the write hole on Btrfs. If
> modification is still always COW, then either an fs block, a strip, or
> whole stripe write happens, I'm not sure where the hole comes from. It
> suggests some raid56 writes are not atomic.
It's an issue of torn writes in this case, not of atomicity of BTRFS. 
Disks can't atomically write more than sector size chunks, which means 
that almost all BTRFS filesystems are doing writes that disks can't 
atomically complete.  Add to that that we serialized writes to different 
devices, and it becomes trivial to lose some data if the system crashes 
while BTRFS is writing out a stripe (it shouldn't screw up existing data 
though, you'll just loose whatever you were trying to write).

One way to minimize this which would also boost performance on slow 
storage would be to avoid writing parts of the stripe that aren't 
changed (so for example, if only one disk in the stripe actually has 
changed data, only write that and the parities).
>
> If you're worried about raid56 write holes, then a.) you need a server
> running this raid where power failures or crashes don't happen b.)
> don't use raid56 c.) use ZFS.
It's not just BTRFS that has this issue though, ZFS does too, it just 
recovers more gracefully than BTRFS does, and even with the journaled 
RAID{5,6} support that's being added in MDRAID (and by extension DM-RAID 
and therefore LVM), it still has the same issue, it just moves it 
elsewhere (in this case, it has problems if there's a torn write to the 
journal).
>
>> RAID 6 stability?
>> Any articles I've tried looking for online seem to be from early 2014,
>> I can't find anything recent discussing the stability of RAID 5 or 6.
>> Are there or have there recently been any data corruption bugs which
>> impact RAID 6? Would you consider RAID 6 safe/stable enough for
>> production use?
>
> It's not stable for your use case, if you have to ask others if it's
> stable enough for your use case. Simple as that. Right now some raid6
> users are experiencing remarkably slow balances, on the order of
> weeks. If device replacement rebuild times are that long, I'd say it's
> disqualifying for most any use case, just because there are
> alternatives that have better fail over behavior than this. So far
> there's no word from any developers what the problem might be, or
> where to gather more information. So chances are they're already aware
> of it but haven't reproduced it, or isolated it, or have a fix for it
> yet.
Double on this, we should probably put something similar on the wiki, 
and this really applies to any feature, not just raid56.
>
>> Do you still strongly recommend backups, or has stability reached a
>> point where backups aren't as critical? I'm thinking from a data
>> consistency standpoint, not a hardware failure standpoint.
>
> You can't separate them. On completely stable hardware, stem to stern,
> you'd have no backups, no Btrfs or ZFS, you'd just run linear/concat
> arrays with XFS, for example. So you can't just hand wave the hardware
> part away. There are bugs in the entire storage stack, there are
> connectors that can become intermittent, the system could crash. All
> of these affect data consistency.
I may be wrong, but I believe the intent of this question was to try and 
figure out how likely BTRFS itself is to cause crashes or data 
corruption, independent of the hardware. In other words, 'Do I need to 
worry significantly about BTRFS in planning for disaster recovery, or 
can I focus primarily on the hardware itself?' or 'Is the most likely 
failure mode going to be hardware failure, or software?'. In general, 
right now I'd say that using BTRFS in traditional multi-device setup 
(nothing more than raid1 or possibly raid10), you've got roughly a 50% 
chance of an arbitrary crash being a software issue instead of hardware. 
Single disk, I'd say it's probably closer to 25%, and raid56 I'd say 
it's probably closer to 75%. By comparison, I'd say that with ZFS it's 
maybe a 5% chance (ZFS is developed as enterprise level software, it has 
to work, period), and with XFS on LVM raid, probably about 15% (similar 
to ZFS, XFS is supposed to be enterprise level software, the difference 
here comes from LVM, which has had some interesting issues recently due 
to incomplete testing of certain things before they got pushed upstream).
>
> Stability has not reach a point where backups aren't as critical. I
> don't really even know what that means though. No matter Btrfs or not,
> you need to be doing backups such that if the primary stack is a 100%
> loss without notice, is not a disaster. Plan on having to use it. If
> you don't like the sound of that, look elsewhere.
What your using has impact on how you need to do backups.  For someone 
who can afford long periods of down time for example, it may be 
perfectly fine to use something like Amazon S3 Glacier storage (which 
has a 4 hour lead time on restoration for read access) for backups. 
OTOH, if you can't afford more than a few minutes of down time and want 
to use BTRFS, you should probably have full on-line on-site backups 
which you can switch in on a moments notice while you fix things.
