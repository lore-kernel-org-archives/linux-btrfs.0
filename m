From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs-convert processing time
Date: Tue, 21 Feb 2012 12:51:58 +0700
Message-ID: <CAG1y0sdUeXwMXRfeuqOosRtpj_TpB_8cxw0xpGXw+LaRDSAD9A@mail.gmail.com>
References: <4F4241D1.4080506@daevel.fr>
	<20458953.qbO19NXijp@k85hala03>
	<4F424D8D.4030802@daevel.fr>
	<1920178.zXOEpupmQW@k85hala03>
	<CAG1y0sevgB0=Y-Sxe_N4zGeZvYp+Pmpjv0q8JeRg22qtkZ0tJw@mail.gmail.com>
	<4F4258D5.4070101@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4258D5.4070101@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2012 at 9:29 PM, Olivier Bonvalet <btrfs.list@daevel.fr=
> wrote:
> On 20/02/2012 15:00, Fajar A. Nugraha wrote:
>>
>> On Mon, Feb 20, 2012 at 8:50 PM, Hubert Kario<hka@qbs.com.pl> =A0wro=
te:
>>>
>>> On Monday 20 of February 2012 14:41:33 Olivier Bonvalet wrote:
>>>>
>>>> Lot of small files (like compressed email from Maildir), and lot o=
f
>>>> hardlinks, and probably low free space (near 15% I suppose).
>>>>
>>>>
>>>> So I think I have my answer :)
>>>>
>>>
>>> Yes, this is probably the worst possible combination.
>>>
>>> Plese keep us updated. Just to have exact numbers for new users.
>>
>>
>>
>> ... although it would probably fail anyway due to btrfs hardlink lim=
it
>> in the same directory.
>>
>
> And in that case, btrfs-convert will abort, or ignore the error, or j=
ust
> hang ?

On my simple test with ubuntu precise, loop-mounted ext4, 8k hardlinks:

$ sudo btrfs-convert /dev/loop0
creating btrfs metadata.
$ echo $?
139

so no useful error message, but it doesn't crash. And when mounted the
device still shows ext4.

A successful conversionn would look like this:

$ sudo btrfs-convert /dev/loop1
creating btrfs metadata.
creating ext2fs image file.
cleaning up system chunk.
conversion complete.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
