Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:41952 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2LLUWI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 15:22:08 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so388638dak.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 12:22:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355342784.940.140661165251717.298B576B@webmail.messagingengine.com>
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
	<1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
	<CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
	<1355337523.8384.140661165218221.778EBD55@webmail.messagingengine.com>
	<CAE5mzvjrGZVU7p9dTWiJ1pNZUe_Xj5m78FJte4Enb1od=iqVTA@mail.gmail.com>
	<1355342784.940.140661165251717.298B576B@webmail.messagingengine.com>
Date: Wed, 12 Dec 2012 14:22:07 -0600
Message-ID: <CAE5mzviPrx5s9c2rP=qd36pBbNX5MdzwKmsf3khkvRk3jtaCyg@mail.gmail.com>
Subject: Re: Encryption
From: cwillu <cwillu@cwillu.com>
To: merc1984@f-m.fm
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 12, 2012 at 2:06 PM,  <merc1984@f-m.fm> wrote:
> On Wed, Dec 12, 2012, at 10:48, cwillu wrote:
>> Sayeth the FAQ:
>
> Oh pardon me, it's BTRFS RAID that's a no-go, which is just as critical
> to me as I have a 4 disk 8TB array.
> The FAQ goeth on to Say:
> -----------------------------------------------------------
> This pretty much forbids you to use btrfs' cool RAID features if you
> need encryption. Using a RAID implementation on top of several encrypted
> disks is much slower than using encryption on top of a RAID device. So
> the RAID implementation must be on a lower layer than the encryption,
> which is not possible using btrfs' RAID support.
>  -----------------------------------------------------------
>
> You saw that I need RAID above.  Were you just trying to criticize my
> memory of the FAQ cwillu?

It's not asking for trouble, it's just asking for poor performance,
and I suspect even that will depend greatly on the workload.

Snapshots still have nothing to do with it:  you could have btrfs
(with snapshots) on dm-crypt on mdraid.  Btrfs would just lose the
ability to try alternate mirrors and similar; snapshots would still
work just fine.
