From: David Nicol <davidnicol@gmail.com>
Subject: Re: What do the arguments of btrfs filesystem defragment do?
Date: Thu, 16 Dec 2010 14:48:53 -0600
Message-ID: <AANLkTim+hLJOFQcmEJnQVv1verv2x+0-8uwPzLw=tBp-@mail.gmail.com>
References: <4D08E76B.40400@logtenberg.eu> <1292439708-sup-2951@think>
 <4D091387.9050905@logtenberg.eu> <1292440771-sup-9278@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Erik Logtenberg <erik@logtenberg.eu>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292440771-sup-9278@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 15, 2010 at 1:20 PM, Chris Mason <chris.mason@oracle.com> w=
rote:

>>
>> Is there a decent way to have btrfs compress already existing files
>> (that were written before compression was enabled) without hurting a=
ny
>> of the internal structures such as snapshots?
>
> I'm afraid not yet. =C2=A0There is code for this in the btrfs balance
> routines, but we haven't yet adapted it to the defragment command.
>
> -chris

with enough disk space, if the OP adds a compressed device, deletes
the original device, adds it back as compressed, and then deletes the
temporary device, would that work?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
