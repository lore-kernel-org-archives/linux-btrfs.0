Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:65124 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2LLSsr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 13:48:47 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so358554dak.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 10:48:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355337523.8384.140661165218221.778EBD55@webmail.messagingengine.com>
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
	<1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
	<CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
	<1355337523.8384.140661165218221.778EBD55@webmail.messagingengine.com>
Date: Wed, 12 Dec 2012 12:48:46 -0600
Message-ID: <CAE5mzvjrGZVU7p9dTWiJ1pNZUe_Xj5m78FJte4Enb1od=iqVTA@mail.gmail.com>
Subject: Re: Encryption
From: cwillu <cwillu@cwillu.com>
To: merc1984@f-m.fm
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 12, 2012 at 12:38 PM,  <merc1984@f-m.fm> wrote:
>
> On Wed, Dec 12, 2012, at 10:31, Mitch Harder wrote:
>> I run btrfs on top of LUKS encryption on my laptop.  You should be able to do the same.
>>
>> You could then run rsync through ssh.  However, rsync will have no knowledge of any blocks shared under subvolume snapshots.
>>
>> Btrfs does not yet have internal encryption.

> The FAQ says specifically to NOT run BTRFS with any kind of volume
> encryption, so you're asking for trouble.

Sayeth the FAQ:

Does Btrfs work on top of dm-crypt?
This is deemed safe since 3.2 kernels. Corruption has been reported
before that, so you want a recent kernel. The reason was improper
passing of device barriers that are a requirement of the filesystem to
guarantee consistency.

> And clearly encryption is not possible if you need snapshots.

Snapshots don't come into this at all:  btrfs doesn't care where the
block devices it's on come from.  Things like dm-crypt show btrfs (or
whatever filesystem you put on it) a decrypted view of the device.
