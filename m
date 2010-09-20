From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Question of stability
Date: Mon, 20 Sep 2010 07:30:57 -0400
Message-ID: <20100920113057.GC27633@think>
References: <7280394.123.1284845879623.JavaMail.root@zimbra>
 <4C96B682.5080900@csamuel.org>
 <i77ero$lja$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i77ero$lja$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 20, 2010 at 11:00:08AM +0000, Lubos Kolouch wrote:
> No, not stable!
> 
> Again, after powerloss, I have *two* damaged btrfs filesystems.

Please tell me more about your system.  I do extensive power fail
testing here without problems, and corruptions after powerloss are very
often caused by the actual hardware.

So, what kind of drives do you have, do they have writeback caching on,
and what are you layering on top of the drive between btrfs and the
kernel?

-chris

> 
> /home and also the backup volume, as the backup was running :(
> 
> Both show
> parent transid verify failed on .... wanted ..... found ....
> 
> and the volumes cannot be mounted.
> 
> So until there is a way to somehow recover from this type of failures,
> speaking about stability is a joke
> 
> Lubos Kolouch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
