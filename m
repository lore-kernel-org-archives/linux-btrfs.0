Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:25696 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaC0DXw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 23:23:52 -0400
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Received: from [192.168.2.90]
 (modemcable211.176-81-70.mc.videotron.ca [70.81.176.211])
 by VL-VM-MR005.ip.videotron.ca
 (Oracle Communications Messaging Exchange Server 7u4-22.01 64bit (built Apr 21
 2011)) with ESMTPA id <0N3200DVDS3J1H50@VL-VM-MR005.ip.videotron.ca> for
 linux-btrfs@vger.kernel.org; Wed, 26 Mar 2014 23:23:43 -0400 (EDT)
Message-id: <533399AF.4070802@polymtl.ca>
Date: Wed, 26 Mar 2014 23:23:27 -0400
From: Christian Robert <christian.robert@polymtl.ca>
To: Evan Powell <epowell@zenoss.com>, Matt <jackdachef@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Some impossible benchmark results with LUKS - what am I missing?
References: <15dcc559-9c13-467f-8fcf-2611d7f791ce@zimbra1.zenoss.com>
In-reply-to: <15dcc559-9c13-467f-8fcf-2611d7f791ce@zimbra1.zenoss.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only thing I can see is Lurk is not passing the barrier (do that writes in sequence then ack) to the devices.
so it act as a caching device (dangerous for btrfs point of view).

I'm *no* expert in that matter at all.

I may be wrong.

Xtian.

On 2014-03-26 21:56, Evan Powell wrote:
> Order did not matter - I have run a few tests showing this same disparity in both orders.
>
> I reran this evening using the drop_caches command you provided, no change in throughput results. The improvement I've seen has been present through multiple reboots so far, and clearing RAM using dd on different test files. Doesn't look like it's caching causing this, so I'm still stumped.
>
> Output of cryptsetup luksDump is similar on all 4 devices:
>
> Version:       	1
> Cipher name:   	aes
> Cipher mode:   	xts-plain64
> Hash spec:     	sha1
> Payload offset:	4102
> MK bits:       	256
> ...
> (followed by different iterations and salts)
>
> (Offtopic: migrating between encrypted and unencrypted drives is really painless on btrfs: rebalance to raid1, delete two devices, remove their encrypted volumes, readd the devices, remove and readd the 2 remaining encrypted disks without encryption, rebalance to raid10. All live, without losing data! This is awesome!)
>
> Evan Powell | Technical Lead
> epowell@zenoss.com
>
> ----- Original Message -----
>
> From: "Matt" <jackdachef@gmail.com>
> To: "Evan Powell" <epowell@zenoss.com>
> Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
> Sent: Wednesday, March 26, 2014 4:47:19 PM
> Subject: Some impossible benchmark results with LUKS - what am I missing?
>
>> Hey folks,
>
>> I have been experimenting with btrfs on a home NAS box, and have some benchmark \
>> results that I don't believe. I'm hoping someone here has some insight on what I've \
>> missed that would cause such a result.
>
>> The short version: I'm seeing roughly a 36% (on write) to 55% (on read) performance \
>> *improvement* when using btrfs on LUKS containers over btrfs on raw disks. This \
>> should not be the case!
>
>> The test setup:
>> My test file is a large file that I previously generated from /dev/urandom. I saw \
>> similar results using /dev/zero as input, as well as a repeated copy of the whole \
>> Ubuntu 14.04 ISO (i.e., real-ish data).
>
>> My calculated MB/s numbers are based on the 'real' time in the output.
>
>> Live-booted Ubuntu 14.04 (nightly from 3/11/14, kernel 3.13.5)
>> 4x 4TB WD Red drives in standard (no RAID) configuration
>> i3-4130 CPU (has AES-NI for accelerated encryption)
>> Default BTRFS options from the disk gui, always raid10.
>
>> Tested configurations:
>> Raw: btrfs raid10 on 4x raw drives
>> Encrypted: btrfs raid10 on 4 separate LUKS containers on 4x raw drives (default LUKS \
>> options)
>
>
>> Read command: $ time sh -c "dd if=test.out of=/dev/null bs=4k"
>> Raw:
>> 5120000+0 records in
>> 5120000+0 records out
>> 20971520000 bytes (21 GB) copied, 149.841 s, 140 MB/s
>
>> real 2m29.849s
>> user 0m2.764s
>> sys 0m7.064s
>
>> = 133.467690809 MB/s
>
>> Encrypted:
>> $ time sh -c "dd if=test2.out of=/dev/null bs=4k"
>> 5120000+0 records in
>> 5120000+0 records out
>> 20971520000 bytes (21 GB) copied, 96.6127 s, 217 MB/s
>
>> real 1m36.627s
>> user 0m3.331s
>> sys 0m9.518s
>
>> = 206.981485506 MB/s
>
>
>> Read+Write: $ time sh -c "dd if=test2.out of=test20grand.out bs=4k && sync"
>> Raw:
>> 5120000+0 records in
>> 5120000+0 records out
>> 20971520000 bytes (21 GB) copied, 227.069 s, 92.4 MB/s
>
>> real 3m49.701s
>> user 0m2.854s
>> sys 0m15.936s
>
>> = 87.069712365 MB/s
>
>> Encrypted:
>> 5120000+0 records in
>> 5120000+0 records out
>> 20971520000 bytes (21 GB) copied, 167.823 s, 125 MB/s
>
>> real 2m48.784s
>> user 0m2.955s
>> sys 0m17.956s
>
>> = 118.494644042 MB/s
>
>
>> Any ideas what could explain this result?
>
>> One coworker suggested that perhaps the LUKS container was returning from 'sync' \
>> early, before actually finishing the write to disk. This would seem to violate the \
>> assumptions of the 'sync' primitive, so I have my doubts.
>
>> I'm also interested in learning how I can reliably benchmark the real cost of running \
>> full-disk encryption under btrfs on my system.
>
>> Thanks!
>
>
>> Evan Powell | Technical Lead
>> epowell@zenoss.com
>
>
> Hi Evan,
>
> just to be sure:
>
> did you do a
>
> echo 3 > /proc/sys/vm/drop_caches
>
> before *each* test ?
>
> also try reversing the order of tests like so:
>
> Encrypted
> RAW
>
> whether that makes a difference
>
>
> It would also be interesting to see the output of
>
> cryptsetup luksDump
>
> and
>
> Version: *
> Cipher name: *
> Cipher mode: *
> Hash spec: *
>
>
>
>
> Interesting find indeed ! Thanks for sharing the finding
>
> I'm currently using Btrfs on an encrypted system partition (without
> AES-NI supported hardware) and things already feel and are faster than
> with ext4
>
> we need to find out what this magic is =)
>
>
> Kind Regards
>
>
> Thanks
>
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
