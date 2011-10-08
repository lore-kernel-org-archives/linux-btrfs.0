From: Asdo <asdo@shiftmail.org>
Subject: Re: Honest timeline for btrfsck
Date: Sat, 08 Oct 2011 23:13:54 +0200
Message-ID: <4E90BD12.9020407@shiftmail.org>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <CAAE6i0i-AsH7TkupkrFDdv26gN_-pshFFwvuH1nOuuSmKWbZdQ@mail.gmail.com>
 <4E8F4EA9.4090108@shiftmail.org> <201110072219.52773.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <201110072219.52773.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/07/11 22:19, Diego Calleja wrote:
> On Viernes, 7 de Octubre de 2011 21:10:33 Asdo escribi=F3:
>> failures, but you can always mount by rolling back to a previous
>> uberblock, showing an earlier view of the filesystem, which would be
>> consistent.
> This is already available in Btrfs, command btrfsck -s.

Whops!? Then I am wondering what causes these corrupted unmountable=20
filesystems.
I think that in Btrfs wiki (which is now down) there was written that=20
btrfs was substantially stable, with the only exception that a power=20
loss combined with drives not honoring barriers could result in an=20
unmountable filesystems.
This is misleading information then.
If btrfsck -s is already available, power loss + not honoring barriers=20
cannot be the reason for unmountable filesystems. The wiki should be=20
changed...
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
