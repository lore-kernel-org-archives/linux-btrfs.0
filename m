From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Btrfs balance
Date: 20 Jan 2011 14:40:00 +0100
Message-ID: <BeD$lESD1uB@helmut.hullen.de>
References: <4D38338B.3090903@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D38338B.3090903@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Andreas,

Du meintest am 20.01.11:

> Maybe it is a very stupid question but I want to ask it anyway. In
> general, 'btrfs filesystem balance' takes very long to finish and
> produces lots of IO. So what are the classical usage scenarios, when
> it is (really) worth doing a balance?

Here (Kernel 2.6.37, btrfs git Nov. 2010): balancing two disks/ 
partitions with 2 and 1.5 TByte needs about 24 hours (CPU 1.5 GHz).

What do you mean with "lots of IO"? the messages in "/var/log/messages"  
and "/var/log/warn"?

Viele Gruesse!
Helmut
