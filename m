From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Date: Tue, 31 Aug 2010 15:01:09 -0700
Message-ID: <4C7D7BA5.6080607@noir.com>
References: <4C7AB645.5090804@wpkg.org>	<20100830001441.GA838@dhcp231-156.rdu.redhat.com>	<4C7BD569.9000702@noir.com> <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Josef Bacik <josef@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hch@infradead.org, gg.mariotti@gmail.com,
	"Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
	tytso@mit.edu
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 20100831 14:46, Mike Fedyk wrote:
 > There is little reason not to use duplicate metadata.  Only small
 > files (less than 2kb) get stored in the tree, so there should be no
 > worries about images being duplicated without data duplication set at
 > mkfs time.

My benchmarks show that for my kinds of data, btrfs is somewhat slower 
than ext4, (which is slightly slower than ext3 which is somewhat slower 
than ext2), when using the defaults, (ie, duplicate metadata).

It's a hair faster than ext2, (the fastest of the ext family), when 
using singleton metadata.  And ext2 isn't even crash resistant while 
btrfs has snapshots.

I'm using hardware raid for striping speed.  (Tried btrfs striping, it 
was close, but not as fast on my hardware).  I want speed, speed, speed. 
  My data is only vaguely important, (continuous builders), but speed is 
everything.

While the reason to use singleton metadata may be "little", it dominates 
my application.  If I were forced to use duplicate metadata then I'd 
still be arguing with my coworkers about whether the speed costs were 
worth it to buy snapshot functionality.  But the fact that btrfs is 
faster AND provides snapshots, (and less metadata overhead and bigger 
file systems and etc), makes for an easy sale.

Note that nilfs2 has similar performance, but somewhat different 
snapshot characteristics that aren't as useful in my current application.

--rich
