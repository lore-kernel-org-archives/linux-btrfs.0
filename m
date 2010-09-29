From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Another checksum error bugreport
Date: Wed, 29 Sep 2010 13:37:19 +0200
Message-ID: <AANLkTi=UNd1=_q+n6m0vmf_YvDP1PBWZftCF=dUnNTYx@mail.gmail.com>
References: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
	<AANLkTinqsjRZ8uGpz_xmVHCLLaqC1rO_uE=KFcfMMaW0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Francis Galiegue <fgaliegue@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinqsjRZ8uGpz_xmVHCLLaqC1rO_uE=KFcfMMaW0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 29 September 2010 13:12, Francis Galiegue <fgaliegue@gmail.com> wrot=
e:
> On Wed, Sep 29, 2010 at 12:48, Sebastian 'gonX' Jensen
> <gonx@overclocked.net> wrote:
>> Hey guys,
>>
>> Today I experienced my first checksum error just out of the blue - a=
nd
>> it's not just the 'csum + 1 =3D private' issue, it's a completely
>> different one. Because of this, I am unable to retrieve the data off
>> the drive, even with nodatasum enabled - I simply get an I/O error.
>> Here's the dmesg output:
>>
>> [149423.845177] btrfs: setting nodatasum
>> [149423.850339] Btrfs detected SSD devices, enabling SSD mode
>> [149432.094728] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.117938] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.118340] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.125671] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.126075] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.135671] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>>
>> I would really like to have the files on the drive retrieved in thei=
r
>> entirety, but if that is not possible then that is also OK. Consider
>> this a bugreport and a question on how to retrieve the data now.
>>
>
> Which kernel is that?
It was one of the 2.6.35 versions from the Ubuntu repository. I'm
running Ubuntu 10.04 Server.

> A patch made it in 2.6.36-rc6 which fixed an important bug in the bdi
> code, wherein write requests and discard requests were merged,
> transforming all requests in discard requests.
>
> And you use an SSD... Hmmm.
>
> --
> Francis Galiegue, fgaliegue@gmail.com
> "It seems obvious [...] that at least some 'business intelligence'
> tools invest so much intelligence on the business side that they have
> nothing left for generating SQL queries" (St=C3=A9phane Faroult, in "=
The
> Art of SQL", ISBN 0-596-00894-5)
>

Well, overall it seems to work now. I downgraded to the .32 version in
the Ubuntu 10.04 repository and now I do not get any errors from
dmesg. I don't know what caused it, but I think I'll stick to stable
kernel versions instead. Since this is a production system it's not
very easy for me to troubleshoot this any further if it requires a
reboot. I can unmount and mount the drive from time to time, but not
reboot. If you want btrfs-debug-tree output or something, let me know.

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
