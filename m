Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:59145 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3GCKL6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 06:11:58 -0400
Message-ID: <51D3F8EC.4030805@friendlyvirus.org>
Date: Wed, 03 Jul 2013 11:11:56 +0100
From: =?UTF-8?B?TWlndWVsIE5lZ3LDo28=?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send /receive : having problems sending a snapshot back
 to the original partition
References: <1372612472.13762.18.camel@miguel-MacBookPro>  <51D1A529.4040109@giantdisaster.de> <1372758978.7295.17.camel@miguel-MacBookPro> <51D2C1FD.5030405@giantdisaster.de>
In-Reply-To: <51D2C1FD.5030405@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Em 02-07-2013 13:05, Stefan Behrens escreveu:
> The reason why you are not able to send an incremental snapshot back
> (as you tried it in your previous mail) is that the implementation
> cannot handle it. The receive side gets a parent_uuid (in case of
> incremental transfers using the "-p" option), this parent_uuid is
> matched to the fields received_uuid of the subvolumes in the receive
> filesystem. If no match is found, the receive fails. And that is what
> happens.
>
> If you look at the following script, you can see the expected
> parent_uuid in the line before the "ERROR: could not find parent
> subvolume". And when you look at the output of "btrfs subv list ...
> /mnt/a", you notice that no subvolume at all has the field ruuid
> (which stands for received_uuid) set to any valid value. Therefore it
> doesn't match, therefore it fails.
>
> This logic could be changed, but that's how it is today.

Hi Stefan,

Thank you for the detailed explanation, I guess I understand it better 
now. I guess for the time being I have to use rsync to get the data back 
or transfer the whole subvolume back.

thanks,
-- 
Miguel Negrão
http://www.friendlyvirus.org/miguelnegrao
