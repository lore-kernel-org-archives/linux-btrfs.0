From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Remove code duplication in comp_keys
Date: Fri, 24 Jul 2009 11:10:42 -0400
Message-ID: <20090724151042.GE16192@think>
References: <200907240054.53667.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200907240054.53667.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2009 at 12:54:53AM +0200, Diego Calleja wrote:
> comp_keys is duplicating what is done in btrfs_comp_cpu_keys, so just
> call it.

Ok, looks like gcc is doing the right thing and inlining properly so
I've queued this one up.

-chris
