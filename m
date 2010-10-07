From: Benjamin Griese <der.darude@gmail.com>
Subject: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 14:00:06 +0200
Message-ID: <AANLkTik1j_9=E2oUq-VUWVHhL4ed8+Jj1uVrDr+a4c7g@mail.gmail.com>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
	<AANLkTinGvkLSNq3xiOA5R777k54wbjfgDRKjXwJx0_fW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinGvkLSNq3xiOA5R777k54wbjfgDRKjXwJx0_fW@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

You may take a look at this article
this isn't actually a explanation of why snapshots or subvolumes are
used, but maybe you can read the importance of the difference from the
context:
http://www.h-online.com/open/features/Snapshots-and-subvolumes-747029.h=
tml

On Thu, Oct 7, 2010 at 13:39, Francis Galiegue <fgaliegue@gmail.com> wr=
ote:
>
> I have difficulties grabbing these two concepts.
>
> As far as I can tell, a snapshot is an instant, synchronized,
> photography of the filesystem at a given point in time; a subvolume i=
s
> a "subroot" to a btrfs filesystem.
>
> While I fully understand (and use) the purpose of snapshots, I don't
> quite fathom the use case for subvolumes, apart from btrfs-convert...
> Why has btrfs grown such a feature in the first place? Can someone
> give me a use case for them?
>
> --
> Francis Galiegue, fgaliegue@gmail.com
> "It seems obvious [...] that at least some 'business intelligence'
> tools invest so much intelligence on the business side that they have
> nothing left for generating SQL queries" (St=E9phane Faroult, in "The
> Art of SQL", ISBN 0-596-00894-5)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
To be or not to be -- Shakespeare | To do is to be -- Nietzsche | To
be is to do -- Sartre | Do be do be do -- Sinatra




--
To be or not to be -- Shakespeare | To do is to be -- Nietzsche | To
be is to do -- Sartre | Do be do be do -- Sinatra
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
