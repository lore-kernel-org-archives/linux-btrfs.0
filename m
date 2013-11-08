Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44568 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab3KHUFu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 15:05:50 -0500
Received: by mail-ie0-f178.google.com with SMTP id to1so2340912ieb.9
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 12:05:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131108194637.GT14405@carfax.org.uk>
References: <527d3d814dcdb2.95923869@wp.pl>
	<20131108194637.GT14405@carfax.org.uk>
Date: Fri, 8 Nov 2013 14:05:49 -0600
Message-ID: <CAE5mzviCxodug0S=AUprTJ5TQzYuH+49y7TVX8c55CmW=ByZxw@mail.gmail.com>
Subject: Re: Odp: Re: Odp: Btrfs might be gradually slowing the boot process
From: cwillu <cwillu@cwillu.com>
To: Hugo Mills <hugo@carfax.org.uk>, yzb3@wp.pl,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 8, 2013 at 1:46 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Nov 08, 2013 at 08:37:37PM +0100, yzb3@wp.pl wrote:
>> Sure;
>>
>> the kernel line from grub.cfg:
>> linux   /boot/vmlinuz-linux root=UUID=c26e6d9a-0bbb-436a-a217-95c738b5b9c6 rootflags=noatime,space_cache rw quiet
>
>    OK, this may be your problem. You're generating the space cache
> every time you boot. You only need it once; let the disk activity on
> boot finish (it may take a while, depending on how big your filesystem
> is, and how much data it has, and how fragmented it is), and remove
> the space_cache option from your rootflags. When you next boot, it
> will use the existing cache rather than generating it again from
> scratch.

While it's true you only need to mount with it once, mounting with
space_cache will only generate it if it doesn't already exist.  The
existence of a valid space cache generation in the super actually
enables exactly the same flag that space_cache/no_space_cache toggles,
in the very same function as the mount option is checked (this is
basically how the "you only need to mount with it once" magic is
implemented).

super.c:
int btrfs_parse_options(struct btrfs_root *root, char *options)
{
    ...
    cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
    if (cache_gen)
        btrfs_set_opt(info->mount_opt, SPACE_CACHE);
    ...
    case Opt_space_cache:
        btrfs_set_opt(info->mount_opt, SPACE_CACHE);
        break;
    ...
}
