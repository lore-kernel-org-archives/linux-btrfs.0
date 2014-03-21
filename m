Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:31195 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbaCUKRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 06:17:07 -0400
Date: Fri, 21 Mar 2014 11:17:01 +0100
From: Xavier Bassery <xavier@bartica.org>
To: Adam Khan <adam.s.khan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Please advise on repair action
Message-ID: <20140321111701.2502a307@renoir.lan>
In-Reply-To: <532931D9.60809@gmail.com>
References: <532931D9.60809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2014-03-19 06:57, Adam Khan a écrit :
> Hello,
> 
> I have a simple btrfs located on a dm-crypt volume. I'm getting a
> general protection fault when I
> attempt to access a specific directory in Thunar file manager and in a
> Python program.
> 
> The trace is attached for Thunar.

[  313.491347] general protection fault: 0000 [#1] SMP 
...
[  313.492376] RIP: 0010:[<ffffffff8127c66d>]  [<ffffffff8127c66d>] memcpy+0xd/0x110 ...
[  313.492804] Call Trace:
[  313.492836]  [<ffffffffa013f168>] ? read_extent_buffer+0xc8/0x120 [btrfs]
[  313.492877]  [<ffffffffa0125064>] ? <btrfs_get_extent+0x8f4/0x950 [btrfs]
...
[  313.493293]  [<ffffffff811223ba>] ? ondemand_readahead+0x14a/0x280

> 
> btrfsck returns this:
> 
> Checking filesystem on /dev/mapper/xyz_crypt
> UUID: ...

Here you've omitted the interesting part (preceding the next line).
Weren't there lines looking like 
"root 256 inode XXXX errors 400, nbytes wrong" ?

> found 88316880601 bytes used err is 1
> total csum bytes: 180423792
> total tree bytes: 291459072
> total fs tree bytes: 50192384
> total extent tree bytes: 12898304
> btree space waste bytes: 55087032
> file data blocks allocated: 352826490880
>  referenced 184697802752
> Btrfs v3.12
> 
> How should I proceed to repair this fs?
> 

this seems to be the same issue as the one described in BZ 68411
(https://bugzilla.kernel.org/show_bug.cgi?id=68411).
If I'm correct, the run-time fix is "Btrfs: don't use ram_bytes for
uncompressed inline items" as said in the bz.
At the moment this fix is only in 3.14-xx but is expected to come to
stable too.
Also btrfs check is not yet able to repair this. You'll find a
work-around given in the bug report that involves truncating and
unlinking the problematic files.

Best regards,
Xavier

