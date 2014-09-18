Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:57767 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbaIRRMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 13:12:07 -0400
Received: by mail-qc0-f173.google.com with SMTP id i8so1734838qcq.32
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 10:12:05 -0700 (PDT)
Message-ID: <541B1263.3090804@gmail.com>
Date: Thu, 18 Sep 2014 13:12:03 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problem with unmountable filesystem.
References: <54184BD2.7000300@gmail.com> <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com> <54196F42.4030101@gmail.com> <22B49628-3659-4D83-BE99-A173CAFF23F9@colorremedies.com>
In-Reply-To: <22B49628-3659-4D83-BE99-A173CAFF23F9@colorremedies.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/17/2014 02:57 PM, Chris Murphy wrote:
> 
> On Sep 17, 2014, at 5:23 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
>>
>> Thanks for all the help.
> 
> Well, it's not much help. It seems possible to "corrupt" a primary superblock that points to a corrupt tree root, and use btrfs rescure super-recover to replace it, and then mount should work. One thing I didn't try was corrupting the primary superblock and just mounting normally or with recovery, to see if it'll automatically ignore the primary superblock and use the backup.
> 
> But I think you're onto something, that a good superblock can point to a corrupt tree root, and then not have a straight forward way to mount the good tree root. If I understand this correctly.
> 
Corrupting the primary superblock did in fact work, and I decided to try
mounting immediately, which failed.  I didn't try with -o recovery, but
I think that would probably fail as well.  Things worked perfectly
however after using btrfs rescue super-recover.  As far as avoiding
future problems, I think the best solution would be to have the mount
operation try the tree root pointed to by the backup superblock if the
one pointed to by the primary seems corrupted.

Secondarily, this almost makes me want to set the ssd option on all
BTRFS filesystems, just to get the rotating superblock updates, because
if it weren't for that behavior, I probably wouldn't have been able to
recovery anything in this particular case.
