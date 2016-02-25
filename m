Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:41569 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbcBYVfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 16:35:45 -0500
Reply-To: kreijack@inwind.it
Subject: Re: btrfs raid1 filesystem on sdcard corrupted
References: <nandur$4li$1@ger.gmane.org> <56CF3D78.90705@hsr.ch>
 <56CF4301.9090601@bouton.name> <nank09$nad$1@ger.gmane.org>
To: Hegner Robert <rhegner@hsr.ch>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56CF73AF.70301@inwind.it>
Date: Thu, 25 Feb 2016 22:35:43 +0100
MIME-Version: 1.0
In-Reply-To: <nank09$nad$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Robert,

On 2016-02-25 20:18, Hegner Robert wrote:
[...]
> So, in your experience 1) Which are the SDcards we can trust in?
> (brand? model?)

For this kind of use you should look to an "industrial grade" SD cards. But these are quite expensive (we are talking about 50€ for 4GB....). Our supplier suggested us the ATP sd cards [*].

I tested a NON industrial grade sdcard with simulated power failure; my test showed that this card fails quite early (about hundreds of cycles).
I have to point out that "industrial grade" is a generic definition. Unfortunately I was unable to find a more detailed spec.

> 2) What would be a better way (with or without the use of btrfs) to
> make an embedded system more robust against power failures and
> flash-memory-wearing?

If it is possible to avoid don't write on the storage Don't log. Leave the filesystem "read only" and switch to read/write only when you have to write; after the write re-switch the filesystem RO. This cannot prevent the damage of the card, but could reduce the likelihood of the damage.

I never tested the internal flash of these boards. May be that this flash is more reliable...

BR
G.Baroncelli

[*] "http://www.digikey.com/product-search/en?mpart=AF8GUDI-OEM&vendor=1282"

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
