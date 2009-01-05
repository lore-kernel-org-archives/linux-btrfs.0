From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] __must_check btrfs_alloc_path()
Date: Mon, 05 Jan 2009 10:34:13 -0500
Message-ID: <1231169653.4290.71.camel@think.oraclecorp.com>
References: <20081229220204.65d99bb1@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081229220204.65d99bb1@diego-desktop>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-12-29 at 22:02 +0100, Diego Calleja wrote:
> IMHO it's a good thing to add __must_check in new code where it has sense.
> 
> 

I don't think we'll pass this one yet ;)  But you're right that it is a
good idea to start adding it to other functions.

-chris


