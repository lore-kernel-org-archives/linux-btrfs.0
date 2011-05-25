From: Craig Johnson <crajohns@gmail.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Wed, 25 May 2011 14:32:44 -0500
Message-ID: <BANLkTin7rzxzp7LvoMGtnY+w3UYtHcpy0g@mail.gmail.com>
References: <BANLkTikbunJJTxutLGfs0R_rSfbqWmBf=A@mail.gmail.com>
	<4DDD5852.3070501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDD5852.3070501@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

I can wait a couple of days for the new tool - glad to know that there
is still hope.  If the new btrfsck isn't available within a week or so
I might hit you up for that patch.  Thanks!

- Craig

On Wed, May 25, 2011 at 2:28 PM, Josef Bacik <josef@redhat.com> wrote:
> On 05/25/2011 03:06 PM, Craig Johnson wrote:
>> After doing an upgrade to 2.6.39 from 2.6.39-rc7, I am unable to mou=
nt
>> my 3 disk btrfs volume. =A0It was a clean reboot, which makes it all=
 the
>> more puzzling. =A0This is what I'm getting:
>>
>>
>> [68808.339109] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 2
>> transid 339584 /dev/sdc1
>> [68808.340354] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 1
>> transid 339584 /dev/sda1
>> [68808.340774] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 3
>> transid 339584 /dev/sdb1
>>
>> [70106.913668] btrfs: disk space caching is enabled
>> [70106.968648] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969031] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969403] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969671] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969691] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969704] Failed to read block groups: -5
>> [70107.050658] btrfs: open_ctree failed
>>
>> I went to run a btrfsck, but found out that I needed to compile with
>> the tmp branch or I would get an unsupported features message (lzo a=
nd
>> space_cache). =A0After compiling that, when I run btrfsck, I get thi=
s:
>>
>> parent transid verify failed on 6038227976192 wanted 337418 found 33=
7853
>> parent transid verify failed on 6038227976192 wanted 337418 found 33=
7853
>> parent transid verify failed on 6038227976192 wanted 337418 found 33=
7853
>>
>> And then it stops. =A0This happens with btrfs-debug-tree, or
>> btrfs-select-super. =A0I've tried it on sda1, sdb1, and sdc1 and als=
o
>> with -s 0, -s 1, and -s 2. =A0Dmesg shows a segfault:
>>
>> [71775.589462] btrfsck[14453]: segfault at c4 ip 000000000040e477 sp
>> 00007fffa9eb4d30 error 4 in btrfsck[400000+21000]
>>
>> For fun, I ran it through gdb and I got this:
>>
>> Program received signal SIGSEGV, Segmentation fault.
>> find_first_block_group (root=3D0x61d1b0, path=3D0x61ef10, key=3D0x7f=
ffffffe240)
>> =A0 =A0 at extent-tree.c:3028
>> 3028 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (slot >=3D btrfs_head=
er_nritems(leaf)) {
>>
>>
>>
>> Is there any hope of recovery here? =A0Not the end of the world if t=
he
>> volume is lost, but it would be a bit of a pain and I'm at a loss as
>> to why it happened. =A0I tried mounting with the new integration-tes=
t
>> branch just for fun, but there's no difference on the mounting. =A0A=
ny
>> help that could be provided would be immensely appreciated. =A0Thank=
s!
>>
>
> So I have a patch I can give you that will possibly help you recover
> your data if you don't have backups, or you can wait a couple of days
> (hopefully) for the new btrfsck tool that will be much better than th=
e
> hack I can give you. =A0Thanks,
>
> Josef
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
