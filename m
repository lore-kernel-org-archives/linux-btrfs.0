From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Wed, 14 Dec 2011 14:59:51 -0500
Message-ID: <4EE90037.6040105@cfl.rr.com>
References: <1323798951-4329-1-git-send-email-josef@redhat.com> <4EE7A172.2010105@cfl.rr.com> <20111213190942.GA3602@localhost.localdomain> <4EE804EB.5070209@cn.fujitsu.com> <4EE8707D.7080504@cn.fujitsu.com> <20111214145843.GA1925@localhost.localdomain> <4EE8BD45.7090809@cfl.rr.com> <20111214152638.GB1925@localhost.localdomain> <4EE8C391.9090501@cfl.rr.com> <20111214154624.GA10536@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Miao Xie <miaox@cn.fujitsu.com>, WuBo <wu.bo@cn.fujitsu.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111214154624.GA10536@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2011 10:46 AM, Josef Bacik wrote:
> file looks like its only 50m but still has 100g of extents taking up space
> orphan cleanup happens and the inode is truncated and the extra space is cleaned
> up

Yes, but isn't the only reason that the i_size change actually hit the 
disk is because of the orphan item?  So with no orphan item, the i_size 
remains at 100g.

