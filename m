From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [PATCH v5 1/8] btrfs: Balance progress monitoring
Date: 11 Apr 2011 07:34:00 +0200
Message-ID: <BjeBXGRy1uB@helmut.hullen.de>
References: <1302469571-12605-2-git-send-email-hugo@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302469571-12605-2-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 10.04.11:

> This patch introduces a basic form of progress monitoring for balance
> operations, by counting the number of block groups remaining. The
> information is exposed to userspace by an ioctl.

Just for curiosity:

If I remember correct then "btrfs device delete" shows growing and  
shrinking numbers, resp. on the remaining and on the deleting  
partition(s).

Can this patch show the remaining number of block groups too?

Viele Gruesse!
Helmut
