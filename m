From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: Q: list  btrfs snapshots/subvolumes
Date: Mon, 07 Dec 2009 13:48:54 +0900
Message-ID: <4B1C8936.9080701@jp.fujitsu.com>
References: <200912061637.50131@fortytwo.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: avbidder@fortytwo.ch
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912061637.50131@fortytwo.ch>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> Some questions:
>  * how do I list available snapshots/subvolumes?

As for this question, we will soon be able to list available
snapshots/subvolumes with btrfsctl utility.
But for now, we should count number of BTRFS_ROOT_ITEMs with
btrfs-debug-tree or so.

Regards,
taruisi

