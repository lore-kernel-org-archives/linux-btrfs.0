Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:52218 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbaHMLBd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 07:01:33 -0400
Received: from [82.70.68.182] (helo=www.chrestomanci.org)
	by smarthost01a.mail.zen.net.uk with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <david@chrestomanci.org>)
	id 1XHWJ8-000DL1-Uu
	for linux-btrfs@vger.kernel.org; Wed, 13 Aug 2014 11:01:31 +0000
Message-ID: <53EB4581.8050104@chrestomanci.org>
Date: Wed, 13 Aug 2014 12:01:21 +0100
From: David Pottage <david@chrestomanci.org>
MIME-Version: 1.0
To: Vimal A R <arvimal@yahoo.in>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for a feature implementation
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E9F3D6.9040502@gmail.com>
In-Reply-To: <53E9F3D6.9040502@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/08/14 12:00, Konstantinos Skarlatos wrote:
> Maybe help with Andrea Mazzoleni's New RAID library supporting up to 
> six parities? It seems to be a great feature for btrfs.
>
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31735.html

That would be very cool, but at present vanila RAID 5 or 6 does not work 
properly, so I think getting that fully working would be a better idea. 
(Unless it would make more sense to merge the whole lot into one bit of 
work where RAID 5 or 6 are just a special case of arbitrary parity level 
support).

At present, you can write RAID 5 or 6 data, but if anything goes wrong, 
btrfs cannot use the parity information to help you get your data back, 
so in general you are better off with RAID 1 or 10. Also, I don't think 
I/O done in parallel so you get no speed advantage from having multiple 
discs either.

-- 
David Pottage
