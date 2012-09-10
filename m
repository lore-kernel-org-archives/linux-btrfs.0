Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37852 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2IJJ25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 05:28:57 -0400
Received: by obbuo13 with SMTP id uo13so2580913obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 02:28:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201209101112.34839.Martin@lichtvoll.de>
References: <20120908165620.GA17951@merlins.org>
	<201209101112.34839.Martin@lichtvoll.de>
Date: Mon, 10 Sep 2012 16:21:55 +0700
Message-ID: <CAG1y0scP+O9kTLiF5ZpxRwZTbOFQWctQDquCu4ATSwYyE3SZmQ@mail.gmail.com>
Subject: Re: Workaround for hardlink count problem?
From: "Fajar A. Nugraha" <list@fajar.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2012 at 4:12 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Samstag, 8. September 2012 schrieb Marc MERLIN:
>> I was migrating a backup disk to a new btrfs disk, and the backup had a
>> lot of hardlinks to collapse identical files to cut down on inode
>> count and disk space.
>>
>> Then, I started seeing:
> […]
>> Has someone come up with a cool way to work around the too many link
>> error and only when that happens, turn the hardlink into a file copy
>> instead? (that is when copying an entire tree with millions of files).
>
> What about:
>
> - copy first backup version
> - btrfs subvol create first next
> - copy next backup version
> - btrfs subvol create previous next

Wouldn't "btrfs subvolume snapshot", plus "rsync --inplace" more
useful here? That is. if the original hardlink is caused by multiple
versions of backup of the same file.

Personally, if I need a feature not currently impelented yet in btrfs,
I'd just switch to something else for now, like zfs. And revisit btrfs
later when it has the needed features have been merged.

-- 
Fajar
