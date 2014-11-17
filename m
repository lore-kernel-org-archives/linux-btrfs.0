Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42873 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaKQU4Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 15:56:16 -0500
Received: by mail-qc0-f182.google.com with SMTP id r5so5209187qcx.27
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 12:56:16 -0800 (PST)
Message-ID: <546A60D0.8000800@ubuntu.com>
Date: Mon, 17 Nov 2014 15:55:44 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Bob Marley <bobmarley@shiftmail.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org> <5438DC47.7000901@inwind.it>
In-Reply-To: <5438DC47.7000901@inwind.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/11/2014 3:29 AM, Goffredo Baroncelli wrote:
> On 10/10/2014 12:53 PM, Bob Marley wrote:
>>> 
>>> If true, maybe the closest indication we'd get of btrfs
>>> stablity is the default enabling of autorecovery.
>> 
>> No way! I wouldn't want a default like that.
>> 
>> If you think at distributed transactions: suppose a sync was
>> issued on both sides of a distributed transaction, then power was
>> lost on one side, than btrfs had corruption. When I remount it,
>> definitely the worst thing that can happen is that it
>> auto-rolls-back to a previous known-good state.
> 
> I cannot agree. I consider a sane default to have a consistent
> state with "the recently data written lost", instead of "require
> the user intervention to not lost anything".
> 
> To address your requirement, we need a "super sync" command which 
> ensure that the data are in the filesystem and not only in the log
> (as sync should ensure).

I have to agree.  There is a reason we have fsck -p and why that is what
is run at boot time.  Some repairs involve a tradeoff that will result
in permanent data loss that maybe could be avoided by going the other
way, or performing manual recovery.  Such repairs should never be done
automatically by default.

For that matter I'm not even sure this sort of thing should be there as
a mount option at all.  It really should require a manual fsck run with
a big warning that *THIS WILL THROW OUT SOME DATA*.

Now if the data is saved to a snapshot or something so you can manually
try to recover it later rather than being thrown out wholesale, I can
see that being done automatically at boot time.  Of course, if btrfs is
that damaged then wouldn't grub be unable to load your kernel in the
first place?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUamDQAAoJEI5FoCIzSKrwaYAIAKXgkGBbBZj6yUuLC1+euim6
6Xqer1DiGywEiO4UPaxmq3rHDOlZlyIamDpUi7nIvbfK+TgBWfEVtLvdd6shjfqA
FvFv7t+X2mlAyk+iGffSK1w9/qgEhE55M35exba95Cdsn0ezos4LpvTsL1128nkx
uGzYQcoYj1irkmDp133JuHYAxhrAp0Q6PB+5gIgWfRsVbGezcxg5FvqzotEq1J/d
7MT1FvdoUo5qt2j/KzTUfD5AlFhsXE5beykakMdFmoHlTCQAxEeUU21z6APclkxF
/b/ppLt603Vpb6rpKvNUyBy1TuPr6FJEx5O2qWUWlhRxkOUB98M86KHyWVBHtMM=
=uG+h
-----END PGP SIGNATURE-----
