From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs balance
Date: Thu, 20 Jan 2011 16:31:20 -0500
Message-ID: <1295558587-sup-5042@think>
References: <4D38338B.3090903@gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D38338B.3090903@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andreas Philipp's message of 2011-01-20 08:07:23 -0500:
> 
> Hi,
> 
> Maybe it is a very stupid question but I want to ask it anyway. In
> general, 'btrfs filesystem balance' takes very long to finish and
> produces lots of IO. So what are the classical usage scenarios, when
> it is (really) worth doing a balance?

The idea behind the balance is to spread the used space across all your
drives evenly.  So you would usually run it after adding a new drive.

It's also useful if your disk has a lot of space allocated to either
data or metadata and you want to return to a more reasonable default.
Josef has a patch to do this more dynamically that we're fixing up
(hopefully for 2.6.38-rc2).

In general, it isn't something that you want to do very often.

-chris
