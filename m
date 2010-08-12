From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC] why define "static int btrfs_csum_sizes[]" in a header
	file (ctree.h) ?
Date: Thu, 12 Aug 2010 11:08:47 -0400
Message-ID: <20100812150846.GG9349@dhcp231-156.rdu.redhat.com>
References: <AANLkTik7dgX=EppkoSTjiU_Wz4b35r3=FaYFPcDdwbNo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@redhat.com>
To: Cheng Renquan <crquan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik7dgX=EppkoSTjiU_Wz4b35r3=FaYFPcDdwbNo@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 12, 2010 at 08:46:54AM +0800, Cheng Renquan wrote:
> commit 607d432d referred a static int array defined in a header file,
> and a static inline function (btrfs_super_csum_size) using this array,
> the obvious result is every c file using that function would have
> a local copy of that int array, multiple c files referred multiple copies
> of that array:
> 
> $ nm fs/btrfs/btrfs.ko | grep btrfs_csum_sizes
> 0000010c r btrfs_csum_sizes
> 00000114 r btrfs_csum_sizes
> 000001c0 r btrfs_csum_sizes
> 000005a0 r btrfs_csum_sizes
> 
> the original commit has 4 c files called this static inline function, so
> till now there are still those 4 c files calling it, so there are 4 copies
> of btrfs_csum_sizes; but future code may call it in more c files;

Wow thats not my best work.  Change whatever you like, I think I'd rather just
not use a static array, but nothing better comes to mind atm, maybe a big switch
statement.  Thanks,

Josef
