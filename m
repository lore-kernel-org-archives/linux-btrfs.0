From: cwillu <cwillu@cwillu.com>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Tue, 22 Mar 2011 18:06:29 -0600
Message-ID: <AANLkTin1++vPq904tkPOAf3ZxwWTZaQYL+=WJHetEr9h@mail.gmail.com>
References: <chaz20110321162450.GB918@seebyte.com>
	<chaz20110322092259.GA4861@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110322092259.GA4861@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I can mount it back, but not if I reload the btrfs module, in which case I get:
>
> [ 1961.328280] Btrfs loaded
> [ 1961.328695] device fsid df4e5454eb7b1c23-7a68fc421060b18b devid 1 transid 118 /dev/loop0
> [ 1961.329007] btrfs: failed to read the system array on loop0
> [ 1961.340084] btrfs: open_ctree failed

Did you rescan all the loop devices (btrfs dev scan /dev/loop*) after
reloading the module, before trying to mount again?
