From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: LABEL only 1 device
Date: Mon, 27 Feb 2012 22:33:22 +0100
Message-ID: <4F4BF6A2.4020408@gmail.com>
References: <C3f4teQD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3f4teQD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Helmut,

are you sure that 'mkfs.ext2/3/4 -L "label" /dev/xxx' doesn't create a 
new fs?

Afaik to change a label of a given (ext2/3/4) filesystem you should use 
tune2fs.

I don't have a linux system available right now but this is what I would 
expect and what would make a lot more sense then changing a label via 
mkfs.ext2/3/4. If you are correct with that labeling thing then the 
btrfs way makes like 1000x more sense then the way ext2/3/4 does it.

mkfs should only be used for creating filesystems. For changing existing 
fs tools like tune2fs, btrfs etc. should be used.

Regards,
Felix


On 2/27/12 10:15 PM, Helmut Hullen wrote:
> Hallo, Duncan,
>
> Du meintest am 27.02.12:
>
>>>>     I've said this several times: Your expectations are wrong. You
>>>> don't label partitions.
>
>>> Yes - now I know.
>>> But I'm afraid other people also expect wrong - when I use
>>> mkfs.ext[234] then this option works (in another way than with
>>> "mkfs.btrfs").
>
>> AFAIK, it works in the same way... that is, it labels the, in that
>> case, ext2/3/4 filesystem, in this case (mkfs.btrfs), btrfs
>> filesystem.
>
>>  From the manpages:
>
>> mkfs.btrfs (aka mkbtrfs):
>
>>         -L, --label name
>>                Specify a label for the filesystem.
>
>> mkfs.ext2/3/4 (aka mke2fs):
>
>>         -L new-volume-label
>>                Set  the  volume  label  for the filesystem to
>> 	      new-volume-label.  The maximum length of the
>>                volume label is 16 bytes.
>
> But there's a small difference:
>
>          mke2fs -L MyLabel /dev/sdn4
>
> only sets/changes the label (ok - it tests the type of the partition and
> refuses labeling if the type doesn't fit).
>
>          mkfs.btrfs -L MyLabel /dev/sdn4
>
> not only sets/changes the label but also (re-)creates a btrfs
> filesystem, using the default parameters.
>
> I had to learn this difference ...
>
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
