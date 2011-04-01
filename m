From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs balancing start - and stop?
Date: 01 Apr 2011 14:12:00 +0200
Message-ID: <Bj0igski1uB@helmut.hullen.de>
References: <4D95B3AA.2090106@NewsNow.co.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D95B3AA.2090106@NewsNow.co.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Struan,

Du meintest am 01.04.11:

> 1) Is the balancing operation expected to take many hours (or days?)
> on a filesystem such as this? Or are there known issues with the
> algorithm that are yet to be addressed?

May be. Balancing about 15 GByte needed about 2 hours (or less),  
balancing about 2 TByte needed about 20 hours.

"dmesg" counts down the number of remaining "jobs".

Viele Gruesse!
Helmut
