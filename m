From: Chris Mason <chris.mason@oracle.com>
Subject: Re: CRFS?
Date: Wed, 16 Feb 2011 08:52:00 -0500
Message-ID: <1297864176-sup-9579@think>
References: <c70f093c45470c7261e64b3570713d07.squirrel@webmail.jots.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <c70f093c45470c7261e64b3570713d07.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Ken D'Ambrosio's message of 2011-02-15 12:35:47 -0500:
> Hey, all -- crfs (a network protocol that, I think, rides on top of btrfs)
> seemed like something kind of cool, but the Oracle page was last updated
> in '08.  Is it truly dead, or just back-burnered?

Unfortunately it's heavily back-burnered.  Zach Brown was leading crfs
and he got lured away by some evil startup (careful kids, those startup
people are tricky).

The best parts of crfs are the key range transfer stuff, and I hope to
use a mixture of the crfs code and ideas for the remote syncing tool.

-chris
