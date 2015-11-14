Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:55915 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750809AbbKNLRi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 06:17:38 -0500
Reply-To: kreijack@inwind.it
Subject: Re: Using Btrfs on single drives
References: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
To: audio muze <audiomuze@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <56471661.6020101@libero.it>
Date: Sat, 14 Nov 2015 12:09:21 +0100
MIME-Version: 1.0
In-Reply-To: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-14 11:43, audio muze wrote:
> I can turn checksumming
> off given it's of no utility where a Btrfs volume is comprised of a
> single device only?

The checksums are used to detect a data corruption; in case of a btrfs-raid, the checksums are used *also* to pick the good copy.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
