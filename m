Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44920 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2F0LIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 07:08:01 -0400
Received: by dady13 with SMTP id y13so1249062dad.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 04:08:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEA6F23.3020600@cn.fujitsu.com>
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
	<4FEA6F23.3020600@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 13:08:01 +0200
Message-ID: <CAB9VWqAX60viLktJnGYkzAN_ZJAgV7OuW-U6ZYaKP6_aWRCnLA@mail.gmail.com>
Subject: Re: [PATCH 0/5] introduce btrfs filesystem property command
From: Alexander Block <ablock84@googlemail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 4:25 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 06/25/2012 05:20 AM, Alexander Block wrote:
>
>> This patchset introduces the btrfs filesystem property command. It is the
>> result of a discussion we had on IRC. I tried to make the properties
>> interface as generic and extensible as possible. Comments are welcome.
>>
>> Currently the command looks like this:
>> btrfs fi prop /path/to/object [name[=value]]
>>
>> Some people may prefer other forms. For example I got suggestions for
>> these forms:
>> btrfs set/get /path/to/object [name [value]]
>> btrfs prop /pach/to/object [name[=value]] (and also without the =)
>>
>> I'm open to more suggestions and a discussion on this. I'm definitely
>> for removing the fi[lesystem] prefix but I'm neutral to the other
>> suggestions made so far.
>>
>> For now, I've implemented three properties:
>> 1. read-only. Usable on subvolumes to toggle the read-only flags.
>> 2. label. I looked through btrfs to find good examples of things that
>>    could be moved to the new properties interface and the filesystem
>>    label looked like a good one. There are for sure more, but that is
>>    something for later (and maybe for someone else). I would suggest
>>    to move everthing that makes sense over to the props interface and
>>    mark the old interfaces as deprecated. Comments on this are welcome.
>>
>
>
> Hi Alex,
>
> Thanks for doing these!
>
> I'm doing something similar to yours, but I prefer keeping these prefixes and making some
> efforts to enhance original APIs:
I had some discussions with David and Ilya and we agreen on dropping
the filesystem prefix for a
filesystem prefix for a simple reason. The property command is not
only for filesystems, so the
prefix does not make sense here. We can later set/get properties on
inodes, subvolumes,
filesystems, devices and maybe more later.

At the moment, the command has this form (new patchset will follow):
btrfs property set [<type>:]<object> <name> <value>
btrfs property get [<type>:]<object> [<name>] (no name means dump all)
btrfs property list [<type>:]<object> (lists all available properties
for the given object/type with a description)

The type is a prefix to explicitly specify what type of object you
mean. This is necessary in case
the object+property combination is ambiguous.  For example
'/path/to/fs/root' could mean the root subvolume,
the directory inode or the filesystem itself. Normally, btrfs-progs
will try to detect the type automatically.

>
> For subvolume, right now we can have two attributes: readonly and default, and let 'btrfs sub list'
> work just like 'ls' so that we can get their attributes easier:
>
> o       btrfs subvolume list [-p] path
>        subvol (Default)
>        snap (Readonly)
>
> o       btrfs subvolume list [-p] path/subvol
>        subvol (Default)
>
> o       btrfs subvolume list [-p] path/snap
>        snap (Readonly)
>
>
> how about this?
This sounds like something that we should handle/discuss separately to
the new property command group.
>
> thanks,
> liubo
>
>> Alex.
>>
>> Alexander Block (5):
>>   Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
>>   Btrfs-progs: move skip_prefix and prefixcmp to utils.c
>>   Btrfs-progs: let get_label return the label instead of of printing it
>>   Btrfs-progs: make filesystem_cmd_group non const
>>   Btrfs-progs: introduce btrfs filesystem property command
>>
>>  Makefile          |    3 +-
>>  btrfs.c           |   19 +--
>>  btrfslabel.c      |   13 +-
>>  btrfslabel.h      |    4 +-
>>  cmds-filesystem.c |  115 +++++++++++++-
>>  commands.h        |    9 +-
>>  help.c            |    2 +
>>  ioctl.h           |    2 +
>>  props.c           |  460 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  props.h           |   45 ++++++
>>  utils.c           |   15 ++
>>  utils.h           |    3 +
>>  12 files changed, 659 insertions(+), 31 deletions(-)
>>  create mode 100644 props.c
>>  create mode 100644 props.h
>>
>
>
