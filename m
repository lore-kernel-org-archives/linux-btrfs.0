From: Daniel J Blueman <daniel@quora.org>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Mon, 9 Apr 2012 22:54:09 +0800
Message-ID: <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com>
	<4F82F5BA.3080504@kraav.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Leho Kraav <leho@kraav.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F82F5BA.3080504@kraav.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 9 April 2012 22:44, Leho Kraav <leho@kraav.com> wrote:
> On 09.04.2012 17:35, Daniel J Blueman wrote:
>>
>> Leho Kraav<leho<at> =A0kraav.com> =A0writes:
>> []
>>>
>>> Apr =A08 02:46:11 s9 kernel: [ =A0189.691778] attempt to access bey=
ond end
>>> of device
>>> Apr =A08 02:46:11 s9 kernel: [ =A0189.691787] dm-3: rw=3D129, want=3D=
23361976,
>>> limit=3D20967424
>>
>>
>> I recently bumped into this too [1]. Liu Bo posted a patch for it [2=
],
>> which tests out fine here. The workaround is to not mount with
>> 'discard' until eg ~3.4-rc3 or later.
>>
>> [1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16409
>> [2] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16649
>
> Oh wow, thanks. This sounds exactly like what happened. I got the liv=
elock
> post off my search results, but the patch post doesn't seem to have a=
ny of
> the keywords I was looking for, since I had no idea it could be relat=
ed to
> discards.
>
> So can this become a problem earlier too, not only when the space use=
d is
> approaching limits? If not, I think I should be good until 3.4:

Looks like it affects at least 3.3 and 3.4-rc1/2 in all circumstances.

> $ sudo btrfs fi show
> Label: 'S9-HOME' =A0uuid: 1ed06dbc-e1b7-433f-8d1b-19cf1f7756f1
> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 12.93GB
> =A0 =A0 =A0 =A0devid =A0 =A01 size 60.00GB used 20.04GB path /dev/dm-=
0
>
> Label: 'S9-ROOT' =A0uuid: 6206dfce-afcf-4afe-9047-b1c88a7889fd
> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 8.75GB
> =A0 =A0 =A0 =A0devid =A0 =A01 size 30.00GB used 18.29GB path /dev/dm-=
1
>
> I think I'd like to keep using "discard" for SSD still, unless a smar=
t
> person says it's not particularly useful anyway.

If your SSD has background garbage collection and there are disk idle
periods, the synchronous discards will have little benefit.

> So while I'm on 3.3, is the patch from gmane:16649 good enough to eli=
minate
> immediate dangers?

Yes.

> And is the previous filesystem still hosed for good then? Or mounting=
 the
> images with -discard might help?

It seems like the kernel caught and prevented the discard after the
end of the partition, so the data should be fine; scrubbing will tell
you.

Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
