From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Fri, 17 Jul 2009 15:12:34 -0400
Message-ID: <e692861c0907171212l26748081n7fa8b55b8df9bd1e@mail.gmail.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>
	 <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
	 <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com>
	 <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com>
	 <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com>
	 <4A609D8D.8050501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Woodhouse <dwmw2@infradead.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A609D8D.8050501@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 17, 2009 at 11:49 AM, H. Peter Anvin<hpa@zytor.com> wrote:
> Ric Wheeler wrote:
>>>
>>> The bottom line is pretty much this: the cost of changing the encod=
ing
>>> would appear to outweigh the benefit. I'm not trying to claim the L=
inux
>>> RAID-6 implementation is optimal, but it is simple and appears to b=
e
>>> fast enough that the math isn't the bottleneck.
>>
>> Cost? Thank about how to get free grad student hours testing out thi=
ngs
>> that you might or might not want to leverage on down the road :-)
>>
>
> Cost, yes, of changing an on-disk format.

In the context of BTRFS the only costs are development of the new
erasure code and integration as well as the possible cost of carrying
around two erasure codes (one for MD backwards compatibility, one for
BTRFS).

The availability of arbitrary M of N erasure codes is more attractive
for BTRFS than MD because of the increased granularity. I.e. with
BRTFS you might want a smaller stripe width because some sub-volume
spans fewer spindles, or increased parity blocks you need increased
redundancy for some small set of files.

On the other hand=E2=80=94 for performance reasons if you want addition=
al
redundancy beyond 'RAID6' you might just be better off writing more
duplicates of the data blocks instead of additional RS syndromes since
while the additional data blocks are not optimal from an error
recovery perspective they will provide a performance gain of being
able to spread reads out across additional disks.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
