From: "Nikos Voutsinas" <nvoutsin@noc.edunet.gr>
Subject: Re: subvolume info in /proc/mounts
Date: Sat, 11 Feb 2012 00:42:40 +0200
Message-ID: <83851669497fbe3dcf8fdb1b3211b7c6.squirrel@webmail01.edunet.gr>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: "Karel Zak" <kzak@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> On Sat, Feb 04, 2012 at 08:40:51PM +0200, Nikos Voutsinas wrote:
>> There was a patch to include the subvolume mount option into
>> /proc/mounts.
>> Did that make it into the kernel;
>> If not, what is the formal way to find out which subvolume is mounted;
>  see /proc/self/mountinfo there is 'fs root' column, for bind mounts and
btrfs subvolumes is there '/<path>' (and '/' for normal mounts).
findmnt(8) uses the path in SOURCE column, for example
> /dev/sda1[/subvolume].

Thank you Karel, at least the list now has an answer on how to find the
mounted subvolume. For a moment I thought that no one had noticed this
part of the question.

In any production scenario, the first time you try to explore btrfs
subvolume capabilities it becomes obvious that this feature is missing and
it is weird how this has overlooked for such a long time.

Nikos



