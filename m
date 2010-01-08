From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: /dev/btrfs-control
Date: Fri, 8 Jan 2010 19:54:30 +0100
Message-ID: <ac3eb2511001081054t1a40aba3l41decd9063b11b9f@mail.gmail.com>
References: <4B4727F5.1080803@fs.ei.tum.de> <20100108173720.07a6de69@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Michael Niederle <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100108173720.07a6de69@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 8, 2010 at 17:37, Michael Niederle <mniederle@gmx.at> wrote:
> Some btrfs-tools make use of "/dev/btrfs-control".
>
> How should I create this node? Is this a block or a character device (I suppose
> it should be a character device), which major and minor numbers should be
> assigned?

It's a char device node:
  $ cat /sys/class/misc/btrfs-control/dev
  10:62

Kay
