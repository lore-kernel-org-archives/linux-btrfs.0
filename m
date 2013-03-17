Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51445 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab3CQW5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Mar 2013 18:57:10 -0400
Received: by mail-ob0-f174.google.com with SMTP id 16so4777746obc.5
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2013 15:57:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMiUzp9m5kFZmNdc793VhSodAM73NupCE8Ggyg2VZ63p-GTgaA@mail.gmail.com>
References: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
	<CAB9VWqCjoFGdZVx0Uup2zmvuqS2PHiQO=h2EKawH-dZiGqvfDQ@mail.gmail.com>
	<20121218013111.GB22912@shiny>
	<CAMiUzp9m5kFZmNdc793VhSodAM73NupCE8Ggyg2VZ63p-GTgaA@mail.gmail.com>
Date: Sun, 17 Mar 2013 23:57:09 +0100
Message-ID: <CAMiUzp9Xd7-pCVooqfCSbdBjAvShRQKsPQujF7vEb-v3=y2i_g@mail.gmail.com>
Subject: Re: Online Deduplication for Btrfs (Master's thesis)
From: =?UTF-8?B?TWFydGluIEvFmcOtxb5law==?= <martin.krizek@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Alexander Block <ablock84@gmail.com>,
        =?UTF-8?B?TWFydGluIEvFmcOtxb5law==?= <martin.krizek@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "lczerner@redhat.com" <lczerner@redhat.com>, jbacik@fusionio.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am looking for a place (source code wise) where the actual
online/immediate dedup would happen:
-- splitting an extent about to be written into new extents that are
unique (that would be actually written) and into blocks of the
original extent that would be thrown away (duplicates) and
file_extent_item pointing to portion of existing extent created
instead.

Could anyone please give me some pointers on that place and/or
functions that could be used for that? Would delalloc time would be
appropriate?

Thanks!
Martin
