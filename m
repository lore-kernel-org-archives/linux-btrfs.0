From: Arie Peterson <ariep@xs4all.nl>
Subject: Re: ENOSPC on file deletion with 3.1.6
Date: Tue, 03 Jan 2012 15:44:49 +0100
Message-ID: <5456797.AlAK19QpzP@a4>
References: <24549767.TiRljH7Edl@a4> <3462742.4OipIWmN91@a4> <20120103142258.GA22732@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120103142258.GA22732@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 03 January 2012 15:22:58 Sander wrote:

> Hm, not full.
> 
> > OK, I'll keep this in mind. I'm a bit anxious to reboot, because I'm
> > afraid booting will fail if the root file system cannot be written to.
> 
> But you did already reboot as you said the old kernel exposed the same
> behavior?

You are right; the full history of events was:

(- compile new kernel (3.1.6))
- boot new kernel;
- recompile gcc: problem occurs;
- solve problem by removing compilation directory;
- boot old kernel;
- recompile gcc: problem occurs for this kernel as well.

After trying to remove the problematic files for some time, I took the chance 
and rebooted. After the reboot, the file system still gave ENOSPC on any write 
operation. However, it was able to boot anyway, and now the removal of the 
problematic files went much faster and without new ENOSPC. The compilation 
directory was completely removed, and immediately afterwards, the file system 
became writeable again.

Sander, thanks for your help.


I am still curious if this a known problem, and if upgrading to a newer kernel 
might prevent it from reoccurring. (I was planning to wait for 3.2 to be 
released and included in Gentoo's repository; maybe I shouldn't wait for 
this...)


Kind regards,

Arie

