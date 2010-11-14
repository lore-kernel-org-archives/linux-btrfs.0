From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm-crypt barrier support is effective
Date: Sun, 14 Nov 2010 22:54:38 +0100
Message-ID: <4CE05A9E.9090204@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>	<4CD6B7FA.3050005@redhat.com>	<AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>	<AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>	<20101107194547.GA12521@basil.fritz.box>	<4CD71C8B.1050604@redhat.com>	<20101107230508.GB17592@basil.fritz.box>	<20101108145809.GD29714@redhat.com>	<1289238930-sup-9765@think>	<20101114205925.GA20451@redhat.com> <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>
To: Matt <jackdachef@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/14/2010 10:49 PM, Matt wrote:
> only with the dm-crypt scaling patch I could observe the data-corruption

even with v5 I sent on Friday?

Are you sure that it is not related to some fs problem in 2.6.37-rc1?

If it works on 2.6.36 without problems, it is probably problems somewhere
else (flush/fua conversion was trivial here - DM is still doing full flush
and there are no other changes in code IMHO.)

Milan
