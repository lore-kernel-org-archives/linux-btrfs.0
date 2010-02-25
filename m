From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/3 V3] btrfs: a new tool to manage a btrfs filesystem
Date: Wed, 24 Feb 2010 19:25:40 -0800
Message-ID: <93cdabd21002241925n1bfcce6dqba86acd955578572@mail.gmail.com>
References: <201002211740.13074.kreijack@libero.it>
	 <93cdabd21002212133o3d257fa6t29d67059e80eb98a@mail.gmail.com>
	 <201002221947.40793.kreijack@libero.it> <20100224233538.GH25641@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>, kreijack@libero.it,
	Mike Fedyk <mfedyk@mikefedyk.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100224233538.GH25641@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2010 at 3:35 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Mon, Feb 22, 2010 at 07:47:40PM +0100, Goffredo Baroncelli wrote:
>> On Monday 22 February 2010, Mike Fedyk wrote:
>> > On Sun, Feb 21, 2010 at 8:40 AM, Goffredo Baroncelli <kreijack@gma=
il.com>
>> wrote:
>> > > =C2=A0 =C2=A0 =C2=A0 filesystem resize [+/-]<size>[gkm]|max <fil=
esystem>
>> >
>> > -filesystem resize [+/-]<size>[gkm]|max <filesystem>
>> > +filesystem resize [+/-]<size>[gkm]|max <dev>
>> >
>> > This command works on devices, not paths.
>>
>> Are you sure ? To me it results (test and code inspection) to work o=
n path.
>
> The ioctl takes a path so that it knows which btrfs filesystem to
> change.
>

Then how does it know which device to shrink in a multi-device filesyst=
em?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
