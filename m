From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 14:28:22 -0400
Message-ID: <200804161428.23111.chris.mason@oracle.com>
References: <200804161134.19237.chris.mason@oracle.com> <20080416181438.GM12774@kernel.dk> <48064469.2090208@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48064469.2090208@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 16 April 2008, Andi Kleen wrote:
> > There have been various implementations of queue_work_on() posted
> > through the years, I've had one version that I've used off and on for a
> > long time:
>
> queue_work_on is the wrong interface I think. You rather
> want a pool of non pinned threads that are then load balanced by the
> scheduler (who knows best what cpus have cycles available)

Fair enough, I'll tune things a bit.

-chris
