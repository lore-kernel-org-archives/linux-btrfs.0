Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35192 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2I3XRe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 19:17:34 -0400
Date: Mon, 1 Oct 2012 01:17:27 +0200
From: David Sterba <dave@jikos.cz>
To: cwillu <cwillu@cwillu.com>
Cc: dave@jikos.cz, Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: btrfs subvolume delete could delete
 subvolumes
Message-ID: <20120930231726.GN14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
 <20120921152051.GU17430@twin.jikos.cz>
 <505FCC96.8030703@oracle.com>
 <20120924120232.GB14582@twin.jikos.cz>
 <CAE5mzvh7qx1m-6DhaNe5LH-JpFwUpNxtsC9VKM-deJ3GwFGn5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE5mzvh7qx1m-6DhaNe5LH-JpFwUpNxtsC9VKM-deJ3GwFGn5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 08:36:47AM -0600, cwillu wrote:
> For what it's worth, rmdir's behaviour is to continue after errors
> (i.e., "mkdir 1; mkdir 3; rmdir 1 2 3" deletes 1 and 3, and exits with
> a non-zero exit code); unless there's a good reason to do otherwise,
> matching that behaviour is probably best.

Thanks for your input. I have tried it and agree with the proposed
implementation (ie. to process all arguments and skip non-subvols).

david
