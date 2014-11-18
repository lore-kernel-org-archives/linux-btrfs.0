Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i2.italiaonline.it ([212.48.25.206]:36853 "EHLO
	smtp-34.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753829AbaKRUB1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 15:01:27 -0500
Message-ID: <546BA5B7.8040607@inwind.it>
Date: Tue, 18 Nov 2014 21:01:59 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, unlisted-recipients:;
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, bug-grub@gnu.org
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <988DFC86-0C84-4735-AF3D-02CD394D5FEA@colorremedies.com>
In-Reply-To: <988DFC86-0C84-4735-AF3D-02CD394D5FEA@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-18 07:21, Chris Murphy wrote:
> Ergo just because I’ve snapshot my root does not mean grub-mkconfig
> should be creating boot entries for it.

I find this an useful feature: a snapshot of / is done to rollback
some changes, so why don't let grub to start (the kernel) from ?

Anyway I find grub-mkconfig quite useful for a "standard" user.
For more advance uses cases editing by hand grub.cfg may be possible.

BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

