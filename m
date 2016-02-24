Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.70.57.6] ([195.70.57.6]:35930 "EHLO icts.hu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbcBXJHT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 04:07:19 -0500
Received: from [10.168.1.103] (adsl-189-187.globonet.hu [82.144.189.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by icts.hu (Postfix) with ESMTPSA id D120A20ECA9
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 09:58:08 +0100 (CET)
From: =?UTF-8?B?U3phbG1hIEzDoXN6bMOz?= <dblaci@dblaci.hu>
Subject: Re: Input/Output errors
To: linux-btrfs@vger.kernel.org
References: <20160224004045.GA20632@gmail.com>
 <20160224015658.GY22487@merlins.org> <20160224030236.GA30797@gmail.com>
 <CAJCQCtQLY-zcz1e8zqNrekEfo1yo9DcDfwR_m4Y8AGaKxV32qg@mail.gmail.com>
Message-ID: <56CD70A0.30201@dblaci.hu>
Date: Wed, 24 Feb 2016 09:58:08 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQLY-zcz1e8zqNrekEfo1yo9DcDfwR_m4Y8AGaKxV32qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-02-24 05:37 keltezéssel, Chris Murphy írta:
> On Tue, Feb 23, 2016 at 8:02 PM, Kenny MacDermid
> <kenny.macdermid@gmail.com> wrote:
>
>> rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,inode_cache
> It sounds like an ssd trim bug. I'd check the firmware for updates. If
> it's up to date, I'd drop discard mount option first and try to
> reproduce. Or just use the default mount options and try to reproduce,
> then add them back one at a time until you discover the culprit.
>
> Also, how many files/directories are there? inode_cache isn't
> recommended for most use cases. And space_cache is the default so it
> doesn't need to be listed.
>
>
>

As i wrote to the list a few weeks ago, this problem seems to be the 
same I have.

The difference:

- i use mount options: noatime,compress,nossd
- I don't use dm-crypt, but these machines are Xen pvms (there is a 
virtualization layer between btrfs and lvm)

The same:

- io error without any error or message in the dmesg.
- umount / mount always fixes the problem (for some time)

More info:

- these files are usually smalls (mysql myisam files, 10-20-50 kbyte 
size, without heave fragmentation)
- defrag don't help
- scrub always works (no errors) but not fix the errors
- no hw or hw read error on the block device (in any layer)
- get this problem with 4.4.1 kernel too (seems to be somewhat less 
frequent than before, but the problem happened with 3.18 and on)
- echo 3 > /proc/sys/vm/drop_caches    sometimes fixes the problem, but 
not every time
- the problem is happening rarely, sometimes there are days without error
- the problem is not for specific hardware or virtual machine

I can try any debug option or patch if needed.

László Szalma
