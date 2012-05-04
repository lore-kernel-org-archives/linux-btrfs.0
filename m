From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Can't mount
Date: Fri, 4 May 2012 10:43:16 +0700
Message-ID: <CAG1y0sc3tkkek19p_yu9qg8nTOg4YBPe6dLecC7ggVA17qVtXA@mail.gmail.com>
References: <CAPAyKow8hk5kzAkkTG=nmOMpnhjx3cjM_-uLGNVmNWXNc+1j=g@mail.gmail.com>
	<CAPAyKowHusQXh-BzvgQRBL8=82yTgP+marcdVq8wLtSxuoCyvQ@mail.gmail.com>
	<20120503153127.GG9860@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, "Yo'av Moshe" <bjesus@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120503153127.GG9860@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 3, 2012 at 10:31 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, May 03, 2012 at 03:18:01PM +0000, Yo'av Moshe wrote:

>> Is there anything else I can try?
>>
>> I'm using kernel 3.2 on Ubuntu 12.04.
>
> =A0 In approximate order:
>
> =A0* Try a 3.3 or 3.4-rc5 kernel. I don't think those will do anythin=
g
> =A0 to fix this particular issue, but it's worth a try.
>
> =A0* You have the last-but-one generation listed by find-root:
>
> Well block 216926195712 seems great, but generation doesn't match, ha=
ve=3D135713, want=3D135714
>
> =A0 so you can use the restore tool[1] with that block number (and -t=
)
> =A0 to copy off any data that you need that isn't backed up.

Is btrfs-zero-log still relevant? I imagine losing several last
transactions is MUCH more convinient than having to recreate the
enitre fs (even if restore managed to salvage everything).

And what about mont -o ro,recover?

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
