From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Cross-subvolume link causes kernel BUG
Date: Mon, 8 Mar 2010 18:16:06 -0800
Message-ID: <93cdabd21003081816s3bc3c09eoa326d4ea71ce7b1@mail.gmail.com>
References: <20100308172438.GA5506@untroubled.org>
	 <m3hboqsof9.fsf@pullcord.laptop.org>
	 <20100308182656.GA7102@untroubled.org>
	 <93cdabd21003081321k48dc2b12td538e397323ae0f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21003081321k48dc2b12td538e397323ae0f8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 8, 2010 at 1:21 PM, Mike Fedyk <mfedyk@mikefedyk.com> wrote=
:
> On Mon, Mar 8, 2010 at 10:26 AM, Bruce Guenter <bruce@untroubled.org>=
 wrote:
>> On Mon, Mar 08, 2010 at 12:39:38PM -0500, Chris Ball wrote:
>>> I think this is fixed in 2.6.33, as a result of the patch below.
>>> Let us know if you see a segfault on 2.6.33, or after applying this
>>> patch to your current kernel.
>>
>> This patch does fix the problem for 2.6.32.9, thanks. =C2=A0Has this=
 patch
>> been submitted for the 2.6.32.y series?
>
> Btrfs patches aren't in any stable series yet. =C2=A0Also I suspect -=
stable
> for .32 will stop soon.
>
Oh, disregard that comment about -stable and .32.  I forgot it will be
maintained for a few years....
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
