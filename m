Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726943AbeGWRw5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 13:52:57 -0400
Date: Mon, 23 Jul 2018 18:50:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Regression with crc32c selection?
Message-ID: <20180723165040.GP26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ca274e95-538c-0c0e-e184-3542b4524afe@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <ca274e95-538c-0c0e-e184-3542b4524afe@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2018 at 04:13:26PM +0200, Holger Hoffstätte wrote:
> While backporting a bunch of fixes to my own 4.16.x tree
> (4.17 had a few too many bugs for my taste) I also ended up merging:

Curious, bugs in btrfs or the whole 4.17 kernel? And if bugs, real
breakage or backported fixes?
