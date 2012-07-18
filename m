Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35943 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2GRAEL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:11 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so1031435yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2012 17:04:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL113-W59C91967E5266AC3020075B0DB0@phx.gbl>
References: <CAHzCyiQ57DU2O+jog2oc65sfQStL3WCdsxZcZbCFHG1Ygi8dBg@mail.gmail.com>
	<COL113-W59C91967E5266AC3020075B0DB0@phx.gbl>
Date: Tue, 17 Jul 2012 20:04:10 -0400
Message-ID: <CAHzCyiSGxthutXYnUXn7KWboYt3ruN49HpaYA+DcSEu-N3KDaA@mail.gmail.com>
Subject: Re: Unmountable btrfs filesystem
From: "Providence M. SALUMU" <providence.salumu@gmail.com>
To: Kyle Gates <kylegates@hotmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kyle,

I've just tried both of the options you've suggested, they all fail :-(
btrfsch --repair /dev/sdb6 breaks with:

btrfsck: btrfsck.c:1933: check_owner_ref: Assertion `!(rec->is_root)'

I don't have more success with mount -t btrfs -o recovery command
unfortunately. Here is the output I get:

[  663.005399] parent transid verify failed on 528974954496 wanted
22723 found 22727
[  663.005928] btrfs read error corrected: ino 1 off 528974954496 (dev
/dev/sdb6 sector 585363104)
[  663.005933] btrfs: failed to read tree root on sdb6
[  663.013985] btrfs: open_ctree failed

Any other clues guys?

2012/7/17 Kyle Gates <kylegates@hotmail.com>:
> Have you tried mounting with the recovery option?
> mount -t btrfs -o recovery /dev/sdb6
>
> Did you use the btrfsck repair option?
> btrfsck --repair /dev/sdb6
>
>
>> Date: Tue, 17 Jul 2012 07:13:17 -0400
>> Subject: Unmountable btrfs filesystem
>> From: providence.salumu@gmail.com
>> To: linux-btrfs@vger.kernel.org
>
>>
>> Hi devs,
>>
>> I can't mount my btrfs-based external disk. I don't know what happened
>> to the disk, but usually it gets disconnected (usb cable pulled out)
>> buy my 8 months old daughter.
>>
>> Here's the output from dmesg:
>>
>> [ 299.699543] parent transid verify failed on 528952573952 wanted
>> 22726 found 22728
>> [ 299.700947] btrfs read error corrected: ino 1 off 528952573952 (dev
>> /dev/sdb6 sector 585319392)
>> [ 299.701224] btrfs: open_ctree failed
>>
>> I then run "btrfsck /dev/sdb6" with not much more success at all. The
>> output is as follows:
>>
>> Ignoring transid failure
>> leaf parent key incorrect 528969142272
>> parent transid verify failed on 528969142272 wanted 22728 found 22726
>> Ignoring transid failure
>> leaf parent key incorrect 528969142272
>> btrfsck: btrfsck.c:1933: check_owner_ref: Assertion `!(rec->is_root)'
>> failed.
>> Aborted
>>
>> My btrfs-progs comes from
>> repository:
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>> at the commit: 8935d8436147f86dfbda3d8b8175a77b654b8abc
>> branch: master
>> and I'm running linux-3.5_rc7 kernel. (Linux-3.5_rc6 has got the same
>> mount issue as well)
>>
>> I tried the btrfs-find-root hint (from
>> https://btrfs.wiki.kernel.org/index.php/Restore), but since I don't
>> have the lines starting with "Well block n seems great...", I'm
>> doubtful about which block id to run btrfs-restore -t n with.
>>
>> Can you help in guys?
>>
>> Many thanks in advance,
>>
>> - Providence.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
