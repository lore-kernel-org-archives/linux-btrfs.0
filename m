Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab3GCLoy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 07:44:54 -0400
Date: Wed, 3 Jul 2013 13:44:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix segmentation fault
Message-ID: <20130703114450.GP18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51c53889000d9fe000004a0d00004a0ea000000e0f48@amlmta037.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51c53889000d9fe000004a0d00004a0ea000000e0f48@amlmta037.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 22, 2013 at 02:39:21PM +0900, Kusanagi Kouichi wrote:
> 'btrfs subvolume delete' crashes with segv if it runs in a detached mount.

One does not even need to do the lazy unmount. If the there are 2
processes attempting to delete the same snapshot and one deletes the
snapshot directory entry between lines 216 and 227,

215         res = test_issubvolume(path);
216         if(res<0){
217                 fprintf(stderr, "ERROR: error accessing '%s'\n", path);
218                 ret = 12;
219                 goto out;
220         }
221         if(!res){
222                 fprintf(stderr, "ERROR: '%s' is not a subvolume\n", path);
223                 ret = 13;
224                 goto out;
225         }
226
227         cpath = realpath(path, 0);

the segfault occurs as well.

david
