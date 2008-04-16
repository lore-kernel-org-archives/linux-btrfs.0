From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 18:14:31 +0200
Message-ID: <87k5ixixp4.fsf@basil.nowhere.org>
References: <200804161134.19237.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804161134.19237.chris.mason@oracle.com> (Chris Mason's message of "Wed, 16 Apr 2008 11:34:19 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:
>
> The async work queues include code to checksum data pages without the FS mutex 

Are they able to distribute work to other cores?

-Andi
