From: David Sterba <dave@jikos.cz>
Subject: Re: [BUG] kernel BUG at fs/btrfs/relocation.c:2502!
Date: Thu, 22 Sep 2011 01:42:03 +0200
Message-ID: <20110921234203.GP22205@twin.jikos.cz>
References: <4E79B712.50901@cn.fujitsu.com> <CAAM7YAkPAzqgGqDE3tfDNVLqj=2gDdqZOKdM6ZOzKrD37uGoww@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liu Bo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
To: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAM7YAkPAzqgGqDE3tfDNVLqj=2gDdqZOKdM6ZOzKrD37uGoww@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2011 at 06:57:56PM +0800, Yan, Zheng wrote:
> modification to fs trees is not allowed after create_pending_snapshots()

Do you have an idea whether there is a reasonable way to catch this in
code? (even if only under a config option).


david
