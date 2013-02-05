Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63507 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3BEGSq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 01:18:46 -0500
Received: by mail-lb0-f178.google.com with SMTP id n1so7374965lba.9
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Feb 2013 22:18:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359586227-19762-3-git-send-email-mfasheh@suse.de>
References: <1359586227-19762-1-git-send-email-mfasheh@suse.de>
	<1359586227-19762-3-git-send-email-mfasheh@suse.de>
Date: Mon, 4 Feb 2013 22:18:44 -0800
Message-ID: <CADU+-uA-yMo2+wjP3quUFxX0Z_O=i38H=JBrgu=5zFn3jxKksw@mail.gmail.com>
Subject: Re: [PATCH 2/5] btrfs-progs: libify some parts of btrfs-progs
From: Filipe Brandenburger <filbranden@google.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, Anand.Jain@oracle.com,
        aschnell@suse.de, jeffm@suse.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

A week ago I posted a patch to move fs/btrfs/ioctl.h to
include/uapi/linux/btrfs.h in the kernel tree:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/22763/focus=22764

My main motivation was to export the kernel headers with the ioctl
constants/structs so that other programs may use the ioctls, in my
case I was interested in implementing strace support for parsing btrfs
ioctls (I'm still working on that project.)

I see you took a different approach, using the header files present in
btrfs-progs and installing those in /usr/include/btrfs (not a linux/
subdirectory.) As your main objective is to export part of btrfs-progs
functionality as a library, that makes sense too...

I'm not saying that either way is better, just that it probably needs
some coordination. I think in the end we'll need a little bit of both
approaches, the kernel exporting one of the header files (for ioctls)
and the userland exporting some others (for a libbtrfs external
interface.)

Here are some relevant project ideas mentioned in the Wiki:

1) Provide a library covering 'btrfs' functionality
(https://btrfs.wiki.kernel.org/index.php/Project_ideas#Provide_a_library_covering_.27btrfs.27_functionality)
-- your patchset implements part of this.

2) Remove ioctl.h in btrfs and btrfs-progs world, create
include/linux/btrfs.h with those definitions
(https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas#Remove_ioctl.h_in_btrfs_and_btrfs-progs_world.2C_create_include.2Flinux.2Fbtrfs.h_with_those_definitions)
-- my patchset implements part of this, the part of the kernel but not
the part of btrfs-progs

3) Use the kernel code in user mode
(https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas#Use_the_kernel_code_in_user_mode)
-- none of them implements this, I've been thinking about this one and
I don't have a good solution yet... I'll send a separate e-mail about
this one to the list later.

Cheers,
Filipe


On Wed, Jan 30, 2013 at 2:50 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> External software wanting to use the functionality provided by the btrfs
> send ioctl has a hard time doing so without replicating tons of work. Of
> particular interest are functions like btrfs_read_and_process_send_stream()
> and subvol_uuid_search(). As that functionality requires a bit more than
> just send-stream.c and send-utils.c we have to pull in some other parts of
> the progs package.
>
> This patch adds code to the Makefile and headers to create a library,
> libbtrfs which the btrfs command now links to.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  Makefile       |   83 ++++++++++++++++++++++++++++++++++++--------------------
>  btrfs-list.h   |    4 +++
>  crc32c.h       |    4 +++
>  ctree.h        |    9 ++++++
>  extent-cache.h |    6 ++++
>  extent_io.h    |    7 +++++
>  radix-tree.h   |    4 +++
>  rbtree.h       |    4 +++
>  send-utils.h   |    5 ++++
>  9 files changed, 96 insertions(+), 30 deletions(-)
