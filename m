Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:47654 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753271AbcIQSpX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 14:45:23 -0400
Date: Sat, 17 Sep 2016 20:45:10 +0200
From: David Sterba <dave@jikos.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Alex Elsayed <eternaleye@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160917184510.GD933@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
 <nrg4mh$bkn$1@blaine.gmane.org>
 <20160917043829.GC21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160917043829.GC21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 17, 2016 at 12:38:30AM -0400, Zygo Blaxell wrote:
> There's also a nasty problem with the extent tree--there's only one per
> filesystem, it's shared between all subvols and block groups, and every
> extent in that tree has back references to the (possibly encrypted) subvol
> trees.  I'll leave that problem as an exercise for other readers.  ;)

A design point that I'm not mentioning for the first time: there would
be per-subvolume group extent trees, ie. a set of subvolumes with
attached extent tree where similar to what we have now. So, encrypted
and unencrypted extent metadata will never be mixed.
(the crypto key questions are not addressed here)

This hasn't been implemented but I'm making sure this will be possible
when somebody mentions changes to the extent tree or blockgroup reworks
(to actually solve other problems).
