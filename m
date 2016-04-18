Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36170 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbcDRTsU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 15:48:20 -0400
Received: by mail-lf0-f45.google.com with SMTP id g184so229663945lfb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 12:48:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160418192619.4749bc17@natsu>
Date: Mon, 18 Apr 2016 21:48:18 +0200
Message-ID: <CAPmG0jb0e5L=BYbO7k-4qh+o4qNqEjDqLe1=04+QMSWyhk0hFg@mail.gmail.com>
Subject: Re: btrfs-image and btrfs send related queries
From: Henk Slager <eye1tm@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: sri <toyours_sridhar@yahoo.co.in>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160415T142724-462@post.gmane.org>
 <20160415124910.GD30971@carfax.org.uk>
 <CAPmG0jbp15p6shXq2GtVude_AKTcN2xRDwki0M5m-iiC_Wh51g@mail.gmail.com>
 <loom.20160418T092105-74@post.gmane.org>
 <CAPmG0jbDDG+aLHn+ymBT1Mbd2UZg17rDiwYXu8AYoxb666GXMA@mail.gmail.com>
 <20160418192619.4749bc17@natsu>

On Mon, Apr 18, 2016 at 4:26 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Mon, 18 Apr 2016 16:13:28 +0200
> Henk Slager <eye1tm@gmail.com> wrote:
>
>> (your email keeps ending up in gmail spam folder)
>>
>> On Mon, Apr 18, 2016 at 9:24 AM, sri <toyours_sridhar@yahoo.co.in> wrote:
>> > I tried btrfs-image and created image file and ran btrfs-image -r to a
>> > different disk. Once recovered and mounted, I can able to see data is
>> > not zeroed out as mentioned in btrfs-image man page.
>>
>> "different disk"  you mention, that is important info. If you doe the
>> restore to a image file, that image file is sparse and all data blocks
>> are read as zeros.
>>
>> However, if you restore to a block device, then you can assume it just
>> writes the device blocks for metadata and leaves the rest untouched.
>> So trim whole device first or brute-force overwrite completely with
>> zeros.
>>
>> So maybe the man pages needs some correction / extra notes.
>>
>> > I tried on same machine.
>
> Does btrfs-image store/restore the FS UUID? If it does, then potentially both
> the source FS and the restored one were visible at the same time to the kernel
> with identical UUIDs, and maybe it was actually accessing/mounting the source
> one.

Very good point! The UUID's are the same. I remember I used a VM to
separate the source FS from the restored FS

Also, the assumption I made about restoring to a block device is not
correct: If you restore to a loopdev that has a file with all
non-zeros as backing-store, the files in the mounted restored FS are
read as zeros.
