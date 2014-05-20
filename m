Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaETQri (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 12:47:38 -0400
Date: Tue, 20 May 2014 18:47:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What do the "wait_current_trans" messages mean I see on my
 raspberry pi?
Message-ID: <20140520164736.GN31608@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAFvQSYTwfgpd3-ndBzy8nfmCJeewN2-+zWpDmSmZXbYoYhmi5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFvQSYTwfgpd3-ndBzy8nfmCJeewN2-+zWpDmSmZXbYoYhmi5A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 18, 2014 at 09:48:17PM +0200, Clemens Eisserer wrote:
> Over the weekend I tried to copy one external usb drive (on ext4) to
> another one formatted with btrfs.
> Now I came back, and 48h later only ~300GB were copied and I found
> messages like the following on syslog:

That's about 1 MB/sec on average, I'd expect more.

> Any idea what they mean? Are they related to the slow speed I observed?

Yes, I believe so.
