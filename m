From: cwillu <cwillu@cwillu.com>
Subject: Re: How to see raid level?!
Date: Mon, 1 Nov 2010 06:24:26 -0600
Message-ID: <AANLkTinc84hYYrVY2tp7X_EpebZMc335KoqFX3b+4KGn@mail.gmail.com>
References: <20101101101755.GA2814@scooter>
	<AANLkTinc0zL1hmLOD0YpHShu5Jg8eiZwZtJdcVZaG5QO@mail.gmail.com>
	<20101101121408.GA2837@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101101121408.GA2837@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 1, 2010 at 6:14 AM, Felix Blanke <felixblanke@gmail.com> wrote:
> Ah, the magic one :)
>
> Is that a patch for the kernel or the btrfs progs?
>
>
> If you know where to get that patch it would be nice. It isn't an important issue but it
> would be nice to see if my home really uses raid1 for data :)

Kernel patch;  c9996a22 Btrfs: fix the df ioctl to report raid types
