From: Tomas Carnecky <tomas.carnecky@gmail.com>
Subject: Re: Bug in btrfs_rename (kernel BUG at fs/btrfs/inode.c:5595!)
Date: Fri, 15 Jan 2010 00:59:12 +0100
Message-ID: <4B4FAFD0.1070304@gmail.com>
References: <4B4E1A5D.1070203@gmail.com>	 <20100113201317.GC2774@dhcp231-156.rdu.redhat.com>	 <4B4E290F.9010100@gmail.com>	 <20100114170323.GA2190@localhost.localdomain>	 <20100114190004.GB2190@localhost.localdomain> <3d0408631001141220m5941ad58t91d01fb918daf8ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408631001141220m5941ad58t91d01fb918daf8ab@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/14/2010 09:20 PM, Yan, Zheng wrote:
> It looks like a ENOSPC related problem, btrfs_truncate doesn't remove the orphan
> item if it fails to finish its operation. so I don't think this patch
> fixes the problem

Around the time when it happened, the filesystem was used only to ~55% 
(31G of 56G).

tom
