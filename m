Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35091 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbcABKxd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 05:53:33 -0500
Received: by mail-wm0-f53.google.com with SMTP id f206so96506254wmf.0
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 02:53:32 -0800 (PST)
Received: from hydra ([2a02:8109:1cc0:c84:922b:34ff:fe32:57ad])
        by smtp.gmail.com with ESMTPSA id cv10sm26438603wjb.17.2016.01.02.02.53.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Jan 2016 02:53:30 -0800 (PST)
Date: Sat, 2 Jan 2016 11:53:18 +0100
From: Alexander Duscheleit <alexander.duscheleit@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Unrecoverable fs corruption?
Message-ID: <20160102115318.4e76f773@hydra>
In-Reply-To: <pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 01 Jan 2016 00:14:37 -0800, Duncan wrote:
> Chris Murphy posted on Thu, 31 Dec 2015 18:22:09 -0700 as excerpted:
>
>> On Thu, Dec 31, 2015 at 4:36 PM, Alexander Duscheleit
>> <alexander.duschel...@gmail.com> wrote:
>>> [...]
>>
>>
>> Why are you trying to mount only one? What mount options did you use
>> when you did this?
>
> Yes, please.

I was under the impression that a mount (actually any) command issued
against a member of a multi-device btrfs would affect the whole
multi-device.

>
>>> btrfs restore -viD seems to find most of the files accessible but
>>> since I don't have a spare hdd of sufficient size I would have to
>>> break the array and reformat and use one of the disk as restore
>>> target. I'm not prepared to do this before I know there is no other
>>> way to fix the drives since I'm essentially destroying one more
>>> chance at saving the data.
>
>> Anyway, in the meantime, my advice is do not mount either device rw
>> (together or separately). The less changes you make right now the
>> better.
>>
>> What kernel and btrfs-progs version are you using?

Sorry, I had this included in a paragraph I later removed.
Kernel 4.3.3, btrfs-progs v4.3.1

>
> Unless you've already tried it (hard to say without the mount options
> you used above), I'd first try a different tact than C Murphy
> suggests, falling back to what he suggests if it doesn't work.  I
> suppose he assumes you've already tried this...
>
> But first things first, as C Murphy suggests, when you post problems
> like this, *PLEASE* post kernel and progs userspace versions.  Given
> the rate at which btrfs is still changing, that's pretty critical
> information. Also, if you're not running the latest or second latest
> kernel or LTS kernel series and a similar or newer userspace, be
> prepared to be asked to try a newer version.  With the almost
> released 4.4 set to be an LTS, that means it if you want to try it,
> or the LTS kernel series 4.1 and 3.18, or the current or previous
> current kernel series 4.3 or 4.2 (tho with 4.2 not being an LTS
> updates are ended or close to it, so people on it should be either
> upgrading to 4.3 or downgrading to 4.1 LTS anyway). And for
> userspace, a good rule of thumb is whatever the kernel series, a
> corresponding or newer userspace as well.
>
> With that covered...
>
> This is a good place to bring in something else CM recommended, but
> in a slightly different context.  If you've read many of my previous
> posts you're likely to know what I'm about to say.  The admin's first
> rule of backups says, in simplest form[1], that if you don't have a
> backup, by your actions you're defining the data that would be backed
> up as not worth the hassle and resources to do that backup.  If in
> that case you lose the data, be happy, as you still saved what you
> defined by your actions as of /true/ value regardless of any claims
> to the contrary, the hassle and resourced you would have spent making
> that backup.  =:^)
>
> While the rule of backups applies in general, for btrfs it applies
> even more, because btrfs is still under heavy development and while
> btrfs is "stabilizING, it's not yet fully stable and mature, so the
> risk of actually needing to use that backup remains correspondingly
> higher than it'd ordinarily be.
>
> But, you didn't mention having backups, and did mention that you
> didn't have a spare hdd so would have to break the array to have a
> place to do a btrfs restore to, which reads very much like you don't
> have ANY BACKUPS AT ALL!!
>
> Of course, in the context of the above backups rule, I guess you
> understand the implications, that you consider the value of that data
> essentially throw-away, particularly since you still don't have a
> backup, despite running a not entirely stable filesystem that puts
> the data at greater risk than would a fully stable filesystem.
>
> Which means no big deal.  You've obviously saved the time, hassle and
> resources necessary to make that backup, which is obviously of more
> value to you than the data that's not backed up, so the data is
> obviously of low enough value you can simply blow away the filesystem
> with a fresh mkfs and start over. =:^)
>
> Except... were that the case, you probably wouldn't be posting.
>
> Which brings entirely new urgency to what CM said about getting that
> spare hdd, so you can actually create that backup, and count yourself
> very lucky if you don't lose your data before you have it backed up,
> since your previous actions were unfortunately not in accordance with
> the value you seem to be claiming for the data.

