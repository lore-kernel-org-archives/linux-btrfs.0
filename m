From: cwillu <cwillu@cwillu.com>
Subject: Re: How to see raid level?!
Date: Mon, 1 Nov 2010 04:33:30 -0600
Message-ID: <AANLkTinc0zL1hmLOD0YpHShu5Jg8eiZwZtJdcVZaG5QO@mail.gmail.com>
References: <20101101101755.GA2814@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101101101755.GA2814@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 1, 2010 at 4:17 AM, Felix Blanke <felixblanke@gmail.com> wrote:
> Hi,
>
> I saw some reports of ppl in this list who did a "btrfs fi df /path" and saw the
> raidlevel of the data, metadata etc.
>
> How? :)
>
> I'm using the git version of the btrfs progs and 2.6.36, but I don't see those
> informations.
>
> Btrfs v0.19-35-g1b444cd-dirty
>
>
> What am I doing wrong? :(

You didn't include the magic patch.  :p

Raid level reporting was broken for a while, josef sent some patches
recently that fixed it, which I saw in cmason's pull request for
2.6.37.
