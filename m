Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64981 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3C2PmQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 11:42:16 -0400
Received: by mail-oa0-f46.google.com with SMTP id k1so514615oag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 08:42:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <092651F7-2FAF-42A2-A5B5-F4E4377A6A12@colorremedies.com>
References: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com>
	<CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
	<092651F7-2FAF-42A2-A5B5-F4E4377A6A12@colorremedies.com>
Date: Fri, 29 Mar 2013 10:42:15 -0500
Message-ID: <CAKcLGm8oNvQ7OO63TS389qDo3xo_41s1BO5POG8CR5=_nd2Z2g@mail.gmail.com>
Subject: Re: minimum kernel version for btrfsprogs.0.20?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: cwillu <cwillu@cwillu.com>,
        "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 29, 2013 at 1:21 AM, Chris Murphy <lists@colorremedies.com> wrote:
> Chris Murphy wrote:
>> On Mar 29, 2013, at 12:04 AM, cwillu <cwillu@cwillu.com> wrote:
>>
>>> commit 1a72afaa "btrfs-progs: mkfs support for extended inode refs"
>>> unconditionally enables extended irefs (which permits more than 4k
>>> links to the same inode).  It's the right default imo, but there
>>> probably should have been a mkfs option to disable it.
>>
>> mkfs.btrfs -l 8192
>>
>> That is not mountable by 3.8.5. I get:
>>
>> [  252.870733] btrfs: disk space caching is enabled
>> [  252.870740] btrfs flagging fs with big metadata feature
>> [  252.874944] btrfs: failed to recover relocation
>> [  252.885186] btrfs: open_ctree failed
>>
>> That's definitely not expected.
>
> mkfs.btrfs -l 8192 with kernel 3.9.0 creates a file system mountable by 3.9.0 and only 3.9.0 (so far). And while there's no error making such a file system with other kernels, they won't mount the resulting file system.
>

I'm seeing something similar.

Using the current master branch of btrfs-progs
(https://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
top commit 7854c8b667654502f69e05584729146a06827bc6 "Btrfs-progs: give
restore a list roots option"), if I run 'mkfs.btrfs -f /dev/<device>'
on a 3.7.x vintage kernel, the mkfs operation is successful, but I
can't mount the partition.

I am successful on a 3.8.x vintage kernel or testing the _rc code for 3.9.
