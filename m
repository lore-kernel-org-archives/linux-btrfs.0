From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Honest timeline for btrfsck
Date: Sun, 9 Oct 2011 08:19:59 +0700
Message-ID: <CAG1y0sdfnq9Tx8u+wDSuyLkUjXe8h1idXDL69fPps9shcMPubw@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<CAAE6i0i-AsH7TkupkrFDdv26gN_-pshFFwvuH1nOuuSmKWbZdQ@mail.gmail.com>
	<4E8F4EA9.4090108@shiftmail.org>
	<201110072219.52773.diegocg@gmail.com>
	<4E90BD12.9020407@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E90BD12.9020407@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 9, 2011 at 4:13 AM, Asdo <asdo@shiftmail.org> wrote:
> On 10/07/11 22:19, Diego Calleja wrote:
>>
>> On Viernes, 7 de Octubre de 2011 21:10:33 Asdo escribi=F3:
>>>
>>> failures, but you can always mount by rolling back to a previous
>>> uberblock, showing an earlier view of the filesystem, which would b=
e
>>> consistent.
>>
>> This is already available in Btrfs, command btrfsck -s.
>
> Whops!? Then I am wondering what causes these corrupted unmountable
> filesystems.

"-s" does not select previous uberblock. It selects alternate uberblock=
=2E

> I think that in Btrfs wiki (which is now down) there was written that=
 btrfs
> was substantially stable, with the only exception that a power loss c=
ombined
> with drives not honoring barriers could result in an unmountable
> filesystems.

for this condition btrfs-zero-log will be more useful

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
