From: Chester <somethingsome2000@gmail.com>
Subject: Re: combining 2 RAID 10 pools to one filesystem
Date: Wed, 16 Feb 2011 21:58:00 +0000
Message-ID: <AANLkTi=VjpOhkEr6GFkohpsFgUSe4GR0txGB9N8WxEhJ@mail.gmail.com>
References: <4D5C38B1.70202@torus.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Gal Buki <buki@torus.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D5C38B1.70202@torus.ch>
List-ID: <linux-btrfs.vger.kernel.org>

I'm sure this is possible if you use /dev/md's, but doesn't this
basically make the redundancy of the raid10 useless?

On Wed, Feb 16, 2011 at 8:50 PM, Gal Buki <buki@torus.ch> wrote:
> Hi
>
> I have RAID 10 using 4 times 500GB drives (1TB of storage).
> Is it possible to create another RAID 10 with 4 times 250GB drives (5=
00GB of
> storage) and then combine those two RAIDs to one file system so that =
I would
> be able to get 1.5TB?
>
> If I create one RAID 10 with all 8 drives I would only be able to use=
 8
> times 250GB /2 =3D 1TB, right?
>
> Thanks,
> Gal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
