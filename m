Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44296 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3BZGiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 01:38:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UAEBJ-0000yb-I7
	for linux-btrfs@vger.kernel.org; Tue, 26 Feb 2013 07:38:29 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 07:38:29 +0100
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 07:38:29 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: lvm volume like support
Date: Mon, 25 Feb 2013 22:37:53 -0800
Message-ID: <kghl7u$fon$1@ger.gmane.org>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com> <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com> <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com> <20130226115704.50102196@natsu> <CAPF83mv2qVqE5HnXVr9P8JHqs4+DKjt0hWaR8UG6Kk4reyPsAw@mail.gmail.com> <FEF2721D-ABA2-4CE7-A562-6210B0946BF8@yerf-it.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remco Hosman - Yerf IT wrote:

> would be really cool if a TRIM to the loopback device would do a 'hole
> punch' on the file

There are patches on the scsi target mailing list to make this happen for 
the FILEIO backend. This has the added benefit that if you set it up via 
LIO, it appears as a full SCSI device, and can be exported via iSCSI, 
firewire, FC, USB, etc as well as being visible as a local disk.

