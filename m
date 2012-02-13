From: Dmitry Olenin <dolenin@parallels.com>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 23:31:42 +0900
Message-ID: <4F391ECE.7090405@parallels.com>
References: <4F38B8F0.5020506@yahoo.com> <4F38BE53.4080204@parallels.com> <20120213140921.5a009404@natsu> <4F39133F.50908@parallels.com> <20120213195116.26e64e16@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213195116.26e64e16@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/13/2012 10:51 PM, Roman Mamedov wrote:
> On Mon, 13 Feb 2012 22:42:23 +0900
> dima<dolenin@parallels.com>  wrote:
>
>>> gcc -o /usr/local/bin/nocow nocow.c
>>> ln -sf /usr/local/bin/nocow /usr/local/bin/cow
>
>> I don't seem to be able to 'unset' the NOCOW flag.  Looking at the code
>> I would guess that it is supposed to alternate between 'cow' and 'nocow'
>> states, but the condition
>>       printf("Remove NOCOW flag for %s\n", argv[1]);
>> never shows for me. What should I do to make it working?
>> Maybe it would be nice to have a switch to just check if nocow is set on
>> file without actually changing the flag.
>
> If you place it in /usr/local/bin and also make a symlink "nocow ->  cow" as
> described in the quoted part above, you can then just run:
>
> # cow ./filename
>
> and the program will instead unset the NOCOW flag.
>
> Of course it remains to be a very basic program, I'm not sure if it's worth
> developing it further, or to add this to 'btrfs', as Liu Bo in the adjacent
> thread said that there are patches to chattr/lsattr for using the COW
> attribute.
>

Thanks Roma! I overlooked the symlink. Works!
~dima
