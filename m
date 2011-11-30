From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Resize command syntax wrong?
Date: 30 Nov 2011 20:43:00 +0100
Message-ID: <ByrP+cZy1uB@helmut.hullen.de>
References: <20111201011547.66633b20@natsu>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111201011547.66633b20@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Roman,

Du meintest am 01.12.11:

> What if I need to replace an individual device with a smaller or a
> larger one?

1) add the new device
2) balance (may be it's not necessary)
3) run "remove" for the "individual" device
4) remove it
5) balance

Viele Gruesse!
Helmut
