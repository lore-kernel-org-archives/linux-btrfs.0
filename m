Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaH2SzL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 14:55:11 -0400
Date: Fri, 29 Aug 2014 11:55:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix crash while a ranged msync() is ongoing
Message-ID: <20140829185506.GA32185@infradead.org>
References: <1409315868-29734-1-git-send-email-fdmanana@suse.com>
 <20140829145130.GA14038@infradead.org>
 <CAL3q7H7Qo0TiSUwZX+GbnsEpwEea6eFQJ_KPyM_O2PkTjKmVjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7Qo0TiSUwZX+GbnsEpwEea6eFQJ_KPyM_O2PkTjKmVjA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 29, 2014 at 07:52:33PM +0100, Filipe David Manana wrote:
> Point taken Christoph, this isn't specific to msync nor impossible to
> happen before 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8.
> I'll update the commit log to reflect that.
> 
> Thanks for looking.

Btw, if you have an easy enough reproducer it would be good to wire it
up for xfstests.
