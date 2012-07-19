Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46771 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2GSMjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 08:39:46 -0400
Received: by lbbgm6 with SMTP id gm6so3543666lbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 05:39:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207191304.03829.Martin@lichtvoll.de>
References: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com>
	<50076A4C.8080400@stinkt.kicks-ass.org>
	<201207191304.03829.Martin@lichtvoll.de>
Date: Thu, 19 Jul 2012 22:39:45 +1000
Message-ID: <CALa9hx0C8-PpDRFr9fZMtDW95=56XGYHQMnPt5nXOS=2r=tQUA@mail.gmail.com>
Subject: Re: Very slow samba file transfer speed... any ideas ?
From: Shavi N <shavi64@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Bernhard Redl <bernhard@stinkt.kicks-ass.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks.

This is the output:
btrfs:
$ dd if=/dev/zero of=/mnt/shared/misc/temp_file bs=1M count=1400
1400+0 records in
1400+0 records out
1468006400 bytes (1.5 GB) copied, 1.56841 s, 936 MB/s

ext4:
$ dd if=/dev/zero of=/mnt/500/VirutalBox_VMs/thor/thor-data/temp_file
bs=1M count=1400
1400+0 records in
1400+0 records out
1468006400 bytes (1.5 GB) copied, 4.98993 s, 294 MB/s

(just to show:
$ mount
/dev/sdi on /mnt/shared type btrfs (rw,relatime,space_cache)
/dev/sdc1 on /mnt/500 type ext4 (rw,relatime,data=ordered)
)

 $ uname -a
Linux Wolverine 3.4.4-2-ARCH #1 SMP PREEMPT Sun Jun 24 18:59:47 CEST
2012 x86_64 GNU/Linux


So btrfs gives a massive difference locally, but that still doesn't
explain the slow transfer speeds.
Is there a way to test this?

Also I forgot to say, this is on a 1gbit LAN

On Thu, Jul 19, 2012 at 9:04 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Hi!
>
> Am Donnerstag, 19. Juli 2012 schrieb Bernhard Redl:
>> On 07/19/2012 03:42 AM, Shavi N wrote:
>> > Hi,
>> >
>> > I have btrfs volume, shared via samba. I have a directory of
>> > documents that I want to backup on my server. win7 reports a
>> > maximum of ~3.10MB/s transfer transferring the same directory on a
>> > ext4 samba share I get 25MB/s +
>> >
>> > Any ideas? Is it like that because of how btrfs works and is
>> > setup?
>> >
>> > Thanks, -- To unsubscribe from this list: send the line
>> > "unsubscribe linux-btrfs" in the body of a message to
>> > majordomo@vger.kernel.org More majordomo info at
>> > http://vger.kernel.org/majordomo-info.html
>>
>> Did you try creating an huge file directly on your linux host
>> with
>>
>> dd if=/dev/zero of=/mnt/<YOURPATH>/file bs=1M count=1400
>>
>> dd will report the speed afterwards.
>> You can also try copying the documents from ext4 to a ramfs and then
>> copy them from the ramfs to btrfs.
>
> Depending on Samba/CIFS guarantees like "I have really written your file to
> disk" I tend to use at least conv=fsync with dd in order to get any
> realistic value of it.
>
> Cause even an Intel SSD 320 isn´t that fast:
>
> merkaba:~> LANG=C dd if=/dev/zero of=nullen bs=1M count=500 ; rm nullen
> 500+0 records in
> 500+0 records out
> 524288000 bytes (524 MB) copied, 0.222668 s, 2.4 GB/s
> merkaba:~> LANG=C dd if=/dev/zero of=nullen bs=1M count=500 ; rm nullen
> 500+0 records in
> 500+0 records out
> 524288000 bytes (524 MB) copied, 0.255779 s, 2.0 GB/s
> merkaba:~> LANG=C dd if=/dev/zero of=nullen bs=1M count=500 ; rm nullen
> 500+0 records in
> 500+0 records out
> 524288000 bytes (524 MB) copied, 0.360679 s, 1.5 GB/s
> merkaba:~> LANG=C dd if=/dev/zero of=nullen bs=1M count=500 ; rm nullen
> 500+0 records in
> 500+0 records out
> 524288000 bytes (524 MB) copied, 0.289096 s, 1.8 GB/s
>
> (due to the rm directly afterwards, the pagecache and the delayed
> allocation feature in modern filesystems most of that data did not hit the
> device at all. Nicely viewable in atop as WRDSK_CANCEL ;)
>
> So dd often is not a disk but a memory benchmark. I just wanted to spread
> this knowledge once again, cause I see it again and again that people try
> to measure disk or filesystem speed with dd when they in reality measure
> mem speed.
>
>
> And just to circumvent any with 1.4 GiB that would not have happened
> argument:
>
> merkaba:~> LANG=C dd if=/dev/zero of=nullen bs=1M count=1400 ; rm nullen
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 1.34418 s, 1.1 GB/s
> merkaba:~> LANG=C dd if=/dev/zero of=nullen bs=1M count=1400 ; rm nullen
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 1.27035 s, 1.2 GB/s
> merkaba:~> LANG=C dd if=/dev/zero of=nullen bs=1M count=1400 ; rm nullen
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 1.43545 s, 1.0 GB/s
>
>
> Nonetheless be gentle:
>
> merkaba:~> fstrim -v /
> /: 8204824576 bytes were trimmed
>
>
>
> merkaba:~> free -m
>              total       used       free     shared    buffers     cached
> Mem:          7767       3849       3918          0        181        809
> -/+ buffers/cache:       2859       4908
> Swap:        12287          7      12280
> merkaba:~> uname -a
> Linux merkaba 3.5.0-rc7-tp520-toi-3.3-timekeeping+ #2 SMP PREEMPT Mon Jul
> 16 19:08:43 CEST 2012 x86_64 GNU/Linux
>
>
> As to my knowledge the Intel SSD 320 does not have internal compression,
> but BTRFS even was mounted with compress=lzo here. So zeros are bogus in
> that test case anyway – since I do not know any compressing harddisks they
> may just be a valid test case with a Samba fileserver.
>
>
> With Ext4 without compression its slower:
>
> merkaba:/home> LANG=C dd if=/dev/zero of=nullen bs=1M count=1400 ; rm
> nullen
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 4.25201 s, 345 MB/s
> merkaba:/home> LANG=C dd if=/dev/zero of=nullen bs=1M count=1400 ; rm
> nullen
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 4.22669 s, 347 MB/s
>
>
> But thats still more than the SATA-300 bus can yield:
>
> merkaba:/home> LANG=C dd if=/dev/zero of=nullen bs=1M count=1400
> conv=fsync ; rm nullen
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 6.74884 s, 218 MB/s
>
>
> Also note: dd is mixing up MiB and MB. Output used 1000 and input it 1024
> as base.
>
> So enough of that now. fstrimming again.
>
> Ciao,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
