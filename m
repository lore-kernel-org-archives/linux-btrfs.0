Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserver1.prnet.org ([195.46.254.69]:59450 "EHLO
	extserver1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2KOF7S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 00:59:18 -0500
Message-ID: <50A484AB.5050600@prnet.org>
Date: Thu, 15 Nov 2012 06:59:07 +0100
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: Marios Titas <redneb8888@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive symlink bug
References: <50A41C71.1060504@prnet.org> <CAAdM644U3k=0N4RsxTont7rObi9zD2FqZZk6X4+M5AtupdtoFA@mail.gmail.com>
In-Reply-To: <CAAdM644U3k=0N4RsxTont7rObi9zD2FqZZk6X4+M5AtupdtoFA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks,

this patch fixes the problem

Bye,
David Arendt

On 11/15/12 05:21, Marios Titas wrote:
> On Wed, Nov 14, 2012 at 5:34 PM, David Arendt <admin@prnet.org> wrote:
>> Hi,
>>
>> I am using kernel 3.7.0-rc5 and latest btrfs-progs git.
>>
>> I am trying btrfs send/receive. When I have a filesystem containing a
>> symlink pointing to a nonexistent destination or a destination created
>> after the symlink was created, btrfs receive aborts with: ERROR: chown
>> link1.txt failed. No such file or directory.
>>
>> Steps to reproduce (/dev/loop0 and /dev/loop1 are test images):
>>
>> mkfs.btrfs /dev/loop0
>> mount /dev/loop0 /u00
>> btrfs subvolume create /u00/test
>> cd /u00/test
>> ln -s test1.txt link1.txt
>> btrfs subvolume snapshot -r /u00/test /u00/test.snapshot
>> mkfs.btrfs /dev/loop1
>> mount /dev/loop1 /u01
>> btrfs send /u00/test.snapshot | btrfs receive /u01
>> ERROR: chown link1.txt failed. No such file or directory
>
> A patch [1] for btrfs-progs that solves this issue was posted a month
> ago but has landed yet on the btrfs-progs git repository.
>
> [1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19539.html

