Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60087 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab2ITL3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 07:29:09 -0400
Date: Thu, 20 Sep 2012 13:28:55 +0200
From: David Sterba <dave@jikos.cz>
To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Cc: seto.hidetoshi@jp.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: R: [PATCH 2/2] Btrfs-progs: add mount-option command
Message-ID: <20120920112855.GI17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5057CDA7.3090201@jp.fujitsu.com>
 <26356142.2062531347962627486.JavaMail.root@wmail62>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <26356142.2062531347962627486.JavaMail.root@wmail62>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 12:03:47PM +0200, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Why it was not provided a way to clear a *single* flag ? To me it seems a bit 
> too long to clear all the flag (btrfs mount-option clear) and then set the 
> right one.
> 
> As user interface I suggest something like chmod:
> 
>    btrfs mount-option set +ssd,skip_balance -nodatacow /dev/sdX
> 
> or
> 
>    btrfs mount-option set =ssd,skip_balance,nodatacow /dev/sdX

I agree with the +/-/= syntax, it's quite intuitive and already seen
(chattr).

I'd drop the 'set' command here, with some options specified it's
implied.

Without any it's 'get'

  btrfs mount-option /dev/...

And the 'clear' subcommand could be also dropped with this syntax

  btrfs mount-option = /dev/...

:)


BTW, this modifies the defaults only for the unmounted filesystem, but
the same should be possible for a mounted one in the future.

david
