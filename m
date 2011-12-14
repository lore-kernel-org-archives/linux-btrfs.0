From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Wed, 14 Dec 2011 10:14:13 -0500
Message-ID: <4EE8BD45.7090809@cfl.rr.com>
References: <1323798951-4329-1-git-send-email-josef@redhat.com> <4EE7A172.2010105@cfl.rr.com> <20111213190942.GA3602@localhost.localdomain> <4EE804EB.5070209@cn.fujitsu.com> <4EE8707D.7080504@cn.fujitsu.com> <20111214145843.GA1925@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Miao Xie <miaox@cn.fujitsu.com>, WuBo <wu.bo@cn.fujitsu.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111214145843.GA1925@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2011 9:58 AM, Josef Bacik wrote:
> There is no "underlying bug", there is a shitty situation, the shitty situation

Maybe my assumptions are wrong somewhere then.  You add the orphan item 
to make sure that the truncate will be finalized even if the system 
crashes before the transaction commits right?  So if truncate() fails 
with -ENOSPC, then you shouldn't be trying to finalize the truncate on 
the next mount, should you ( because the call did not succeed )?

