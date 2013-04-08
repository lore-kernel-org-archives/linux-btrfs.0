Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935332Ab3DHMBM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Apr 2013 08:01:12 -0400
Date: Mon, 8 Apr 2013 14:01:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: lvm volume like support
Message-ID: <20130408120109.GA18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
 <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
 <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
 <201302261130.31494.Martin@lichtvoll.de>
 <CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com>
 <20130227100558.37d86d82@natsu>
 <kgkhcp$dfg$1@ger.gmane.org>
 <kgklb0$g6a$1@ger.gmane.org>
 <kgkm75$p2g$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <kgkm75$p2g$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


On Wed, Feb 27, 2013 at 02:12:56AM -0800, Alex Elsayed wrote:
> Alex Elsayed wrote:
> 
> ...and a second version, because I forgot to actually remove the calls to
> tcm_node in favor of poking configfs like I said.

I'd like to use your script to setup scsi devices for testing, however
I've encountered 2 things did not work with the scsi emulation.

Setup:

There's a 10G file image created by dd and exported via your script as
/dev/sdl.

$ df -h
/dev/sdl                      10G  312K  8.0G   1% /mnt/sdl

mkfs is ok, mount is ok.

Testing:

$ cat /dev/zero > file
^C

problem 1: size of 'file' was 77 GB
problem 2: umount was fine, remounted again and now size of 'file' is 0

Both of them look quite serious to me :)

david
