Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbaKNNu3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 08:50:29 -0500
Date: Fri, 14 Nov 2014 14:50:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't take the chunk_mutex/dev_list mutex in
 statfs V2
Message-ID: <20141114135027.GF30713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1415023010-12988-1-git-send-email-jbacik@fb.com>
 <5458A9F1.1070901@cn.fujitsu.com>
 <545B8725.40909@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <545B8725.40909@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 06, 2014 at 09:35:17AM -0500, Josef Bacik wrote:
> Yeah df if you change alloc_start in the middle of it is going to be 
> slightly racey, which is fine since I'm going to kill alloc_start soon 
> anyway.

Go on, seems that there was never a real usecase for that. According to
the original post, it was to test resizer:

http://thread.gmane.org/gmane.linux.file-systems/20355
"mount -o alloc_start=num forces allocation hints to start at least num
bytes into the disk.  This was introduced to test the resizer."

I'll probably remove it from mkfs as well.
