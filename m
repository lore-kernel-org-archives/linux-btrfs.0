Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,FROM_EXCESS_BASE64,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA2CC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 12:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE6F021850
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 12:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaliza-cz.20150623.gappssmtp.com header.i=@metaliza-cz.20150623.gappssmtp.com header.b="I/qbm101"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbeLXMsX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 07:48:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33515 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbeLXMsX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 07:48:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so11497185wrr.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2018 04:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaliza-cz.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sg2CiySjsuULVuXZtiqYSvn4+YJvhVcdJVJ13i9MraQ=;
        b=I/qbm101CgHpp7qL0lA34iq9kq4M8Cn7haICUcgy/f1jbJi2n06Mzok2MMCUhEl1s/
         0MikFBcvoMIixxe/ycJqJSBtXaLxCZ2hPZZmlTgd5X/UlhDv/NRVg5UWpc4zFfWSq2IJ
         FyU7mVUZplfO1WY17vJHOF8+yt7HjxaUbOpkiHEu4hfyXcQdE8FytF0wM5ktwAIucgol
         NlZyhe141mJ2NyrXSNZUSHJUO9KYP8s6k0Vr3sbhtYWQK7SCjxg0snZMx2qLxAo5mjxV
         eq+BWlY3AX3+amIOBfBny2noGDSfQl6l1N6cSLucQcn7zk1QOu7Xy0d/fWUG6Pv5uk5R
         b9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sg2CiySjsuULVuXZtiqYSvn4+YJvhVcdJVJ13i9MraQ=;
        b=K24dujI8mL9WMnIE3n/vOeYKdKsy0SCVokhkM7Rc6+iuWBEruT3z8ro5e6sDVXrWnV
         I7S5POdJgRZ7sboLMDnhqTL5ZF5Z6qS0ELji1Z+Jrvopn1MIi1NEFiE+n7VhEa50JY8d
         CIr9/9AR1Fs44F22QoMZ3CpXyc/OjaasllJQ0HIZDvv6czf0ZtgbVWtuyAV6Q7lM49+8
         hZOFMdx5Pgy6WIDG/SnH6S8IoP66kdujL1aKc8qfCQRNXui7dlByXOFxmnrmJihEt0dd
         9qY1kbObGd2H4xb++YOnrKLzAZQcU3veaWBWG4BAnwW1hsCVgmFdqw99DzCPmzsE3w/o
         a5gQ==
X-Gm-Message-State: AJcUukdYeNDlytJymP3v9deDucsaWavjQNeXJKsrOEvgMe77vnFabAx4
        ldnlueC78OY74J8VhJ6yeLFaWjK30pY2hg==
X-Google-Smtp-Source: ALg8bN67ArQGdsQNgcaQej9g3qXuQBtauMJCdeATfQlXFQ42YFDJHqt9Z0/NAO3H/WTxqy0Ofh6Wvw==
X-Received: by 2002:adf:f091:: with SMTP id n17mr11763294wro.292.1545655699330;
        Mon, 24 Dec 2018 04:48:19 -0800 (PST)
Received: from ?IPv6:2a00:1028:96c8:10a2:6031:a913:d419:3220? (dynamic-2a00-1028-96c8-10a2-6031-a913-d419-3220.ipv6.broadband.iol.cz. [2a00:1028:96c8:10a2:6031:a913:d419:3220])
        by smtp.gmail.com with ESMTPSA id c12sm14418858wrs.82.2018.12.24.04.48.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Dec 2018 04:48:18 -0800 (PST)
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Peter Chant <pete@petezilla.co.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
From:   =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Message-ID: <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
Date:   Mon, 24 Dec 2018 13:48:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

just 1 curious question (maybe 2) about your statement "log_root is 0":

What does it mean when log_root is non-zero? Because I have similar 
problem (unmountable FS ... I don't know how much but I know there's 
corrupted 2 subsequent items in chunk tree node) and when I have made 
"btrfs inspect-internal dump-super":

superblock: bytenr=65536, device=/dev/sda4
...
generation		2488742
root			232408301568
sys_array_size		97
chunk_root_generation	2487902
root_level		1
chunk_root		242098421760
chunk_root_level	1
log_root		232433811456
log_root_transid	0
log_root_level		0

