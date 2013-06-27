Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:39336 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3F0OX5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 10:23:57 -0400
Received: by mail-ea0-f175.google.com with SMTP id z7so441126eaf.34
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 07:23:55 -0700 (PDT)
Message-ID: <51CC4AF1.2090209@gmail.com>
Date: Thu, 27 Jun 2013 16:23:45 +0200
From: =?ISO-8859-1?Q?St=E9phane_Mutz?= <stephane.mutz@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Problem with btrfsck / couurpted filesystem
References: <51CC4419.6030108@gmail.com> <20130627135842.GQ4288@localhost.localdomain>
In-Reply-To: <20130627135842.GQ4288@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've built the GIT tools and run btrfsck (without options) following the
wiki page.
I got the following log:
Checking filesystem on /dev/VG_NL-SAS/LV_snap
UUID: de300fd0-1251-4767-9d80-84ce7ebfba9a
checking extents
checking free space cache
free space inode generation (0) did not match free space cache
generation (16583)
free space inode generation (0) did not match free space cache
generation (16579)
checking fs roots
checking csums
checking root refs
found 120489896006 bytes used err is 0
total csum bytes: 380818020
total tree bytes: 10396295168
total fs tree bytes: 9423839232
total extent tree bytes: 473616384
btree space waste bytes: 1923163802
file data blocks allocated: 455172272128
 referenced 564086325248
Btrfs v0.20-rc1-335-gf00dd83

It does not report any extends error.
Can I consider all is fine now?

Regards, Stéphane.

Le 27/06/2013 15:58, Josef Bacik a écrit :
> On Thu, Jun 27, 2013 at 03:54:33PM +0200, Stéphane Mutz wrote:
>> Hello,
>>
>> I'm trying to fix a btrfs file system. BTRFSCK reports errors in the
>> extend tree.
>> I've tryong to use --repair option but it ended up with an assertion
>> failure.
>>
>> I'm also trying to understand how the filesystem can have become corrupted.
>> I'm running Ubuntu 12.10.
>>
>> Any suggestion on ways to fix the problem would be really appreciated.
>>
> Are you using the btrfs-progs from git?  If not pull that down and build it and
> run the btrfsck in there, and then capture the output if it fails.  Thanks,
>
> Josef

