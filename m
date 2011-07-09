From: cwillu <cwillu@cwillu.com>
Subject: Re: Memory leak?
Date: Sat, 9 Jul 2011 13:25:00 -0600
Message-ID: <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
References: <20110703190913.GA4474@yahoo.fr>
	<CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
	<20110706081111.GA6931@yahoo.fr>
	<20110708124429.GB4284@yahoo.fr>
	<1310137241-sup-8158@shiny>
	<20110709170959.GC4294@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110709170959.GC4294@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 9, 2011 at 11:09 AM, Stephane Chazelas
<stephane_chazelas@yahoo.fr> wrote:
> 2011-07-08 11:06:08 -0400, Chris Mason:
> [...]
>> I would do two things. =C2=A0First, I'd turn off compress_force. =C2=
=A0There's no
>> explicit reason for this, it just seems like the mostly likely place=
 for
>> a bug.
> [...]
>
> I couldn't reproduce it with compress_force turned off, the
> inode_cache reached 600MB but never stayed high.
>
> Not using compress_force is not an option for me though
> unfortunately.

Disabling compression doesn't decompress everything that's already comp=
ressed.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
