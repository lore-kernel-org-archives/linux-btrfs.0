Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36472 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeDPPTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 11:19:42 -0400
MIME-Version: 1.0
In-Reply-To: <002ab104-82ad-0187-8bd0-b0b55338ab83@youngman.org.uk>
References: <CAJCQCtQ3r16BYYtrx9rVYauh7JeAp9omWidS4zzwxqvhU1bh+g@mail.gmail.com>
 <5425366f-f339-d6f3-26d1-d02c3ba80671@gmail.com> <002ab104-82ad-0187-8bd0-b0b55338ab83@youngman.org.uk>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Mon, 16 Apr 2018 10:19:21 -0500
Message-ID: <CAAMCDefUsE2avk9tv3_46g7khWpNWnbY9DAS6VpomRt0MkgDjQ@mail.gmail.com>
Subject: Re: Add udev-md-raid-safe-timeouts.rules
To: "Wol's lists" <antlists@youngman.org.uk>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        LVM general discussion and development
        <linux-lvm@redhat.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And then there are SAN devices managed by multipath, were the timeouts
should maybe even lower.  I know in the scsi layer there are some
extra retries going on and that that actual timeout hits at 5x the
base timeout.  So there kind of is a soft timeout on SAN devices at
the base timeout.    Though there are no messages before the 5x
timeout message indicating that the system is having issues at least
in the SAN case.

For mdraid it should almost be a parameter defined on the md-device to
override the timeout since one could have some disks with ERC and some
without.  Multipath.conf has a setting fast_io_fail_tmo that is
supposed to set the scsi timeout to that value if set.

On Mon, Apr 16, 2018 at 10:02 AM, Wol's lists <antlists@youngman.org.uk> wrote:
> On 16/04/18 12:43, Austin S. Hemmelgarn wrote:
>>
>> On 2018-04-15 21:04, Chris Murphy wrote:
>>>
>>> I just ran into this:
>>>
>>> https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec
>>>
>>> This solution is inadequate, can it be made more generic? This isn't
>>> an md specific problem, it affects Btrfs and LVM as well. And in fact
>>> raid0, and even none raid setups.
>>>
>>> There is no good reason to prevent deep recovery, which is what
>>> happens with the default command timer of 30 seconds, with this class
>>> of drive. Basically that value is going to cause data loss for the
>>> single device and also raid0 case, where the reset happens before deep
>>> recovery has a chance. And even if deep recovery fails to return user
>>> data, what we need to see is the proper error message: read error UNC,
>>> rather than a link reset message which just obfuscates the problem.
>>
>>
>> This has been discussed at least once here before (probably more times,
>> hard to be sure since it usually comes up as a side discussion in an only
>> marginally related thread).
>
>
> Sorry, but where is "here"? This message is cross-posted to about three
> lists at least ...
>
>  Last I knew, the consensus here was
>>
>> that it needs to be changed upstream in the kernel, not by adding a udev
>> rule because while the value is technically system policy, the default
>> policy is brain-dead for anything but the original disks it was i9ntended
>> for (30 seconds works perfectly fine for actual SCSI devices because they
>> behave sanely in the face of media errors, but it's horribly inadequate for
>> ATA devices).
>>
>> To re-iterate what I've said before on the subject:
>>
> imho (and it's probably going to be a pain to implement :-) there should be
> a soft time-out and a hard time-out. The soft time-out should trigger "drive
> is taking too long to respond" messages that end up in a log - so that
> people who actually care can keep a track of this sort of thing. The hard
> timeout should be the current set-up, where the kernel just gives up.
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
