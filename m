Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:49827 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab3C2GK3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 02:10:29 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: minimum kernel version for btrfsprogs.0.20?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
Date: Fri, 29 Mar 2013 00:10:24 -0600
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <206C37E4-43B6-4276-8D0E-B35F1362CB45@colorremedies.com>
References: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com> <CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
To: cwillu <cwillu@cwillu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 29, 2013, at 12:04 AM, cwillu <cwillu@cwillu.com> wrote:

> On Thu, Mar 28, 2013 at 11:41 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> Creating a btrfs file system using btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19, and either kernel 3.6.10-4.fc18 or 3.9.0-0.rc3.git0.3.fc19, makes a file system that cannot be mounted by kernel 3.6.10-4.fc18. It can be mounted by kernel 3.8.4. I haven't tested any other 3.8, or any 3.7 kernels.
>> 
>> Is this expected?
>> 
>> dmesg reports:
>> [  300.014764] btrfs: disk space caching is enabled
>> [  300.024137] BTRFS: couldn't mount because of unsupported optional features (40).
>> [  300.034148] btrfs: open_ctree failed
> 
> commit 1a72afaa "btrfs-progs: mkfs support for extended inode refs"
> unconditionally enables extended irefs (which permits more than 4k
> links to the same inode).  It's the right default imo, but there
> probably should have been a mkfs option to disable it.

I just tried this with kernel 3.7.9 and it mounts, as does 3.8.5. However, with 3.8.5, if I create a file system:

mkfs.btrfs -l 8192

That is not mountable by 3.8.5. I get:

[  252.870733] btrfs: disk space caching is enabled
[  252.870740] btrfs flagging fs with big metadata feature
[  252.874944] btrfs: failed to recover relocation
[  252.885186] btrfs: open_ctree failed

That's definitely not expected.


Chris Murphy