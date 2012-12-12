Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38414 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755088Ab2LLUGZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 15:06:25 -0500
Message-Id: <1355342784.940.140661165251717.298B576B@webmail.messagingengine.com>
From: merc1984@f-m.fm
To: cwillu <cwillu@cwillu.com>
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <CAE5mzvjrGZVU7p9dTWiJ1pNZUe_Xj5m78FJte4Enb1od=iqVTA@mail.gmail.com>
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
 <1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
 <CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
 <1355337523.8384.140661165218221.778EBD55@webmail.messagingengine.com>
 <CAE5mzvjrGZVU7p9dTWiJ1pNZUe_Xj5m78FJte4Enb1od=iqVTA@mail.gmail.com>
Subject: Re: Encryption
Date: Wed, 12 Dec 2012 12:06:24 -0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 12, 2012, at 10:48, cwillu wrote:
> Sayeth the FAQ:

Oh pardon me, it's BTRFS RAID that's a no-go, which is just as critical
to me as I have a 4 disk 8TB array.
The FAQ goeth on to Say:
-----------------------------------------------------------
This pretty much forbids you to use btrfs' cool RAID features if you
need encryption. Using a RAID implementation on top of several encrypted
disks is much slower than using encryption on top of a RAID device. So
the RAID implementation must be on a lower layer than the encryption,
which is not possible using btrfs' RAID support.
 -----------------------------------------------------------

You saw that I need RAID above.  Were you just trying to criticize my
memory of the FAQ cwillu?


-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

