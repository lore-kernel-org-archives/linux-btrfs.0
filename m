From: Josef Bacik <josef@redhat.com>
Subject: Re: TRIM + RAID Support?
Date: Tue, 4 May 2010 11:58:35 -0400
Message-ID: <20100504155835.GC2573@localhost.localdomain>
References: <20100504.085317.25251.0@webmail21.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Justin <yoosty69@netzero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100504.085317.25251.0@webmail21.vgs.untd.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 04, 2010 at 03:53:17PM +0000, Justin wrote:
> As I understand it, hardware RAID controllers do not pass the TRIM command to it's disks; btrfs deals with the disk directly, supports TRIM, and supports RAID. I have seen no explicit mention of being able to combine RAID and TRIM support using btrfs with independent disks so I'm asking: When btrfs is in RAID mode, does it still pass the TRIM commands to the SSD?
> 

If TRIM is enabled then yes it should.  Thanks,

Josef
