From: Jordan Windsor <jordanw2@gmail.com>
Subject: Re: Find RAID level, Change RAID level.
Date: Mon, 31 Oct 2011 00:56:51 +1030
Message-ID: <CACCfv7rE+1v5bAo4aDDq1i-_4BG8VRCTowDQt1uWDaZ=czgCyQ@mail.gmail.com>
References: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
	<Bwm7ykHD1uB@helmut.hullen.de>
	<CACCfv7onURQQGGtY63kcirrxFtW4w-K8x0uqb_TPExoJc96row@mail.gmail.com>
	<20111030140617.GA7012@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111030140617.GA7012@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2011 at 12:36 AM, Ilya Dryomov <idryomov@gmail.com> wro=
te:
> On Mon, Oct 31, 2011 at 12:10:34AM +1030, Jordan Windsor wrote:
>> Thanks, It currently shows this:
>>
>> Data: total=3D195.01GB, used=3D193.93GB
>> System, DUP: total=3D8.00MB, used=3D28.00KB
>> System: total=3D4.00MB, used=3D0.00
>> Metadata, DUP: total=3D1.75GB, used=3D385.41MB
>> Metadata: total=3D8.00MB, used=3D0.00
>>
>> I didn't specify any RAID levels during creation. I'd like to have a
>> RAID0 installation across two hard drives.
>
> How many devices do you have in your FS right now ? =A0If it's only 1=
 then
> add another one (btrfs device add <dev> <path to FS>) and run balance
> (btrfs fi balance <path to FS>). =A0That should give you raid0 for da=
ta
> across two drives w/o applying any patches.
>
> Thanks,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Ilya
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Thanks, I was wondering if I added a device that was already part of
another btrfs volume, then would I have the files merged as one volume
or overwritten in the newly added one?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
