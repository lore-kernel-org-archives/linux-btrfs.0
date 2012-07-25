Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47319 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab2GYKl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 06:41:57 -0400
Received: by yhmm54 with SMTP id m54so516554yhm.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 03:41:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500D43A7.1010801@gmx.net>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
	<500D43A7.1010801@gmx.net>
Date: Wed, 25 Jul 2012 12:41:56 +0200
Message-ID: <CAB9VWqAGTOttaz722LnMiufPNUZaLQU7epAdGFejK9gssuHnRg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Experimental btrfs send/receive (btrfs-progs)
From: Alexander Block <ablock84@googlemail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2012 at 2:29 PM, Arne Jansen <sensille@gmx.net> wrote:
> On 04.07.2012 15:39, Alexander Block wrote:
>> Hello all,
>>
>> This is the user space side of btrfs send/receive.
>>
>> You can apply them manually or use my git repo:
>>
>> git://github.com/ablock84/btrfs-progs.git (branch send)
>>
>> The branch is based on Hugo's integration-20120605 branch. I had to add a temporary
>> commit to fix a bug introduced in one of the strncpy/overflow patches that got into
>> btrfs-progs. This fix is not part of the btrfs send/receive patchset, but you'll
>> probably need it if you want to base on the integration branch. I hope this is not
>> required in the future when a new integration branch comes out.
>>
>> Example usage:
>>
>> Multiple snapshots at once:
>> btrfs send /mnt/snap[123] > snap123.btrfs
>
> a) Do we really want a single token command here, not
> btrfs filesystem send or subvol send?
In my opinion the single token is easier to type and remember. But if
enough speaks for normal subcommands this can be changed (but by
someone else as I'm running out of time).
> b) zfs makes sure stdout is not a tty, to prevent flooding
> your console. This kinda makes sense.
This makes sense. But again, this has to be done by someone else.
>
>>
>> Single snapshot with manual parent:
>> btrfs send -p /mnt/snap3 /mnt/snap4 > snap4.btrfs
>>
>> Receive both streams:
>> btrfs receive /mnt2 < snap123.btrfs
>> btrfs receive /mnt2 < snap4.btrfs
>>
>> (Please give suggestions for a file extension)
>>
>> Please read the kernel side email as well, especially the warnings!
>>
>> Alex.
>>
>> Alexander Block (6):
>>   Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
>>   Btrfs-progs: update ioctl.h to support clone range ioctl
>>   Btrfs-progs: print inode transid and dir item data field in
>>     debug-tree
>>   Btrfs-progs: update btrfs-progs for subvol uuid+times support
>>   Btrfs-progs: update ioctl.h to support btrfs send ioctl
>>   Btrfs-progs: add btrfs send/receive commands
>>
>>  Makefile       |    7 +-
>>  btrfs.c        |    2 +
>>  cmds-receive.c |  910 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  cmds-send.c    |  677 +++++++++++++++++++++++++++++++++++++++++
>>  commands.h     |    4 +
>>  ctree.h        |   40 ++-
>>  ioctl.h        |   35 ++-
>>  print-tree.c   |   88 ++++--
>>  send-stream.c  |  480 ++++++++++++++++++++++++++++++
>>  send-stream.h  |   58 ++++
>>  send-utils.c   |  337 +++++++++++++++++++++
>>  send-utils.h   |   69 +++++
>>  send.h         |  132 ++++++++
>>  13 files changed, 2815 insertions(+), 24 deletions(-)
>>  create mode 100644 cmds-receive.c
>>  create mode 100644 cmds-send.c
>>  create mode 100644 send-stream.c
>>  create mode 100644 send-stream.h
>>  create mode 100644 send-utils.c
>>  create mode 100644 send-utils.h
>>  create mode 100644 send.h
>>
>
