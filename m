From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: RAID[56] status
Date: Tue, 10 Nov 2009 21:05:24 +0100
Message-ID: <20091110200524.GA3881@mother.pipebreaker.pl>
References: <1249553833.568.23.camel@macbook.infradead.org> <e9c3a7c20911101151q2d85237cyecdd7d292d21552d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20911101151q2d85237cyecdd7d292d21552d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2009 at 12:51:06PM -0700, Dan Williams wrote:
> 4/ A small issue, there appears to be no way to specify different
> raid10/5/6 data layouts, maybe I missed it.  See the --layout option
> to mdadm.  It appears the only layout option is the raid level.

  Is this really important? In my all experience, mdadm was the first
place when I got asked about RAID layout. No other RAID system known
to me exposes such design decision to user. Why would user need to both=
er
with such detail?

--=20
Tomasz Torcz                        To co nierealne -- tutaj jest norma=
lne.
xmpp: zdzichubg@chrome.pl          Ziomale na =BFycie maj=B1 tu patenty=
 specjalne.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
