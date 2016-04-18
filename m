Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36347 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcDRONa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 10:13:30 -0400
Received: by mail-lf0-f46.google.com with SMTP id g184so218267036lfb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 07:13:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20160418T092105-74@post.gmane.org>
Date: Mon, 18 Apr 2016 16:13:28 +0200
Message-ID: <CAPmG0jbDDG+aLHn+ymBT1Mbd2UZg17rDiwYXu8AYoxb666GXMA@mail.gmail.com>
Subject: Re: btrfs-image and btrfs send related queries
From: Henk Slager <eye1tm@gmail.com>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160415T142724-462@post.gmane.org>
 <20160415124910.GD30971@carfax.org.uk>
 <CAPmG0jbp15p6shXq2GtVude_AKTcN2xRDwki0M5m-iiC_Wh51g@mail.gmail.com>
 <loom.20160418T092105-74@post.gmane.org>

(your email keeps ending up in gmail spam folder)

On Mon, Apr 18, 2016 at 9:24 AM, sri <toyours_sridhar@yahoo.co.in> wrote:
> I tried btrfs-image and created image file and ran btrfs-image -r to a
> different disk. Once recovered and mounted, I can able to see data is
> not zeroed out as mentioned in btrfs-image man page.

"different disk"  you mention, that is important info. If you doe the
restore to a image file, that image file is sparse and all data blocks
are read as zeros.

However, if you restore to a block device, then you can assume it just
writes the device blocks for metadata and leaves the rest untouched.
So trim whole device first or brute-force overwrite completely with
zeros.

So maybe the man pages needs some correction / extra notes.

> I tried on same machine.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
