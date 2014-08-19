Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbaHSPHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:07:22 -0400
Date: Tue, 19 Aug 2014 17:07:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Eric Sandeen <esandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3 v4] btrfs-progs: random fixes of btrfs-filesystem
 documentation
Message-ID: <20140819150720.GW1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53E888C3.70807@jp.fujitsu.com>
 <53E8F7F0.3060300@redhat.com>
 <53E95703.9050705@jp.fujitsu.com>
 <6DC8BDFA-32FF-4EB4-87D4-AB09F7A5A9FE@redhat.com>
 <53E9C165.6060500@jp.fujitsu.com>
 <53E9C62A.9020105@jp.fujitsu.com>
 <53E9CAE9.5080601@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E9CAE9.5080601@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 12, 2014 at 05:06:01PM +0900, Satoru Takeuchi wrote:
> +By default, the show command scans all devices found in /proc/partitions.

The default scanning method is blkid, /proc/partitions used to be the
default before that. Scanning /proc/partitions is not done through the
'show' command, only during open_ctree afaics.
