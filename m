From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/relocation.c:2502!
Date: Thu, 22 Sep 2011 09:42:27 +0800
Message-ID: <CAAM7YAntF+uBKk5XYWi2Re_x4L3xF8y7v0Mo-Fd09P7CFTeJZg@mail.gmail.com>
References: <4E79B712.50901@cn.fujitsu.com>
	<CAAM7YAkPAzqgGqDE3tfDNVLqj=2gDdqZOKdM6ZOzKrD37uGoww@mail.gmail.com>
	<20110921234203.GP22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef B
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110921234203.GP22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2011 at 7:42 AM, David Sterba <dave@jikos.cz> wrote:
> On Wed, Sep 21, 2011 at 06:57:56PM +0800, Yan, Zheng wrote:
>> modification to fs trees is not allowed after create_pending_snapshots()
>
> Do you have an idea whether there is a reasonable way to catch this in
> code? (even if only under a config option).
>

no idea
