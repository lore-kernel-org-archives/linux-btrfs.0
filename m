Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70460C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 11:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB87D2173C
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 11:31:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=petezilla.co.uk header.i=@petezilla.co.uk header.b="VcMeemhM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbeLXLbL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:31:11 -0500
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:40913 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbeLXLbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 06:31:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=petezilla.co.uk; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qJzQT+te5L+ujCE4TCfIw809Mn5CD17jUezyPGJh384=; b=VcMeemhM/pVHALOm4mx4Ih+l7F
        OVEfmkskU+XKnZ+1eQnqE42zISVknNGTJOG22YPPFcoscLGIlz3B6TJECi69Z49vbLBCr2hF4UKyg
        rBwYPgBRUzAoTOIqEzDI1MRyd4HVr5hZxE6qstvR924Y0W2UFual4nTU2ARiRxnmmvjyydsVdQOZU
        /P/aghfqW/8I7jA3VgnSdo8ReXNkno4MM7tUxakY1aUV2ckcRG/4J+u0fSorTC3MhXW4ILUphel2r
        YPZmkVrZy9pVN3tltmLCGfNvLy+hyQXNcyNzy38zRwRUP0LK6J9qFiiLwe30sKkvWd6qD3ypP5X1J
        Bwk59LHA==;
Received: from cpc75874-ando7-2-0-cust841.15-1.cable.virginm.net ([86.12.75.74]:56074 helo=[172.16.100.1])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <pete@petezilla.co.uk>)
        id 1gbORv-007iLO-PK; Mon, 24 Dec 2018 11:31:09 +0000
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
From:   Peter Chant <pete@petezilla.co.uk>
Message-ID: <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
Date:   Mon, 24 Dec 2018 11:31:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-0.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - phi.wiserhosting.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petezilla.co.uk
X-Get-Message-Sender-Via: phi.wiserhosting.co.uk: authenticated_id: pete+petezilla.co.uk/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: phi.wiserhosting.co.uk: pete@petezilla.co.uk
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/24/18 12:58 AM, Chris Murphy wrote:
> On Sat, Dec 22, 2018 at 10:22 AM Peter Chant <pete@petezilla.co.uk> wrote:
> 
>> btrfs rescue super -v /dev/sdb2
> ...
>> All supers are valid, no need to recover
>>
>>
>> btrfs insp dump-s -f <dev>
> ...
>> generation              7937947
> ...
>>         backup 0:
>>                 backup_tree_root:       1113909100544   gen: 7937935    level: 1
> ...
>>         backup 1:
>>                 backup_tree_root:       1113907347456   gen: 7937936    level: 1
> ...
>>         backup 2:
>>                 backup_tree_root:       1113911951360   gen: 7937937    level: 1
> ...
>>         backup 3:
>>                 backup_tree_root:       1113907494912   gen: 7937934    level: 1
> ...
> 
> 
> The kernel wrote out three valid checksummed supers, with what seems
> to be a rather significant sanity violation. The super generation and
> tree root address do not match any of the backup tree roots. The
> *current* tree root is supposed to be in one of the backups as well.
> 

I wonder if this is a result of my trying to fix things?  E.g. btrfs
rescue super-recover or my attempts using the tools (and kernel) in Mint
18.1 at one point?

I must admit, early on I had assumed that either this file system was a
simple fix or was completely trashed, so I thought I'd have a quick go
at fixing it, or wipe it and start again.  But then I seemed to get
close with only the one error, but unmountable.


> Qu, any idea how this is even theoretically possible? Bit flip right
> before the super is computed and checksummed? Seems like some kind of
> corruption before checksum is computed.
> 
> 
>> I'm getting suspicious of the drive as when I was trying the various
>> btrfs rescue * tools I saw a 'bad block', or similar, error displayed.
>> I also have a separate basic install on ext4 on the same disk.  Though
>> e2fsck shows no errors and mounts fine I cannot log into that install.
>> Maybe a coincidence, but too many bad things thrown up make me
>> suspicious.  Whatever is happening this seems to be really fighting me.
> 
> I'm not sure how even a bad device accounts for the super generation
> and backup mismatches. That's damn strange.

I'm less suspicious of the drive now.  I've been using an ext4 partition
on the same drive for a few days now, having reinstalled on that and
everything _seems_ fine.  Mind you, apart from usb sticks, I've not
experienced a ssd failure.  Perhaps my hdd failure experience is not
relevent, i.e. they work until they start throwing errors and then
rapidly fail?


> 
> If you get bored with the back and forth and just want to give up,
> that's fine. I suggest that if you have the time and space, to take a
> btrfs-image in case Qu or some other developer wants to look at this
> file system at some point. The btrfs-image is a read only process, can
> be set to scrub filenames, and only contains metadata. Size of the
> resulting file is around 1/2 of the size of metadata, when doing
> 'btrfs filesystem usage' or 'btrfs filesystem df'. So you'll need that
> much free space to direct the command to.
> 
> btrfs-image -ss -c9 -t4 <devicetoimage> pathtofile

Just done that:
bash-4.3# btrfs-image -ss -c9 -t4 /dev/sdd2
/mnt/backup/btrfs_issue_dec_2018/btrfs_root_image_error_20181224.img
WARNING: cannot find a hash collision for '..', generating garbage, it
won't match indexes



> 
> It might fail, if so you can try adding -w and see if that helps.


OK, try with -w:

OK, many many complaints about hash collisions:
...
ARNING: cannot find a hash collision for 'ifup', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'catv', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'FDPC', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'LIBS', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'INTC', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'SPI', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'PDCA', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'EBI', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'SMC', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'WIFI', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'LWIP', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'HID', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'yun', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'avr4', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'avr6', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'WiFi', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'TFT', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'Knob', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'FP.h', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'SD.h', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'Beep', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'FORK', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'CHM', generating garbage, it
won't match indexes
WARNING: cannot find a hash collision for 'HandS', generating garbage,
it won't match indexes
WARNING: cannot find a hash collision for 'dm-0', generating garbage, it
won't match indexes


Now seems to stopped producing output.  Can't see if it is doing
something useful.  (note, started again, more such messages)


> 
> There is no log listed in the super so zero-log isn't indicated, and
> also tells me there were no fsync's still flushing at the time of the
> crash. The loss should be at most a minute of data, not an
> inconsistent file system that can't be mounted anymore. Pretty weird.
> 

I think I ran zero-log to see if that helped.  Given that there was no
important data and I'd assume I'd either easily fix it, or wipe it and
start over I may have taken the 'monkey radomly pounding the buttons'
approach, short of 'btrfs check --repair'.  I only posted here as I
though I'd fixed it apart from the one error!  If it were a simple fix
then it was worth asking.


> What were your mount options? Defaults? Anything custom like discard,
> commit=, notreelog? Any non-default mount options themselves would not
> be the cause of the problem, but might suggest partial ideas for what
> might have happened.
> 
fstab states:
autodefrag,ssd,discard,noatime,defaults,subvol=_r_sl14.
2,compress=lzo

However, I used an initrd, so I'm not sure if that is correct?

Ok, digging into init within my initrd, the line where the root partion
is mounted:
  mount -o ro -t $ROOTFS $ROOTDEV /mnt

Where $ROOTFS is:
btrfs -o subvol=_r_sl14.2

and $ROOTDEV is:
/dev/disk/by-uuid/6496aabd-d6aa-49e0-96ca-e49c316edd8e



Pete
