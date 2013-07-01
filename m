Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:44004 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3GAPuF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 11:50:05 -0400
Message-ID: <51D1A529.4040109@giantdisaster.de>
Date: Mon, 01 Jul 2013 17:50:01 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: =?UTF-8?B?TWlndWVsIE5lZ3LDo28=?=
	<miguel.negrao-lists@friendlyvirus.org>
CC: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send /receive : having problems sending a snapshot back
 to the original partition
References: <1372612472.13762.18.camel@miguel-MacBookPro>
In-Reply-To: <1372612472.13762.18.camel@miguel-MacBookPro>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 30 Jun 2013 18:14:32 +0100, Miguel Negrão wrote:
[...]
> Now I was testing retrieving a snapshot back from the backup disk to the
> original partition:
> 
> If I do 
> 
> btrfs subvolume delete @-backupOld
> 
> and then do
> 
> btrfs send
> -p /media/miguel/huge/backups/@/@-backupNew /media/miguel/huge/backups/@/@-backupOld | pv | btrfs receive/mnt/backups
> 
> I get an error: 
> 
> ERROR: could not find parent subvolume
> 
> Sending via files instead of pipes I can see the error is in btrfs
> receive, the btrfs send completes without errors.
> 
> Is it what I'm trying to do not possible ? I'm I using the wrong
> syntax ? It would be really handy to be able to do this, to make it easy
> to go to an old snapshot without having to transfer it in it's full
> size, instead transferring just the diff.

What you are trying to do is not possible, it is not supported.

Btrfs send/receive can be used to create backups. The use case to
restore from backups is not addressed.

