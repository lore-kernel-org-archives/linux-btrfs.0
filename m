From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: TRIM support
Date: Mon, 4 Jul 2011 17:32:16 +0100
Message-ID: <CAAeznTp0i4RCF61p-4SbFfipkHt9dzuAN=ec1ZrtEzD9Vxgx1g@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<1309635918.3774.7.camel@nayuki>
	<201107041820.11370.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Calvin Walton <calvin.walton@kepstin.ca>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107041820.11370.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 4, 2011 at 5:20 PM, Martin Steigerwald <Martin@lichtvoll.de=
> wrote:
> Am Samstag, 2. Juli 2011 schrieben Sie:
>> On Sat, 2011-07-02 at 19:08 +0100, Leonidas Spyropoulos wrote:
>> > Hello,
>> >
>> > I just installed an archlinux with btrfs root partition and would
>> > like to set the correct mount properties
>> > Following this:
>> > https://wiki.archlinux.org/index.php/Solid_State_Drives
>> > it says there that I should use the discard mount parameter to ena=
ble
>> > TRIM.
>> >
>> > I would like to ask by using ssd mount parameter would TRIM be
>> > enabled? The SSD is Intel 320 Series 120Gb
>>
>> No, the "ssd" mount parameter has nothing to do with TRIM.
> [...]
>> The discard option is not currently automatically enabled; I think
>> there may have been some performance issues in certain cases with
>> drives that have slow trim implementations. But feel free to give it=
 a
>> try.
>
> As alternative use fstrim command from time to time or regularily dur=
ing a
> cron job. From what I understood it does batched discard of all free
> blocks in a filesystem.
>
> merkaba:~> time fstrim -v /
> /: 5044342784 bytes was trimmed
> fstrim -v / =A00,00s user 0,36s system 10% cpu 3,486 total
>
> merkaba:~> time fstrim -v /home
> /home: 27062587392 bytes was trimmed
> fstrim -v /home =A00,00s user 0,92s system 20% cpu 4,512 total
>
> First one is BTRFS, second one is Ext4 - and will be, until I am conv=
inced
> that BTRFS has a fully featured and working fsck and until its
> experimental flag is removed.
>
> fstrim is in util-linux(-ng) when its new enough.
Do I need to run fstrim command while the partition is offline or can
it be done while mounted?

>
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA =A0B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
