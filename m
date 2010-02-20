From: Shuduo Sang <sangshuduo@gmail.com>
Subject: Re: btrfs testing suite?
Date: Sat, 20 Feb 2010 13:41:39 +0800
Message-ID: <ee101c361002192141p771dfabag4a1aba48723ceec3@mail.gmail.com>
References: <BLU120-W29F99FB7CDE39C3532F475D8460@phx.gbl> <93cdabd21002191055w2e6b9470o93525fb0879ff708@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Mr. Tux" <tuxoholic@hotmail.de>, linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002191055w2e6b9470o93525fb0879ff708@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 20, 2010 at 2:55 AM, Mike Fedyk <mfedyk@mikefedyk.com> wrot=
e:
> On Fri, Feb 19, 2010 at 10:46 AM, Mr. Tux <tuxoholic@hotmail.de> wrot=
e:
>>
>>
>> Hi listIs there a btrfs testing suite the btrfs developers use to ch=
eck the codebase? I did some research and found a projectcalled xfstest=
s-dev. It supports ext4 as well - are there any patches to get btrfs su=
pport with xfstests?
>
> There are also different versions of fsx that attempt to "fuzz" the
> filesystems. =A0Btrfs has additional "edges" that need to be fuzzed s=
o
> it will need to be extended. =A0Running those as well as normal every
> day use and your typical workload will help btrfs most.
>

could you pls point me where to download that? thanks.

> Just install it and use it like normal, but make sure you have backup=
s
> and another system you can switch to if something goes wrong.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
