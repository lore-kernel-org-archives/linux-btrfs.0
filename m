From: brandon lansing <imraven@gmail.com>
Subject: Re: Fwd: module/kernel crash while trying to delete missing device/balance
Date: Tue, 19 Apr 2011 09:42:26 -0600
Message-ID: <BANLkTin9U-fzK0S39c2PiEsJ1N4s0fsL0A@mail.gmail.com>
References: <BANLkTim+b7sApGb_0=g2Po0+swoMunOd7A@mail.gmail.com>
	<BANLkTinYEiWgw3ykLYr8yqLicjP7v1F5Hg@mail.gmail.com>
	<1303214237-sup-2056@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303214237-sup-2056@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 19, 2011 at 05:58, Chris Mason <chris.mason@oracle.com> wro=
te:
> Excerpts from brandon lansing's message of 2011-04-18 23:13:06 -0400:
>> Hello,
>>
>> Distro: Ubuntu 10.10
>> Kernel:=A0Linux 2.6.35-28-generic #50-Ubuntu SMP Fri Mar 18 18:42:20=
 UTC
>> 2011 x86_64 GNU/Linux
>> Btrfs tools version:=A0Btrfs Btrfs v0.19
>>
>> I currently have 2 X 500GB hard drives in 'raid1' mode with about
>> 400GB used. =A0Recently one of the hard drives crashed (but I have a
>> backup) but I'd like to help out if I can because I'm currently
>> getting an error when trying to 'rebuild' the filesystem.
>> I've mounted the array in degraded mode and added the new hard drive=
=2E
>> Finally I issued the command to delete the missing device. =A0The dm=
esg
>> looks normal for a while with messages such as:=A0btrfs: relocating
>> block group 466167529472 flags 17. =A0However, after a few minutes o=
f
>> running I get the following:
>>
>> [ 1770.041623] ------------[ cut here ]------------
>> [ 1770.041655] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/vol=
umes.c:3037!
>> [ 1770.041684] invalid opcode: 0000 [#1] SMP
>> [ 1770.041707] last sysfs file: /sys/devices/virtual/bdi/btrfs-3/uev=
ent
>> [ 1770.041734] CPU 1
>> [ 1770.041744] Modules linked in: btrfs sha256_generic cryptd
>
> Could you please attached the fs/btrfs/volumes.c from this distro
> kernel? =A0It'll help us figure out what is going wrong.
>
> -chris
>

Chris,

Thanks for the prompt response, however, I think it may have had
something to do with the version of btrfs I was running with the
kernel 2.6.35-28-generic in Ubuntu.  I upgraded to Ubuntu 11.04
(natty) and kernel 2.6.38-8-generic and this solved my problem.  I was
able to rebuild all 374GB without error.

Thanks,

Brandon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
