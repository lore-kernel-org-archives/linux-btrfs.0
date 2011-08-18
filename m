From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: processes stuck in llseek
Date: Thu, 18 Aug 2011 11:53:33 -0500
Message-ID: <CAKcLGm8rY+3TYpe=ivmNrsZgUcBcgk3-6RRe81vGComN2bqgMw@mail.gmail.com>
References: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com>
	<1313499055-sup-2296@shiny>
	<CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com>
	<4E4B181E.8000508@cn.fujitsu.com>
	<CAKcLGm-c8zEi+=j2M_QjvS3GGJezvN_DTbUwb-tZtjPj9ZhNrQ@mail.gmail.com>
	<1313683211-sup-3134@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Dan Merillat <dan.merillat@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS Mailing list <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313683211-sup-3134@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 18, 2011 at 11:00 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> Excerpts from Mitch Harder's message of 2011-08-18 11:40:17 -0400:
>> On Tue, Aug 16, 2011 at 8:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrot=
e:
>> > Dan Merillat wrote:
>> >> On Tue, Aug 16, 2011 at 8:51 AM, Chris Mason <chris.mason@oracle.=
com> wrote:
>> >>> Excerpts from Dan Merillat's message of 2011-08-15 23:59:50 -040=
0:
>> >>
>> >>> Dan Carpenter sent a patch for this, I'll get it queued up for r=
c3.
>> >>
>> >> Can you send it? =A0I'd like to test it to see if it fixes my sys=
tem.
>> >
>> > Here it is.
>> >
>> > http://marc.info/?l=3Dlinux-btrfs&m=3D131176036219732&w=3D2
>> >
>>
>> Doesn't this patch rely on Josef's SEEK_HOLE/SEEK_DATA patch set whi=
ch
>> isn't in the kernel yet?
>>
>> http://marc.info/?l=3Dlinux-btrfs&m=3D130927580606177&w=3D2
>
> It does, but the hang was reported on 3.1-rc1, which does have Josef'=
s
> code.
>

Thanks.

That gives me some insights regarding the differences between the
'for-linus' and the 'for-linus-merged' branches.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
