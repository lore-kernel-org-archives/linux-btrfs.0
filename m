From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: raidz-like operation?
Date: Tue, 14 Jul 2009 01:14:25 +0200
Message-ID: <5E752AC2-382C-4079-A20F-0E7FA1DB02B8@karlsbakk.net>
References: <952FC056-F524-420A-9826-F8A287BB2139@karlsbakk.net> <1247324390.17811.9.camel@macbook.infradead.org>
Reply-To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247324390.17811.9.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 11. juli. 2009, at 16.59, David Woodhouse wrote:

> On Fri, 2009-07-10 at 10:58 +0200, Roy Sigurd Karlsbakk wrote:
>> I know it's not in yet, but is there a plan to implement raid-z(2)-
>> like operation? I have heard of plans to integrate with the existing
>> md-subsystem in the kernel, but I'm not sure if this will be
>> appropriate comparing this to how things are done in zfs/raid-z.
>
> I'm currently working on the basic implementation of RAID5/RAID6 (qv)=
=2E
> I don't think there'll be much integration with the md subsystem --
> we'll probably just shift the cunning GF arithmetic out into lib/raid=
6
> or something, then let them both use it from there.
>
> We do want to do full stripe writes to the RAID[56] parts, so we're
> going to want to do something like falling back to RAID1 (or to a =20
> RAID5
> chunk with smaller stripe length) for smaller allocations. That's
> basically what you're talking about, isn't it?


In ZFS/RAIDZ(2) they are said to use RAID3-like partial writes as with =
=20
with a file-level redundancy, meaning if a file won't cover a whole =20
stripe, it'll use a partial one. I'm not sure if this is the case, but =
=20
it's what I've been told by the people from Sun. This may open for =20
fewer IOPs per write. Is something like this in the thoughts of the =20
new RAID[56] in BTRFS?

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres =20
intelligibelt. Det er et element=E6rt imperativ for alle pedagoger =E5 =
=20
unng=E5 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de =20
fleste tilfeller eksisterer adekvate og relevante synonymer p=E5 norsk.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
