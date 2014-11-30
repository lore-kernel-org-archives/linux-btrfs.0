Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:51313 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaK3XF0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 18:05:26 -0500
Received: by mail-yk0-f180.google.com with SMTP id 9so4276852ykp.11
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 15:05:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417388388.4707.34.camel@scientia.net>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<20141125163905.GJ26471@twin.jikos.cz>
	<m5dash$58v$1@ger.gmane.org>
	<1417388388.4707.34.camel@scientia.net>
Date: Sun, 30 Nov 2014 23:05:25 +0000
Message-ID: <CANBHLUiJNZ_hH-tKp=985hNzi9ZjjB-XrxiTRxneLk6cMB3b8w@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: Dimitri John Ledkov <xnox@debian.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 November 2014 at 22:59, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
>>Agree with others about -C 256...-C sha256 is only three
>>letters more ;)
>
> Ideally, sha2-256 would be used, since there will be (are) other
> versions of sha which have 256 bits size.
>

Nope, we should use standard names. SHA-2 256 was the first SHA algo
to use 256 bits, thus it's commonly referred to as sha256 across the
board in multiple pieces of software.
SHA-3 family of hashes started to have the same length and thus will
be known as sha3-256 etc.

Shorthand variant names in this table here
http://en.wikipedia.org/wiki/SHA-1#Comparison_of_SHA_functions appear
to me how SHA hashes are currently referred as.

-- 
Regards,

Dimitri.
