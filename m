From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: btrfs: change/remove typedef
Date: Tue, 13 Jan 2009 16:08:59 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901131608460.28645@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901131559420.27565@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0901131559420.27565@fbirervta.pbzchgretzou.qr>
List-ID: <linux-btrfs.vger.kernel.org>


On Tuesday 2009-01-13 16:03, Jan Engelhardt wrote:
>btrfs: change/remove typedef
>
>Change one typedef to a regular enum, and remove an unused one.
>---
> fs/btrfs/ctree.h |   10 ++--------
> fs/btrfs/x       |    1 +

Short of that second file which stgit decided to add.
