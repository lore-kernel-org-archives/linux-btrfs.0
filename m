Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38393 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbbGIGWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 02:22:18 -0400
Received: by igrv9 with SMTP id v9so185730004igr.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 23:22:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
Date: Thu, 9 Jul 2015 13:22:18 +0700
Message-ID: <CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
From: "Fajar A. Nugraha" <list@fajar.net>
To: james harvey <jamespharvey20@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 9, 2015 at 8:20 AM, james harvey <jamespharvey20@gmail.com> wrote:
> Request for new btrfs subvolume subcommand:
>
> clone or fork [-i <qgroupid] <source> [<dest>]<name>
>    Create a subvolume <name> in <dest>, which is a clone or fork of source.
>    If <dest> is not given, subvolume <name> will be created in the
> current directory.
>    Options
>    -i <qgroupid>
>       Add the newly created subvolume to a qgroup.  This option can be
> given multiple times.
>
> Would (I think):
> * btrfs subvolume create <dest-subvolume>
> * cp -ax --reflink=always <source-subvolume>/* <dest-subvolume>/

What's wrong with "btrfs subvolume snapshot"?

-- 
Fajar
