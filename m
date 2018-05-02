Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:42709 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751610AbeEBVzA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 17:55:00 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 - 6 parity raid
To: waxhead@dirtcellar.net, Andrei Borzenkov <arvidjaar@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
 <52465207-6c06-ef4b-b212-94b2199811a0@dirtcellar.net>
 <06986e21-28cc-a58e-b16c-129d9f5a845d@gmail.com>
 <666fce23-1edc-ea98-b11c-2068f95aa3e9@dirtcellar.net>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <f3eb795b-63cc-31a1-42f5-bbe94aff07e3@inwind.it>
Date: Wed, 2 May 2018 23:54:56 +0200
MIME-Version: 1.0
In-Reply-To: <666fce23-1edc-ea98-b11c-2068f95aa3e9@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/2018 11:20 PM, waxhead wrote:
> 
> 
[...]
> 
> Ok, before attempting and answer I have to admit that I do not know enough about how RAID56 is laid out on disk in BTRFS terms. Is data checksummed pr. stripe or pr. disk? Is parity calculated on the data only or is it calculated on the data+checksum ?!
> 

Data is checksummed per block. The parity is invisible to the checksum. The parity are allocated in an "address space" parallel to the data "address space" exposed by the BG.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
