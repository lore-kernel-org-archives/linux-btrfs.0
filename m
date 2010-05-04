From: "Justin" <yoosty69@netzero.com>
Subject: Re: TRIM + RAID Support?
Date: Tue, 4 May 2010 16:12:10 GMT
Message-ID: <20100504.091210.25251.1@webmail21.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Awesome.

Has there been a lot of testing with RAID + TRIM setups?

---------- Original Message ----------
From: Josef Bacik <josef@redhat.com>
To: Justin <yoosty69@netzero.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: TRIM + RAID Support?
Date: Tue, 4 May 2010 11:58:35 -0400

On Tue, May 04, 2010 at 03:53:17PM +0000, Justin wrote:
> As I understand it, hardware RAID controllers do not pass the TRIM command to it's disks; btrfs deals with the disk directly, supports TRIM, and supports RAID. I have seen no explicit mention of being able to combine RAID and TRIM support using btrfs with independent disks so I'm asking: When btrfs is in RAID mode, does it still pass the TRIM commands to the SSD?
> 

If TRIM is enabled then yes it should.  Thanks,

Josef


____________________________________________________________
Penny Stock Jumping 2000%
Sign up to the #1 voted penny stock newsletter for free today!
http://thirdpartyoffers.netzero.net/TGL3231/4be0477ea76d4349041st01vuc