Yes, there are things that rank higher in priority than backups of
the data in question. Namely food and shelter. The mirror drives
is all I could scrounge together after several months. The previous
setup was JBOD of 9 disks no younger than 7 years. At the point of
replacement I was so wary of the hardware giving in that I didn't even
think about potential software issues.

I chose btrfs as a means to "future-proof" the storage. For me it won
out against zfs for it's superior re-shapaing capability in terms of
RAID modes and adding disks to existing arrays.

>
> OK, the rest of this post is written with the assumption that your
> claims and your actions regarding the value of the data in question,
> agree, and that since you're still trying to recover the data, you
> don't consider it just throw-away, which means you now have someplace
> to put that backup, should you actually be lucky enough to get the
> chance to make it...

An additional drive of matching capacity won't be within my financial
means for several months, sadly.
I DO still have the old drives in storage. While they are of very
questionable reliability, I'm confident I can get most of the data
back from those.
None of it is *essential* data. I can always re-rip my music,
re-download most of the other media and re-create the rest from raw
sources. But given the hassle in time and bandwidth I can invest some
hours on and off to try to pull it from the drives as well.

>
>
> With your try to mount, did you try the degraded mount option?  That's
> primarily what this post is about as it's not clear you did, and what
> I'd try first, as without that, btrfs will normally refuse to mount
> if a device is missing, failing with the rather generic ctree open
> failure error, as your attempt did.
>
> And as CM suggests, trying the degraded,ro mount options together is a
> wise idea, at least at first, in ordered to help prevent further
> damage.
>
> If a degraded,ro mount fails, then it's time to try CM's suggestions.

I had tried a degraded,ro mount early on. I don't know why I didn't
include that in my first mail. The result is as follows:

[13984.341838] BTRFS info (device sdc2): allowing degraded mounts
[13984.341844] BTRFS info (device sdc2): disk space caching is enabled
[13984.341846] BTRFS: has skinny extents
[13984.538637] BTRFS critical (device sdc2): corrupt leaf, bad key
order: block=6513625202688,root=1, slot=68 [13984.546327] BTRFS
critical (device sdc2): corrupt leaf, bad key order:
block=6513625202688,root=1, slot=68 [13984.552233] BTRFS: Failed to
read block groups: -5 [13984.585375] BTRFS: open_ctree failed
[13997.313514] BTRFS info (device sdb2): allowing degraded mounts
[13997.313520] BTRFS info (device sdb2): disk space caching is enabled
[13997.313522] BTRFS: has skinny extents [13997.522838] BTRFS critical
(device sdb2): corrupt leaf, bad key order: block=6513625202688,root=1,
slot=68 [13997.530175] BTRFS critical (device sdb2): corrupt leaf, bad
key order: block=6513625202688,root=1, slot=68 [13997.538289] BTRFS:
Failed to read block groups: -5 [13997.582019] BTRFS: open_ctree failed


>
> [...]
>

So I can't mount either disk as ro and I can't afford another drive
to store the data.

I can confirm that I can get at least a subset of the data off the
drives via btrfs-restore. (In fact I already restored the only chunk of
data that's newer than the old disk set AND not easily recreated, which
makes the whole endeavour a bit less nerve-wracking.)

As I see it, my best course of action right now is wiping one of the
two disks and then using btrfs restore to copy the data off the other
disk onto the now blank one. I'd expect to get back a large percentage
of the inaccessible data that way. That is unless someone tells me
there's an easy fix for the "corrupt leaf, bad key order" fault and
I've been chasing ghosts the whole time.

> ---
> [1] Sysadmin's first rule of backups:  The more complex form covers
> multiple backups and accounts for the risk factor of actually needing
> to use them.  It says that for any level of backup, either you have
> it, or you consider the value of the data multiplied by the risk
> factor of having to actually use that level of backup, to be less
> than the resource and hassle cost of making that backup.  In this
> form, data such as your internet cache is probably not worth enough
> to justify even a single level of backup, while truly valuable data
> might be worth 101 levels of backup or more, some of them offsite and
> others onsite but not normally physically connected, because the data
> is truly valuable enough that even multiplied by the extremely tiny
> chance of actually having 100 levels of backup fail and actually
> needing that 101st level, justifies having it.

The data is certainly worth another level of security, the problem is I
can't afford it. Basically the amount I have accumulated has outstripped
my means to properly store it. I'm trying my best with what's available.

And no, I wouldn't trust data to this storage that could have a
financial or personal impact if lost.

-- 
Alex
