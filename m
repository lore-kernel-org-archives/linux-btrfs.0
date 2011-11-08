From: dima <dolenin@parallels.com>
Subject: Re: How to remount btrfs without compression?
Date: Tue, 8 Nov 2011 09:55:29 +0900
Message-ID: <4EB87E01.1040704@parallels.com>
References: <4EB72C1B.1030702@parallels.com> (sfid-20111107_092907_276831_5BC15106) <201111071319.14493.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201111071319.14493.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/07/2011 09:19 PM, Martin Steigerwald wrote:
> Am Montag, 7. November 2011 schrieb dima:
>> Hello,
>
> Hi Dima,
>
>> Is there any possibility to remount a compressed btrfs without any
>> compression at all?
>>
>> Syslinux bootloader does not understand any btrfs compression and
>> whenever I edit syslinux.cfg on my compressed / subvolume, the file
>> becomes compressed and thus unreadable by syslinux on the next boot.
>>
>> I tried to remount / without the 'compress' option (and edit
>> syslinux.cfg in uncompressed state) and while the "mount" command wo=
uld
>> not show compression any more, I can see in the /proc/mounts that
>> compression is still there and the file still gets compressed after
>> editing. But there seem to be no mount option like compress=3Dnone o=
r
>> something.
>>
>> The only workaround I found is to boot from a live CD mount / withou=
t
>> any compression and re-save syslinux.cfg. Then it the file gets
>> uncompressed.
>>
>> Are there any other options except for this workaround to temporaril=
y
>> remount btrfs without compression?
>
> What does lsattr show on the file? Have you tried chattr -c on the fi=
le? It
> might help to do a btrfs filesystem defrag on the file to remove
> compression, cause I don=C2=B4t think chattr -c itself will uncompres=
s it.

Hi Martin,
Thanks for your reply.
Yes, I did check out lsattr. It shows that no flags are set. Setting=20
chattr +c then chattr -c and re-saving file has no effect either.

I also tried to defragment the file itself and the directory where it=20
was in without setting -c but it would not have any effect because / is=
=20
mounted with compression.

> As far as I understand it is possible to individually set compression
> on/off on single files.

Could not find how to turn it off though.

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
