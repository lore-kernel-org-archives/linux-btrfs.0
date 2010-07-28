From: wks1986 <wks1986@gmail.com>
Subject: Re: A device dedicated for metadata?
Date: Wed, 28 Jul 2010 23:49:33 +0800
Message-ID: <AANLkTi=XBx11aj=_OLpQkAwOzuG4-nENPKvDqdwYA0rT@mail.gmail.com>
References: <AANLkTik3Mrf+vY6qW6TTtGEghm48ma8tjiWYGfcLhhMq@mail.gmail.com>
	<20100728131428.GA2664@laptop.jp.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100728131428.GA2664@laptop.jp.oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

You are right.  The single SSD would become a single point of failure.

But if metadata should be mirrored in order to gain reliablilty,
synchronizing between multiple devices may hurt performance.
Mirroring between two SSDs should be reasonable, but synchronizing
metadata between an SSD and an HDD may make it as slow as the slower
HDD.  So I think it is still necessary to control where metadata are
stored.

Another issue is the speed of fsck.  There will always be times when
the operating system is brought down abnormally and fsck is necessary.
 In order to make the downtime as short as possible, fsck should be
fast.  In this case, when metadata are stored in a fast device, fsck
will be significantly faster.  The "hot data tracking" patch is based
on the statistics of ONLINE accesses.  Some data may suddenly become
hot when the filesystem goes offline for fsck.

Kunshan Wang.

2010/7/28 Wengang Wang <wen.gang.wang@oracle.com>:
> Hi,
>
> I have a question to your requirement:
>
> If the meta is stored on the SSD and not on other HDDs, I think the S=
SD is must
> to be "online" whenever you mount any of the HDDs. And in other words=
, without
> the SSD, other HDDs are meaningless. Is that acceptable?
>
> regards,
> wengang.
> On 10-07-28 17:32, wks1986 wrote:
>> Hello
>>
>> Recently I am learning about the Btrfs.
>>
>> My requirement is to construct a cross-device btrfs volume consistin=
g
>> of a single SSD and many (much larger) HDDs. =C2=A0The tricky part i=
s that
>> I want the SSD to be dedicated to metadata since SSDs are much faste=
r
>> (and more expensive) than HDDs and metadata are much more frequently
>> queried than data. =C2=A0And I do not want ordinary data to use up t=
he
>> precious space on the SSD in case there would be no room for metadat=
a.
>>
>> I have figured out that I can keep the metadata stored inside the
>> first device by applying the "-m single" option to mkfs.btrfs.
>> However, I do not know how to require that data should NOT be
>> allocated on the SSD. =C2=A0I read the mkfs code. =C2=A0It appears t=
o me that it
>> can be worked around by excluding the SSD from the "raid group" for
>> ordinary data.
>>
>> A recent patch have been proposed to move "hot" (according to
>> statistics) data to SSDs in order to improve performance. =C2=A0My c=
ase is
>> similar, but I know in advance that metadata are hotter.
>>
>> I am not very confident about what I have found, so I need some
>> comment. =C2=A0Is it necessary to modify the Btrfs code? =C2=A0On th=
e other
>> hand, I have not figured out exactly how much metadata there would b=
e
>> with a given amount of data. =C2=A0How significant will it be to exc=
lude
>> ordinary data from the SSD?
>>
>> Kunshan Wang
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
