Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab3K0E5m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 23:57:42 -0500
Message-ID: <52957BB7.2020300@redhat.com>
Date: Tue, 26 Nov 2013 22:57:27 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs still core dumps
References: <20131120032710.GN6696@merlins.org>
In-Reply-To: <20131120032710.GN6696@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/19/13, 9:27 PM, Marc MERLIN wrote:
> Here is another way in which btrfs-tools crashes if it sees things it
> doesn't like.
> 
> Is anyone interested in those, or not really?
> 
> gandalfthegreat:/tmp# btrfs-find-root /dev/mapper/ssdcrypt 
> Check tree block failed, want=20971520, have=10422900740180685247
> Check tree block failed, want=20971520, have=10422900740180685247
> Check tree block failed, want=20971520, have=9351833364687311396
> Check tree block failed, want=20971520, have=9351833364687311396
> Check tree block failed, want=20971520, have=9351833364687311396
> read block failed check_tree_block
> Couldn't read chunk root
> Segmentation fault (core dumped)
> 
> btrfs-tools 0.19+20130705-3
> 

Can you try the 3.12 release of btrfs-progs?  Lots of stuff
fixed since 0.19 / July 2013.

Still might segfault ;) but please test upstream...

-Eric
