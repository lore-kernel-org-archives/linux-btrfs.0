From: Ben Klein <shacklein@gmail.com>
Subject: Re: Bug(?): btrfs carries on working if part of a device disappears
Date: Fri, 13 Jan 2012 23:51:11 +1100
Message-ID: <CAJboL94TVBsLHVmX8O4_xtM+NWf1tcAnL_B=E4kg+yvQt=ScYA@mail.gmail.com>
References: <CAO=zWD+2D-qH-uLqdta6Yy_L2cE0ggCn7rMDUFz+w-9VMM=pQw@mail.gmail.com>
 <4F101E76.5070200@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Maik Zumstrull <maik@zumstrull.net>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F101E76.5070200@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13 January 2012 23:07, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 01/06/2012 02:02 AM, Maik Zumstrull wrote:
>> Hello list,
>>
>> I hit a funny BIOS bug the other day where the BIOS suddenly sets a
>> HPA on a random hard disk, leaving only the first 33 MB accessible.
>> That disk had one device of a multi-device btrfs on it in my case.
>> (With dm-crypt/LUKS in between, no partitioning or LVM.)
>>
>> The reason I'm writing to you is that btrfs apparently didn't care a=
t
>> all. It didn't complain, and it certainly didn't consider "Uhm, mayb=
e
>> I should stop writing to a file system that mostly doesn't exist
>> anymore." The only errors I saw in dmesg were from the lower block
>> device level: someone trying to read or write beyond the end of a
>> device. An error btrfs apparently didn't mind. It took me a while to
>> figure out what had happened, during which time btrfsck and the btrf=
s
>> kernel part worked together to pretty much totally trash the fs. (I'=
m
>> still trying a few things, but I'm not hopeful. Hold the default
>> backup rant, I can in fact recover anything that was on this from
>> elsewhere, I think.)
>>
>> So, I think during mount, btrfs should check the reported size of th=
e
>> block device, and if it's significantly smaller than fs metadata
>> implies it must be, mount degraded or read-only or not at all. And
>> mostly, complain. Loudly.
>>
>
> I also notice this, when we "mkfs.btrfs" with a "-b fssize", if "fssi=
ze" is
> larger than dev size, it will not complain and get "beyond the end" e=
rrors.
>
> so maybe we limit the mkfs size:
>
> diff --git a/mkfs.c b/mkfs.c
> index e3ced19..3ac8525 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1282,6 +1282,8 @@ int main(int ac, char **av)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D btrfs_=
prepare_device(fd, file, zero_end, &dev_block_count, &mixed);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (block_coun=
t =3D=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0block_count =3D dev_block_count;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (block_count > =
dev_block_count);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 block_count =3D dev_block_count;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ac =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0file =3D av[op=
tind++];
>
> thanks,
> liubo

It might be a better idea to error out at this point. If the user is
asking for a filesystem larger than what is possible on the device, I
think the mkfs should fail completely.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
