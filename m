From: Zhihui Zhang <zzhsuny@gmail.com>
Subject: Re: idea about internal fragmentation in Btrfs
Date: Sun, 20 Jun 2010 04:20:54 +0800
Message-ID: <AANLkTikSD70wX4eBi6GZyOSqL478dmT8_eEmYzz9zzk9@mail.gmail.com>
References: <AANLkTilWguh4IrDHVgtTxjoiAeSy23SK_M1dWapgvSDt@mail.gmail.com>
	<87k4pvo16d.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87k4pvo16d.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

Makes perfect sense. No wonder some btrfs folks used to work on
reiserfs/4. I hope a solution can be or has been found.

On Sat, Jun 19, 2010 at 4:51 PM, Andi Kleen <andi@firstfloor.org> wrote=
:
> Zhihui Zhang <zzhsuny@gmail.com> writes:
>
>> I wish Btrfs well, so I would venture an idea for this specific case
>> mentioned by Edward Shishkin today.
>>
>> Everyone knows that B-tree has internal and leaf nodes. =A0Can we ma=
ke
>> the root as the leaf? =A0In other words, if you
>> create a 2K file, the B-tree will have only one node, which is both
>> the root and the leaf. Of course, you need some flag to
>> say this is a "degenerated" form of B-tree. Please cc me if you want
>> my response.
>
> You need to copy linux-btrfs to reach btrfs developers.
> Ccs added
>
> The problem with your idea is that on btrfs there's only
> a single tree for the whole fs (or whole snapshot rather)
> So it would only work for a single file because there's
> only a single root.
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
