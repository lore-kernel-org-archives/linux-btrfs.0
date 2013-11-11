Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52009 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab3KKTGV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Nov 2013 14:06:21 -0500
Message-ID: <52812AAA.1080106@friedels.name>
Date: Mon, 11 Nov 2013 20:06:18 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfsck errors is it save to fix?
References: <52742B59.3060405@friedels.name>	<CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>	<5274BEC8.5060804@friedels.name> <52780E20.8020405@friedels.name>	<CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com>	<5279E581.4000700@friedels.name> <527BE712.40304@friedels.name> <pan$2f107$ddc92f2a$30381770$58497a03@cox.net> <527DF34B.2030309@friedels.name>
In-Reply-To: <527DF34B.2030309@friedels.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I re-post this:

 >> To answer the "is it safe to fix" question...
>  >
>> In that context, yes, it's safe to btrfsck --repair, because you're
>> prepared to lose the entire filesystem if worse comes to worse in any
>> case, so even if btrfsck --repair makes things worse instead of better,
>> you've not lost anything you're particularly worried about anyway.
>
> I do have an daily backup of the important data.
> There is other data, that is (a bit more than) nice to keep
> (TV-Recordings). It seems all still readable, so I can also back this
> up, if I could free some space.
>
> So, I have run btrfsck --repair:
> -------
> root@homeserver:~/btrfs/btrfs-progs# git pull
> remote: Counting objects: 124, done.
> remote: Compressing objects: 100% (52/52), done.
> remote: Total 99 (delta 55), reused 89 (delta 47)
> Unpacking objects: 100% (99/99), done.
>  From git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs
>     d1570a0..c652e4e  integration -> origin/integration
> Already up-to-date.
> -------
>
>
> The repair:
> -------
> ./btrfsck --repair /dev/sdc1
> enabling repair mode
> Checking filesystem on /dev/sdc1
> UUID: 989306aa-d291-4752-8477-0baf94f8c42f
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> root 256 inode 9579 errors 100
> root 256 inode 9580 errors 100
> root 256 inode 14258 errors 100
> root 256 inode 14259 errors 100
> root 4444 inode 9579 errors 100
> root 4444 inode 9580 errors 100
> root 4444 inode 14258 errors 100
> root 4444 inode 14259 errors 100
> found 2895817096773 bytes used err is 1
> total csum bytes: 3206482672
> total tree bytes: 3901480960
> total fs tree bytes: 38912000
> total extent tree bytes: 135892992
> btree space waste bytes: 411727425
> file data blocks allocated: 3446512275456
>   referenced 3445793439744
> Btrfs v0.20-rc1-358-g194aa4
> -------
>
>
>
>
>
> After the repair, another check reveals the same errors as before:
> -------
> ./btrfsck  /dev/sdc1
> Checking filesystem on /dev/sdc1
> UUID: 989306aa-d291-4752-8477-0baf94f8c42f
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> root 256 inode 9579 errors 100
> root 256 inode 9580 errors 100
> root 256 inode 14258 errors 100
> root 256 inode 14259 errors 100
> root 4444 inode 9579 errors 100
> root 4444 inode 9580 errors 100
> root 4444 inode 14258 errors 100
> root 4444 inode 14259 errors 100
> found 2895817096773 bytes used err is 1
> total csum bytes: 3206482672
> total tree bytes: 3901480960
> total fs tree bytes: 38912000
> total extent tree bytes: 135892992
> btree space waste bytes: 411727425
> file data blocks allocated: 3446512275456
>   referenced 3445793439744
> Btrfs v0.20-rc1-358-g194aa4a
> -------
>
>
> The only messages in syslog/dmesg regarding btrfs are:
> [299517.270322] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f
> devid 2 transid 140436 /dev/sdc1
> [299525.805867] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f
> devid 1 transid 140436 /dev/sdb1
> [299525.807148] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f
> devid 2 transid 140436 /dev/sdc1
> [299525.808277] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f
> devid 1 transid 140436 /dev/sdb1
> (repeating several times)
>
>
> Can we find out, why btrfsck does not fix the errors?

I got no reply to this.
Now, I have two Intentions:
-Help improving btrfs(ck)
-Make the System usable again

Please let me know, if it is of interest to work with this example on 
btrfsck, which apparently now is not able to fix this problem and what 
Information you would need from me.

Otherwise, I can proceed to the second point.

Greetings,
Hendrik

---
Diese E-Mail ist frei von Viren und Malware, denn der avast! Antivirus Schutz ist aktiv.
http://www.avast.com

