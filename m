Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54685 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaIQRNX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 13:13:23 -0400
Date: Wed, 17 Sep 2014 10:13:22 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: NOCOW on VM images causes extreme btrfs slowdowns, memory leaks, and deadlocks
Message-ID: <20140917171322.GB29967@merlins.org>
References: <20140908015124.GA21441@merlins.org> <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com> <20140915001836.GU8530@merlins.org> <20140915175747.GZ8530@merlins.org> <20140916235742.GG8530@merlins.org> <20140917150002.GA12223@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140917150002.GA12223@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 17, 2014 at 08:00:02AM -0700, Marc MERLIN wrote:
> kernel: 3.16.2

Grumble, I messed up the subject line.
I meant that COW on virtual disk images causes the problems described in the
previous Email.
Obviously I already know that COW on disk images wasn't ideal, but the
effects in 3.16 are still fairly severe.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
