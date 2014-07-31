Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38208 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaGaMUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 08:20:38 -0400
Date: Thu, 31 Jul 2014 07:35:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Work Queue for btrfs compression writes
Message-ID: <20140731113503.GC17375@thunk.org>
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
 <20140730093821.GJ31950@carfax.org.uk>
 <20140730141329.GC20353@thunk.org>
 <53D90309.9070909@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D90309.9070909@hurleysoftware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30, 2014 at 10:36:57AM -0400, Peter Hurley wrote:
> 
> Where is that git tree? I've been planning to set up a unit test and
> regression suite for tty/serial, and wouldn't mind cribbing the
> infrastructure from someone's existing work.

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/
