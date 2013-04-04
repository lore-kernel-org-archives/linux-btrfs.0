Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53830 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763256Ab3DDRAD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2013 13:00:03 -0400
Received: by mail-ob0-f179.google.com with SMTP id vb8so2767914obc.38
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2013 10:00:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DE18F344-65F0-4398-BD5D-B197C858D889@colorremedies.com>
References: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com>
	<CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
	<092651F7-2FAF-42A2-A5B5-F4E4377A6A12@colorremedies.com>
	<CAKcLGm8oNvQ7OO63TS389qDo3xo_41s1BO5POG8CR5=_nd2Z2g@mail.gmail.com>
	<DE18F344-65F0-4398-BD5D-B197C858D889@colorremedies.com>
Date: Thu, 4 Apr 2013 12:00:02 -0500
Message-ID: <CAKcLGm9EXpKp6w+6MrYQzLgNYEFjP6KTS7GBjZP_dXoH3on8sQ@mail.gmail.com>
Subject: Re: minimum kernel version for btrfsprogs.0.20?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: cwillu <cwillu@cwillu.com>,
        "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/3/13, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Mar 29, 2013, at 9:42 AM, Mitch Harder <mitch.harder@sabayonlinux.org>
> wrote:
>
>> On Fri, Mar 29, 2013 at 1:21 AM, Chris Murphy <lists@colorremedies.com>
>> wrote:
>>>
>>> mkfs.btrfs -l 8192 with kernel 3.9.0 creates a file system mountable by
>>> 3.9.0 and only 3.9.0 (so far). And while there's no error making such a
>>> file system with other kernels, they won't mount the resulting file
>>> system.
>>>
>>
>> I'm seeing something similar.
>>
>> Using the current master branch of btrfs-progs
>> (https://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
>> top commit 7854c8b667654502f69e05584729146a06827bc6 "Btrfs-progs: give
>> restore a list roots option"), if I run 'mkfs.btrfs -f /dev/<device>'
>> on a 3.7.x vintage kernel, the mkfs operation is successful, but I
>> can't mount the partition.
>>
>> I am successful on a 3.8.x vintage kernel or testing the _rc code for
>> 3.9.
>
> If you try a leaf size other than default, it creates the file system but
> won't mount it, for any 3.8.x kernel I've tried including 3.8.5. Only 3.9.0
> kernels are apparently mounting leaf sizes above 4KB, if the fs was created
> with btrfs-progs-0.20.rc1.20130308git704a08c.
>

I disagree with cwillu regarding the default setting for extended inode refs.

While the extended inode refs are a great addition and solve a long
standing problem, it appears only the 3.9.0_rc kernel consistently
works with extended inode refs.

There should be at least a few working kernel versions out there
before this becomes the default.  Options like this that will make
btrfs unmountable on older kernel versions need "buy-in" by the users.

There is still the capability to enable extended inode refs with btrfstune.
