From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 12:54:09 -0400
Message-ID: <200804161254.09414.chris.mason@oracle.com>
References: <200804161134.19237.chris.mason@oracle.com> <87k5ixixp4.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87k5ixixp4.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 16 April 2008, Andi Kleen wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> > The async work queues include code to checksum data pages without the FS
> > mutex
>
> Are they able to distribute work to other cores?

Yes, it just uses a workqueue.  The current implemention is pretty simple, it 
surely could be more effective at spreading the work around.

I'm testing a variant that only tosses over to the async queue for pdflush, 
inline reclaim should stay inline.

-chris
