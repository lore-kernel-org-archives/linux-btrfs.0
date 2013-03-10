Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58841 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3CJWAR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 18:00:17 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so1842042eek.8
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 15:00:16 -0700 (PDT)
Message-ID: <513D106C.4000806@gmail.com>
Date: Sun, 10 Mar 2013 23:59:56 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Harald Glatt <mail@hachre.de>
CC: Hugo Mills <hugo@carfax.org.uk>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <201303101223.56805.Martin@lichtvoll.de> <20130310213606.GE30771@carfax.org.uk> <CAFWF=amgMRcBaoTXZiFSEQnJkmayf7SPXddktbGuvN0q3qd7UA@mail.gmail.com>
In-Reply-To: <CAFWF=amgMRcBaoTXZiFSEQnJkmayf7SPXddktbGuvN0q3qd7UA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2013 10:45 PM, Harald Glatt wrote:

> I've noticed through my own tests that on a single device I can
> corrupt around 5% of the data completely before btrfs fails. Up to
> that point both filesystem as well as data integrity stays at 100%.
> However the default layout for one disk seems to be having the data
> once, the metadata DUP and the system DUP too. 

How make you the corruption ? Does btrfs return wrong data ? How is
calculated the 5% ?


> Having these 5% isn't
> mentioned anywhere... Is this a value that could maybe be manipulated
> and could it be introduced into a naming scheme like this? Also where
> do the 5% redundancy come from?

On a single device, the metadata are DUPlicated but the data have only 1
copy.

This means that if you corrupt the 1 copy of the metadata, btrfs
survives using the other copy. Instead if you corrupt the data btrfs
return an error.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
