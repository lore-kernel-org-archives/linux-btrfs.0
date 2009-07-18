From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Sat, 18 Jul 2009 09:26:16 -0700
Message-ID: <e9c3a7c20907180926v8ed6cdew2666086888be0d3b@mail.gmail.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>
	 <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
	 <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com>
	 <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com>
	 <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com>
	 <4A609D8D.8050501@zytor.com>
	 <1247918016.22313.138.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Ric Wheeler <rwheeler@redhat.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247918016.22313.138.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 18, 2009 at 4:53 AM, David Woodhouse<dwmw2@infradead.org> w=
rote:
> On Fri, 2009-07-17 at 11:49 -0400, H. Peter Anvin wrote:
>> Cost, yes, of changing an on-disk format.
>
> Personally, I don't care about that -- I'm utterly uninterested in th=
e
> legacy RAID-6 setup where it pretends to be a normal disk. I think th=
at
> model is as fundamentally wrong as flash devices making the similar
> pretence.

I can understand the frustration of these details being irretrievably
hidden behind a proprietary interface out of the filesystem's control.
 However, this is not the case with Linux software RAID.  I suspect
that there is room for more interaction with even "legacy" filesystems
to communicate things like: "don't worry about initializing that
region of the disk it's all free space", "don't bother resyncing on
dirty shutdown, if power-loss interrupts a write I guarantee I will
replay the entire stripe to you at a later date", or "hey, that last
block I read doesn't checksum, can you come up with a different
version?"

I was under the impression that btrfs wanted to leverage md's stripe
handling logic as well, seems that is not the case?

--
Dan

> =B9 Well, kind of. The xor_blocks() function will silently screw you =
over
> =A0if you ask it to handle more than 5 blocks at a time.

async_xor() handles arbitrary block counts.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