superblock: bytenr=67108864, device=/dev/sda4
...
generation		2488742
root			232408301568
sys_array_size		97
chunk_root_generation	2487902
root_level		1
chunk_root		242098421760
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0

Unfortunately when I try to do "btrfs rescue chunk-recover" I get 
(beside others):

"...

Unrecoverable Chunks:
   Chunk: start = 0, len = 4194304, type = 2, num_stripes = 1
       Stripes list:
       [ 0] Stripe: devid = 1, offset = 0
       No block group.
       No device extent.

Total Chunks:		184
   Recoverable:		183
   Unrecoverable:	1

Orphan Block Groups:

Orphan Device Extents:

Chunk tree recovery failed
"

And when I try "btrfs restore -m -S -v -i -D <dev>" I get only:
Could not open root, trying backup super
Could not open root, trying backup super
ERROR: superblock bytenr 274877906944 is larger than device size 
212000047104
Could not open root, trying backup super

Is it possible to recover data (at least some of them)? And is it worth 
to upgrade to newest btrfs-progs?

uname -a:
Linux tisc5 4.15.0-43-generic #46-Ubuntu SMP Thu Dec 6 14:45:28 UTC 2018 
x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.15.1

Thanks
Metaliza


On 24. 12. 18 13:02, Qu Wenruo wrote:
> 
> 
> On 2018/12/24 下午7:31, Peter Chant wrote:
>> On 12/24/18 12:58 AM, Chris Murphy wrote:
>>> On Sat, Dec 22, 2018 at 10:22 AM Peter Chant <pete@petezilla.co.uk> wrote:
>>>
>>>> btrfs rescue super -v /dev/sdb2
>>> ...
>>>> All supers are valid, no need to recover
>>>>
>>>>
>>>> btrfs insp dump-s -f <dev>
>>> ...
>>>> generation              7937947
>>> ...
>>>>          backup 0:
>>>>                  backup_tree_root:       1113909100544   gen: 7937935    level: 1
>>> ...
>>>>          backup 1:
>>>>                  backup_tree_root:       1113907347456   gen: 7937936    level: 1
>>> ...
>>>>          backup 2:
>>>>                  backup_tree_root:       1113911951360   gen: 7937937    level: 1
>>> ...
>>>>          backup 3:
>>>>                  backup_tree_root:       1113907494912   gen: 7937934    level: 1
>>> ...
>>>
>>>
>>> The kernel wrote out three valid checksummed supers, with what seems
>>> to be a rather significant sanity violation. The super generation and
>>> tree root address do not match any of the backup tree roots. The
>>> *current* tree root is supposed to be in one of the backups as well.
>>>
>>
>> I wonder if this is a result of my trying to fix things?  E.g. btrfs
>> rescue super-recover or my attempts using the tools (and kernel) in Mint
>> 18.1 at one point?
> 
> At least super-recover is not responsible for this.
> While btrfs check --repair could indeed cause problems.
> 
> So it may be the case.
> 
>>
>> I must admit, early on I had assumed that either this file system was a
>> simple fix or was completely trashed, so I thought I'd have a quick go
>> at fixing it, or wipe it and start again.  But then I seemed to get
>> close with only the one error, but unmountable.
>>
>>
>>> Qu, any idea how this is even theoretically possible? Bit flip right
>>> before the super is computed and checksummed? Seems like some kind of
>>> corruption before checksum is computed.
>>>
>>>
>>>> I'm getting suspicious of the drive as when I was trying the various
>>>> btrfs rescue * tools I saw a 'bad block', or similar, error displayed.
>>>> I also have a separate basic install on ext4 on the same disk.  Though
>>>> e2fsck shows no errors and mounts fine I cannot log into that install.
>>>> Maybe a coincidence, but too many bad things thrown up make me
>>>> suspicious.  Whatever is happening this seems to be really fighting me.
>>>
>>> I'm not sure how even a bad device accounts for the super generation
>>> and backup mismatches. That's damn strange.
>>
>> I'm less suspicious of the drive now.  I've been using an ext4 partition
>> on the same drive for a few days now, having reinstalled on that and
>> everything _seems_ fine.  Mind you, apart from usb sticks, I've not
>> experienced a ssd failure.  Perhaps my hdd failure experience is not
>> relevent, i.e. they work until they start throwing errors and then
>> rapidly fail?
> 
> I don't really believe a drive can be so easily corrupted to certain
> bits while all other bits are OK.
> 
>>
>>
>>>
>>> If you get bored with the back and forth and just want to give up,
>>> that's fine. I suggest that if you have the time and space, to take a
>>> btrfs-image in case Qu or some other developer wants to look at this
>>> file system at some point. The btrfs-image is a read only process, can
>>> be set to scrub filenames, and only contains metadata. Size of the
>>> resulting file is around 1/2 of the size of metadata, when doing
>>> 'btrfs filesystem usage' or 'btrfs filesystem df'. So you'll need that
>>> much free space to direct the command to.
>>>
>>> btrfs-image -ss -c9 -t4 <devicetoimage> pathtofile
>>
>> Just done that:
>> bash-4.3# btrfs-image -ss -c9 -t4 /dev/sdd2
>> /mnt/backup/btrfs_issue_dec_2018/btrfs_root_image_error_20181224.img
>> WARNING: cannot find a hash collision for '..', generating garbage, it
>> won't match indexes
>>
>>
>>
>>>
>>> It might fail, if so you can try adding -w and see if that helps.
>>
>>
>> OK, try with -w:
>>
>> OK, many many complaints about hash collisions:
>> ...
>> ARNING: cannot find a hash collision for 'ifup', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'catv', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'FDPC', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'LIBS', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'INTC', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'SPI', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'PDCA', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'EBI', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'SMC', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'WIFI', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'LWIP', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'HID', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'yun', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'avr4', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'avr6', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'WiFi', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'TFT', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'Knob', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'FP.h', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'SD.h', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'Beep', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'FORK', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'CHM', generating garbage, it
>> won't match indexes
>> WARNING: cannot find a hash collision for 'HandS', generating garbage,
>> it won't match indexes
>> WARNING: cannot find a hash collision for 'dm-0', generating garbage, it
>> won't match indexes
>>
>>
>> Now seems to stopped producing output.  Can't see if it is doing
>> something useful.  (note, started again, more such messages)
> 
> I don't know about other developers, normally I don't like btrfs-image
> -ss at all.
> 
> Even plain btrfs-image isn't so helpful, especially considering its size.
> 
> Anyway, from all the data you collected, I suspect it's a corruption in
> tree blocks allocation, maybe a btrfs bug in older kernels, which buried
> a dangerous seed into the fs, breaking the metadata CoW.
> 
> And one day, an unexpected powerloss makes the seed grow and screw up
> the fs.
> 
> Just a personal recommendation, for btrfs especially used with older
> kernels, after a powerloss, it's highly recommended to run btrfs check
> --readonly before mounting it.
> 
> Thanks,
> Qu
> 
>>
>>
>>>
>>> There is no log listed in the super so zero-log isn't indicated, and
>>> also tells me there were no fsync's still flushing at the time of the
>>> crash. The loss should be at most a minute of data, not an
>>> inconsistent file system that can't be mounted anymore. Pretty weird.
>>>
>>
>> I think I ran zero-log to see if that helped.  Given that there was no
>> important data and I'd assume I'd either easily fix it, or wipe it and
>> start over I may have taken the 'monkey radomly pounding the buttons'
>> approach, short of 'btrfs check --repair'.  I only posted here as I
>> though I'd fixed it apart from the one error!  If it were a simple fix
>> then it was worth asking.
>>
>>
>>> What were your mount options? Defaults? Anything custom like discard,
>>> commit=, notreelog? Any non-default mount options themselves would not
>>> be the cause of the problem, but might suggest partial ideas for what
>>> might have happened.
>>>
>> fstab states:
>> autodefrag,ssd,discard,noatime,defaults,subvol=_r_sl14.
>> 2,compress=lzo
>>
>> However, I used an initrd, so I'm not sure if that is correct?
>>
>> Ok, digging into init within my initrd, the line where the root partion
>> is mounted:
>>    mount -o ro -t $ROOTFS $ROOTDEV /mnt
>>
>> Where $ROOTFS is:
>> btrfs -o subvol=_r_sl14.2
>>
>> and $ROOTDEV is:
>> /dev/disk/by-uuid/6496aabd-d6aa-49e0-96ca-e49c316edd8e
>>
>>
>>
>> Pete
>>
> 
