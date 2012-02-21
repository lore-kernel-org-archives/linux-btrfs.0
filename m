From: Tom Cameron <tomc603@gmail.com>
Subject: Re: Balance RAID10 with odd device count
Date: Mon, 20 Feb 2012 20:13:43 -0500
Message-ID: <CA+Huu1E2cg5a4PWtCkN4a4qou4T++VENsLjC8=TiRPJw5tzAUA@mail.gmail.com>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
	<CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
	<20120221010724.GB5350@carfax.org.uk>
Reply-To: tom@drdabbles.us
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Wes <anomaly256@gmail.com>,
	tom@drdabbles.us, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120221010724.GB5350@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2012 at 8:07 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
> =A0 However, you can remove any one drive, and your data is fine, whi=
ch
> is what btrfs's RAID-1 guarantee is. I understand that there will be
> additional features coming along Real Soon Now (possibly at the same
> time that RAID-5 and -6 are integrated) which will allow the selectio=
n
> of larger numbers of copies.
>

Is there a projected timeframe for RAID5/6? I understand it's
currently not the development focus of the BTRFS team, and most
organizations want performance over capacity making RAID10 the clear
choice. But, there are still some situations where RAID6 is better
suited (large pools of archive storage).

Also, do we know if the RAID5/6 implementation will simply break data
into two data objects and one or two parity objects, or will it work
with an arbitrary number of devices? Meaning, if I have a RAID6 pool
of 12 drives, will I get 10 data objects and two parity objects?

Thanks all for your replies!
Tom
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
