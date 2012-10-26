Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35402 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2JZLl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 07:41:59 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so805781eaa.19
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 04:41:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121026105954.GV2052@vicerveza.homeunix.net>
References: <20121026105721.GU2052@vicerveza.homeunix.net>
	<20121026105954.GV2052@vicerveza.homeunix.net>
Date: Fri, 26 Oct 2012 13:41:58 +0200
Message-ID: <CAJHuE_CDmQhKt0i18WsFxVj_-hPNiAL6_fhkdt1b+eQnCUoDhw@mail.gmail.com>
Subject: Re: Can't replace a faulty disk of raid1
From: Goffredo Baroncelli <kreijack@gmail.com>
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Luis

On Fri, Oct 26, 2012 at 12:59 PM, Lluís Batlle i Rossell
<viric@viric.name> wrote:
[...]
>>
>> I tried to remove the missing device, and it said "Input/output error" after a
>> while. Next attempts simply gave "Invalid argument".

Todate BTRFS is not capable to remove (via btrfs device delete <path>)
a missing disk. The user has to unmount the filesystem and remount-it
in "degraded" mode.
I.e.:

# umount /mnt/btrfs
# mount -o degraded /dev/sdX /mnt/btrfs


Now I am noticing that the filesystem is the root filesystem. This is
a bit more difficult to handle. I think that you have to pass the
right parameter to the boot loader to do that.

For example on debian, you must pass the following option to grub
(typically to the line of the kernel)

rootflags=degraded

I don't know i is valid to do something like:

# mount -o remount,degraded /

BR
G.Baroncelli
