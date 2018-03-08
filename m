Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:37863 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbeCHGes (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 01:34:48 -0500
Received: by mail-lf0-f49.google.com with SMTP id y19-v6so6791112lfd.4
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Mar 2018 22:34:48 -0800 (PST)
Subject: Re: How to change/fix 'Received UUID'
To: Marc MERLIN <marc@merlins.org>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        fdmanana@gmail.com
References: <20180305161619.prnkl4q4zcyibzhc@merlins.org>
 <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com>
 <20180305194718.GC613@merlins.org>
 <b323d987-9d97-f57e-b0d6-4ff405abf91c@mendix.com>
 <20180306200247.svrsko5zr5vldaes@merlins.org>
 <20180308060612.n655pfxsfh2ehrsf@merlins.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <8ef51655-a5cf-f970-e541-1bd9de555548@gmail.com>
Date: Thu, 8 Mar 2018 09:34:45 +0300
MIME-Version: 1.0
In-Reply-To: <20180308060612.n655pfxsfh2ehrsf@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

08.03.2018 09:06, Marc MERLIN пишет:
> On Tue, Mar 06, 2018 at 12:02:47PM -0800, Marc MERLIN wrote:
>>> https://github.com/knorrie/python-btrfs/commit/1ace623f95300ecf581b1182780fd6432a46b24d
>>
>> Well, I had never heard about it until now, thank you.
>>
>> I'll see if I can make it work when I get a bit of time.
> 
> Sorry, I missed the fact that there was no code to write at all.
> gargamel:/var/local/src/python-btrfs/examples# ./set_received_uuid.py 2afc7a5e-107f-d54b-8929-197b80b70828 31337 1234.5678 /mnt/btrfs_bigbackup/DS1/Video_ro.20180220_21:03:41
> Current subvolume information:
>   subvol_id: 94887
>   received_uuid: 00000000-0000-0000-0000-000000000000
>   stime: 0.0 (1970-01-01T00:00:00)
>   stransid: 0  
>   rtime: 0.0 (1970-01-01T00:00:00)
>   rtransid: 0  
> 
> Setting received subvolume...
> 
> Resulting subvolume information:
>   subvol_id: 94887
>   received_uuid: 2afc7a5e-107f-d54b-8929-197b80b70828
>   stime: 1234.5678 (1970-01-01T00:20:34.567800)
>   stransid: 31337
>   rtime: 1520488877.415709329 (2018-03-08T06:01:17.415709)
>   rtransid: 255755
> 
> gargamel:/var/local/src/python-btrfs/examples# btrfs property set -ts /mnt/btrfs_bigbackup/DS1/Video_ro.20180220_21:03:41 ro true
> 
> 
> ABORT: btrfs send -p /mnt/btrfs_pool1/Video_ro.20180205_21:05:15 Video_ro.20180307_22:03:03 |  btrfs receive /mnt/btrfs_bigbackup/DS1//. failed
> At subvol Video_ro.20180307_22:03:03
> At snapshot Video_ro.20180307_22:03:03
> ERROR: cannot find parent subvolume
> 
> gargamel:/mnt/btrfs_pool1# btrfs subvolume show /mnt/btrfs_pool1/Video_ro.20180220_21\:03\:41/
> Video_ro.20180220_21:03:41

Not sure I understand how this subvolume is related. You send
differences between Video_ro.20180205_21:05:15 and
Video_ro.20180307_22:03:03, so you need to have (replica of)
Video_ro.20180205_21:05:15 on destination. How exactly
Video_ro.20180220_21:03:41 comes in picture here?

>         Name:                   Video_ro.20180220_21:03:41
>         UUID:                   2afc7a5e-107f-d54b-8929-197b80b70828
>         Parent UUID:            e5ec5c1e-6b49-084e-8820-5a8cfaa1b089
>         Received UUID:          0e220a4f-6426-4745-8399-0da0084f8b23>         Creation time:          2018-02-20 21:03:42 -0800
>         Subvolume ID:           11228
>         Generation:             4174
>         Gen at creation:        4150
>         Parent ID:              5
>         Top level ID:           5
>         Flags:                  readonly
>         Snapshot(s):
>                                 Video_rw.20180220_21:03:41
>                                 Video
> 
> 
> Wasn't I supposed to set 2afc7a5e-107f-d54b-8929-197b80b70828 onto the destination?
> 
> Doesn't that look ok now? Is there something else I'm missing?
> gargamel:/mnt/btrfs_pool1# btrfs subvolume show /mnt/btrfs_bigbackup/DS1/Video_ro.20180220_21:03:41
> DS1/Video_ro.20180220_21:03:41
>         Name:                   Video_ro.20180220_21:03:41
>         UUID:                   cb4f343c-5e79-7f49-adf0-7ce0b29f23b3
>         Parent UUID:            0e220a4f-6426-4745-8399-0da0084f8b23
>         Received UUID:          2afc7a5e-107f-d54b-8929-197b80b70828
>         Creation time:          2018-02-20 21:13:36 -0800
>         Subvolume ID:           94887
>         Generation:             250689
>         Gen at creation:        250689
>         Parent ID:              89160
>         Top level ID:           89160
>         Flags:                  readonly
>         Snapshot(s):
> 
> Thanks,
> Marc
> 

