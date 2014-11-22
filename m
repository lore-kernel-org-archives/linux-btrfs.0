Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:49080 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbaKVWvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 17:51:00 -0500
Message-ID: <54711351.1040208@pobox.com>
Date: Sat, 22 Nov 2014 14:50:57 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Volume/subvolume UUID uniqueness, was: BTRFS messes up snapshot
 LV with origin
References: <CAJCQCtRPa9fBmvBRt+RLbGy8iSUKq1_=2oZuioTKSaWAieBihQ@mail.gmail.com>
In-Reply-To: <CAJCQCtRPa9fBmvBRt+RLbGy8iSUKq1_=2oZuioTKSaWAieBihQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/22/2014 11:52 AM, Chris Murphy wrote:
> I don't know how to fix this but I've convinced myself there's at
> least a small problem. And not just with LVM snapshots as in the
> originating thread.

Yes.

You also run into this problem if you use multipath hardware but haven't 
configured multipath support to be transparent.

In any system, when you mix layers of abstraction you get problems.

LVM snapshots make "the same disk blocks" appear in multiple places but 
don't actually present "the same disk blocks" since writes to "those 
blocks" will cause COW divergence.

This violates the Universally Unique constraint of the UUID promise.

None of these are problems with the respective systems working at their 
respective jobs, they are inherent problems with the fact that a servant 
can not serve two masters.

As far as the parentage trees of subvolumes... I've been trying to get 
_anybody_ on here to recognize the problems already inherent in that 
system as implemented. Take a couple snapshots of a subvolume, and then 
send those subvolumes to another file system with send/receive, and then 
do "btrfs subvolume list -u -q" on the two filesystems and tell me that 
mess makes sense. Or try to recreate a subvolume from its snapshot in a 
way that doesn't shatter the relationships in your backup scheme. (I'm 
researching for a couple patches but I'm not expecting a warm reception 
given the silence to date).

So yea, UUID plus copy plus mirror plus snapshot equals a trip to caveat 
city.

