Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:54693
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994Ab3C2GVx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 02:21:53 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: minimum kernel version for btrfsprogs.0.20?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
Date: Fri, 29 Mar 2013 00:21:50 -0600
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <092651F7-2FAF-42A2-A5B5-F4E4377A6A12@colorremedies.com>
References: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com> <CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
To: cwillu <cwillu@cwillu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy wrote:
> On Mar 29, 2013, at 12:04 AM, cwillu <cwillu@cwillu.com> wrote:
> 
>> commit 1a72afaa "btrfs-progs: mkfs support for extended inode refs"
>> unconditionally enables extended irefs (which permits more than 4k
>> links to the same inode).  It's the right default imo, but there
>> probably should have been a mkfs option to disable it.
> 
> mkfs.btrfs -l 8192
> 
> That is not mountable by 3.8.5. I get:
> 
> [  252.870733] btrfs: disk space caching is enabled
> [  252.870740] btrfs flagging fs with big metadata feature
> [  252.874944] btrfs: failed to recover relocation
> [  252.885186] btrfs: open_ctree failed
> 
> That's definitely not expected.

mkfs.btrfs -l 8192 with kernel 3.9.0 creates a file system mountable by 3.9.0 and only 3.9.0 (so far). And while there's no error making such a file system with other kernels, they won't mount the resulting file system.


Chris Murphy