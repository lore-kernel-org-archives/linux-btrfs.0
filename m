From: Josef Bacik <jbacik@redhat.com>
Subject: Re: "possible circular locking dependency detected"
Date: Thu, 20 Nov 2008 11:12:08 -0500
Message-ID: <20081120161208.GA3013@unused.rdu.redhat.com>
References: <20081120170015.1a5177a0@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081120170015.1a5177a0@diego-desktop>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 20, 2008 at 05:00:15PM +0100, Diego Calleja wrote:
> I got this lockdep warning while running tiobench on a clean btrfs filesystem
> with the latest code available (commit 2c41b36dd2f9fb5dee150f20c84895496e0642f2)
> But it was a purely read-only workload: only root could write to the
> filesystem and I was running tiobench as an user, which was spitting
> "denied permission" errors.
> 
>

Yeah I sent a patch to the list a few weeks ago to fix this, it should get
picked up at some point.

Josef
