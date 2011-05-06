From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Cannot Deinstall a Debian Package
Date: 06 May 2011 15:30:00 +0200
Message-ID: <BlMEQXVD1uB@helmut.hullen.de>
References: <201105060509.31652.CACook@quantum-sci.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105060509.31652.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Cacook,

Du meintest am 06.05.11:

> I can't reboot at this point, as on this machine I started a
> 'balance' through ssh on another machine, and it's been running for
> over 12 hours.  It does not respond to ^C and I'm afraid to reboot
> with it running.

That's a behaviour which was described in this mailing lists some weeks  
ago. You have certainly studied that thread?

Balancing 4 TByte may need more than 1 day. Look every hour at the last  
lines of "dmesg".

Viele Gruesse!
Helmut
