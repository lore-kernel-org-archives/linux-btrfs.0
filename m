Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40501 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab3BZTOl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 14:14:41 -0500
Received: by mail-wi0-f175.google.com with SMTP id l13so5315051wie.14
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 11:14:40 -0800 (PST)
Message-ID: <512D09ED.9000103@gmail.com>
Date: Tue, 26 Feb 2013 20:15:57 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: kreijack@inwind.it, Hendrik Friedel <hendrik@friedels.name>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Needed change in Wiki
References: <512A2019.6000201@friedels.name> <512A4CD6.7050804@gmail.com> <512AEAF3.1080100@oracle.com>
In-Reply-To: <512AEAF3.1080100@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On 02/25/2013 05:39 AM, Anand Jain wrote:
> 
> 
> You may need to update the minimum version of
> libblkid-dev that is required. Since.
> 
> latest btrfs-progs needs
>   blkid_probe_get_wholedisk_devno()
> from the libblkid-dev.
> found libblkid-dev version 2.17.2 does not work,
> and 2.22 works. Not sure which version introduced the
> function required here.

Which error is returned when you try to compile with the 2.17.2 ?


> 
> 
> HTH
> Anand




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
