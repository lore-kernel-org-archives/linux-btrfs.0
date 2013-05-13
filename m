Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab3EMPTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:19:35 -0400
Date: Mon, 13 May 2013 17:19:33 +0200
From: David Sterba <dsterba@suse.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: mfasheh@suse.de, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/0] libbtrfs: Set SONAME to "libbtrfs.so.0" (instead of
 "libbtrfs.so")
Message-ID: <20130513151933.GO16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1368372824-15700-1-git-send-email-rjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1368372824-15700-1-git-send-email-rjones@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 12, 2013 at 04:33:43PM +0100, Richard W.M. Jones wrote:
> In the original version of "btrfs-progs: libify some parts of
> btrfs-progs" by Mark Fasheh, the soname field of the internal libbtrfs
> library was set to "libbtrfs.so.1".  This doesn't match the filename
> of the library (libbtrfs.so.0.1) which is unusual.

I've reworked the lib versions after I got warnings from post-rpm-build
checks. The missing .0 in soname is a bug , thanks for the fix.


david
