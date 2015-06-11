Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbbFKVL6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 17:11:58 -0400
Date: Thu, 11 Jun 2015 23:11:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What is `mkfs.btrfs -r $rootdir` supposed to be used with?
Message-ID: <20150611211156.GH6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAGnHSEkjM2LVCvHgtpL6BKu8tabnZO5pcBaJQdf=B4P10UC3OQ@mail.gmail.com>
 <20150611170901.GG6761@twin.jikos.cz>
 <CAGnHSEk630JETZuPhpuUAfpw_2J2BdQryNidBRgYcB1EXAFFLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnHSEk630JETZuPhpuUAfpw_2J2BdQryNidBRgYcB1EXAFFLg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 12, 2015 at 01:13:43AM +0800, Tom Yan wrote:
> So I assume this option is mainly used for preparation of an btrfs image?

Yes, as it's not necessary to mount the filesystem.
